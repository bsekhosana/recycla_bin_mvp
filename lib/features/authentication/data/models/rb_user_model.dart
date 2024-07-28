class RBUserModel {
  final String? id;
  final String username;
  final String email;
  final String phoneNumber;
  final String hashedPassword;
  final String? hashedPin;

  RBUserModel({
    this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.hashedPassword,
    this.hashedPin
  });

  factory RBUserModel.fromMap(Map<String, dynamic> data) {
    return RBUserModel(
      id: data['id'] ,
      username: data['username'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      hashedPassword: data['hashedPassword'],
      hashedPin: data['hashedPin'],
    );
  }

  // Override toString to print user object
  @override
  String toString() {
    return 'User{id: $id, '
        'phoneNumber: $phoneNumber, '
        'email: $email, '
        'username: $username '
        'hashedPin: $hashedPin '
        'hashedPassword: $hashedPassword '
        '}';
  }

  factory RBUserModel.fromJson(Map<String, dynamic> json) {
    return RBUserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      hashedPassword: json['hashedPassword'],
      hashedPin: json['hashedPin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'hashedPassword': hashedPassword,
      'hashedPin': hashedPin,
    };
  }
}
