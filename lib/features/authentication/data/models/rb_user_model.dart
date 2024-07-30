class RBUserModel {
  final String? id;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String hashedPassword;
  final String? hashedPin;
  final String? profilePicture;

  RBUserModel({
    this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.hashedPassword,
    this.hashedPin,
    required this.fullName,
    this.profilePicture
  });

  factory RBUserModel.fromMap(Map<String, dynamic> data) {
    return RBUserModel(
      id: data['id'] ,
      fullName: data['fullName'],
      username: data['username'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      hashedPassword: data['hashedPassword'],
      hashedPin: data['hashedPin'],
      profilePicture: data['profilePicture'],
    );
  }

  // Override toString to print user object
  @override
  String toString() {
    return 'User{id: $id, '
        'fullName: $fullName, '
        'phoneNumber: $phoneNumber, '
        'email: $email, '
        'username: $username '
        'hashedPin: $hashedPin '
        'hashedPassword: $hashedPassword '
        'profilePicture: $profilePicture '
        '}';
  }

  factory RBUserModel.fromJson(Map<String, dynamic> json) {
    return RBUserModel(
      id: json['id'],
      fullName: json['fullName'] ,
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      hashedPassword: json['hashedPassword'],
      hashedPin: json['hashedPin'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'hashedPassword': hashedPassword,
      'hashedPin': hashedPin,
      'profilePicture': profilePicture,
    };
  }

  // Method to update specific fields
  RBUserModel copyWith({
    String? username,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? hashedPassword,
    String? hashedPin,
    String? profilePicture,
  }) {
    return RBUserModel(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      hashedPin: hashedPin ?? this.hashedPin,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
