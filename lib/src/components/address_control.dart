import 'package:digit_exchange_client/src/components/editable_dropdown_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:digit_exchange_client/src/models/address.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/exchange_service.dart';
import 'editable_dropdown.dart';

class AddressControl extends StatefulWidget {
  final Address? initialAddress;
  const AddressControl({Key? key, this.initialAddress}) : super(key: key);

  @override
  _AddressControlState createState() => _AddressControlState();
}

class _AddressControlState extends State<AddressControl> {
  final ExchangeService _exchangeService = ExchangeService();

  final TextEditingController _doorNoController = TextEditingController();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final EditableDropdownController _boundaryController =
      EditableDropdownController();

  double? _latitude;
  double? _longitude;
  double? _locationAccuracy;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _getCurrentLocation();
  }

  void _initializeFields() {
    if (widget.initialAddress != null) {
      _doorNoController.text = widget.initialAddress!.doorNo ?? "";
      _buildingNameController.text = widget.initialAddress!.buildingName ?? "";
      _streetController.text = widget.initialAddress!.street ?? "";
      _addressLine1Controller.text = widget.initialAddress!.addressLine1 ?? "";
      _addressLine2Controller.text = widget.initialAddress!.addressLine2 ?? "";
      _landmarkController.text = widget.initialAddress!.landmark ?? "";
      _boundaryController.currentValue = widget.initialAddress!.boundary ?? "";
      // Initialize other fields as needed
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationAccuracy = position.accuracy;
    });
  }

  Address getAddress() {
    return Address(
      doorNo: _doorNoController.text,
      latitude: _latitude,
      longitude: _longitude,
      locationAccuracy: _locationAccuracy,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      landmark: _landmarkController.text,
      city: widget.initialAddress?.city, // Assuming these are set by boundary
      pincode: widget.initialAddress?.pincode,
      buildingName: _buildingNameController.text,
      street: _streetController.text,
      boundaryType: widget.initialAddress?.boundaryType, // Example
      boundary: _boundaryController.currentValue,
    );
  }

  void setAddress(Address address) {
    setState(() {
      // Update all controllers and GPS fields
      _doorNoController.text = address.doorNo!;
      _buildingNameController.text = address.buildingName!;
      _streetController.text = address.street!;
      _addressLine1Controller.text = address.addressLine1!;
      _addressLine2Controller.text = address.addressLine2!;
      _landmarkController.text = address.landmark!;
      _boundaryController.currentValue = address.boundary!;
      _latitude = address.latitude;
      _longitude = address.longitude;
      _locationAccuracy = address.locationAccuracy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Now you can safely access the LoginController
            final auth = Provider.of<AuthService>(context);
            return Column(
              children: <Widget>[
                TextField(
                    controller: _doorNoController,
                    decoration: const InputDecoration(labelText: 'Door No')),
                TextField(
                    controller: _buildingNameController,
                    decoration:
                        const InputDecoration(labelText: 'Building Name')),
                TextField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street')),
                TextField(
                    controller: _addressLine1Controller,
                    decoration:
                        const InputDecoration(labelText: 'Address Line 1')),
                TextField(
                    controller: _addressLine2Controller,
                    decoration:
                        const InputDecoration(labelText: 'Address Line 2')),
                TextField(
                    controller: _landmarkController,
                    decoration: const InputDecoration(labelText: 'Landmark')),
                EditableDropdown(
                  label: "Boundary",
                  fetchSuggestions: fetchBoundaries,
                  authService: auth,
                  controller:
                      _boundaryController, // You need to implement this method
                ),
                // Non-editable fields for city, state, country, and pincode
                // ...
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<String>> fetchBoundaries(
      AuthService auth, String searchString) async {
    // // Your logic to fetch suggestions based on the query
    // // Example:
    // return ['Suggestion 1', 'Suggestion 2', 'Suggestion 3']
    //     .where((item) => item.contains(query))
    //     .toList();
    return _exchangeService
        .addresses(auth, searchString)
        .then((List<Address> addresses) {
      return addresses.map((address) => address.boundary).toList();
    });
  }
}
