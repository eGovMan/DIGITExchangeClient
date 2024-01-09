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

  Map<String, dynamic> toJson() {
    return {
      'doorNo': doorNo,
      'latitude': latitude,
      'longitude': longitude,
      'locationAccuracy': locationAccuracy,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'landmark': landmark,
      'city': city,
      'pincode': pincode,
      'buildingName': buildingName,
      'street': street,
      'boundaryType': boundaryType,
      'boundary': boundary,
    };
  }
}
