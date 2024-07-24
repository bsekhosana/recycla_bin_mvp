class User {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      id: documentId,
      username: data['username'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
    );
  }

  // Override toString to print user object
  @override
  String toString() {
    return 'User{id: $id, phoneNumber: $phoneNumber, email: $email, username: $username}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
