class Individual {
  String id;
  Address? address;
  String? email;
  String? phone;
  String? pin;
  List<String>? roles;
  bool? isActive;

  Individual({
    required this.id,
    this.address,
    this.email,
    this.phone,
    this.pin,
    this.roles,
    this.isActive,
  });

  factory Individual.fromJson(Map<String, dynamic> json) {
    return Individual(
      id: json['id'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      email: json['email'],
      phone: json['phone'],
      pin: json['pin'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      isActive: json['isActive'],
    );
  }
}

class Address {
  String? doorNo;
  double? latitude;
  double? longitude;
  double? locationAccuracy;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? city;
  String? pincode;
  String? buildingName;
  String? street;
  String? boundaryType;
  String? boundary;

  Address({
    this.doorNo,
    this.latitude,
    this.longitude,
    this.locationAccuracy,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.city,
    this.pincode,
    this.buildingName,
    this.street,
    this.boundaryType,
    this.boundary,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      doorNo: json['doorNo'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      locationAccuracy: json['locationAccuracy']?.toDouble(),
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      landmark: json['landmark'],
      city: json['city'],
      pincode: json['pincode'],
      buildingName: json['buildingName'],
      street: json['street'],
      boundaryType: json['boundaryType'],
      boundary: json['boundary'],
    );
  }
}
