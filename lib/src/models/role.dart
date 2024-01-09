enum Role { ADMIN, AGENCY_ADMIN }

List<String> enumToStringList(Role enumType) {
  return Role.values
      .map((e) => e.toString().split('.').last) // Get the string after the dot
      .toList();
}
