import 'address.dart';

class Individual {
  String id;
  String? name;
  Address? address;
  String? email;
  String? phone;
  String? pin;
  List<String>? roles;
  bool? isActive;

  Individual({
    required this.id,
    this.name,
    this.address,
    this.email,
    this.phone,
    this.pin,
    this.roles,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address?.toJson(),
      'email': email,
      'phone': phone,
      'pin': pin,
      'roles': roles == null ? roles : null,
      'is_active': isActive,
    };
  }

  factory Individual.fromJson(Map<String, dynamic> json) {
    var individual = Individual(
      id: json['id'],
      name: json['name'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      email: json['email'],
      phone: json['phone'],
      pin: json['pin'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      isActive: json['is_active'],
    );
    return individual;
  }
}
