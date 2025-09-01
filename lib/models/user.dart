class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? documentNumber;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? birthDate;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.documentNumber,
    this.address,
    this.city,
    this.country,
    this.birthDate,
    this.role = UserRole.client,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? documentNumber,
    String? address,
    String? city,
    String? country,
    DateTime? birthDate,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      documentNumber: documentNumber ?? this.documentNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum UserRole {
  client,
  owner,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.owner:
        return 'Propriétaire';
      case UserRole.admin:
        return 'Administrateur';
    }
  }
}