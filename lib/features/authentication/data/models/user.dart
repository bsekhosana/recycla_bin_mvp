class User {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String mobile;
  final String country;
  final String city;
  final String area;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.country,
    required this.city,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      mobile: json['mobile'],
      country: json['country'],
      city: json['city'],
      area: json['area'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
