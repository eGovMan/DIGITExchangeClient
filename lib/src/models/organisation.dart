import 'address.dart';

class Organisation {
  String id;
  List<OrganisationRole?> orgRoles;
  String name;
  // Address address; // Define Address as a class
  String digitExchangeUrl;
  bool isActive;
  String administratorId;

  Organisation({
    required this.id,
    required this.orgRoles,
    required this.name,
    // required this.address,
    this.digitExchangeUrl = '',
    this.isActive = false,
    required this.administratorId,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) {
    // Ensure that we have a List<String> from the JSON
    List<String> rolesString =
        (json['organisation_roles'] as List<dynamic>).cast<String>();

    // Convert the list of role strings to a list of OrganisationRole enums
    List<OrganisationRole> roles = rolesString
        .map((e) => OrganisationRoleExtension.parse(e))
        .whereType<OrganisationRole>() // This filters out any nulls
        .toList();

    return Organisation(
      id: json['id'] ?? '',
      orgRoles: roles,
      name: json['name'] ?? '',
      // address: Address.fromJson(json['address']), // Implement Address.fromJson
      digitExchangeUrl: json['digit_exchange_uri'] ?? '',
      isActive: json['is_active'] ?? false,
      administratorId: json['administrator_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organisation_roles': orgRoles.map((e) => e?.description).toList(),
      'name': name,
      // 'address': address.toJson(),
      'digit_exchange_uri': digitExchangeUrl,
      'is_active': isActive,
      'administrator_id': administratorId,
    };
  }
}

// Parsing method for OrganisationRole enum
OrganisationRole parseOrganisationRole(String roleString) {
  return OrganisationRole.values.firstWhere(
    (e) => e.toString().split('.').last == roleString,
    orElse: () => OrganisationRole.FUNDING_AGENCY, // Default value if not found
  );
}

// Example implementation for OrganisationRole
enum OrganisationRole {
  // ignore: constant_identifier_names
  FUNDING_AGENCY,
  // ignore: constant_identifier_names
  IMPLEMENTING_AGENCY,
}

extension OrganisationRoleExtension on OrganisationRole {
  String get description {
    switch (this) {
      case OrganisationRole.IMPLEMENTING_AGENCY:
        return "IMPLEMENTING_AGENCY";
      case OrganisationRole.FUNDING_AGENCY:
        return "FUNDING_AGENCY";
      default:
        return toString().split('.').last;
    }
  }

  static OrganisationRole? parse(String role) {
    switch (role) {
      case "IMPLEMENTING_AGENCY":
        return OrganisationRole.IMPLEMENTING_AGENCY;
      case "FUNDING_AGENCY":
        return OrganisationRole.FUNDING_AGENCY;
      // Add cases for other string values
      default:
        return null; // or handle unknown role string appropriately
    }
  }
}
