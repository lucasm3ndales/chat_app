

class User {
  String name;
  String phone;
  String email;
  String password;
  String? country;
  String? city;
  String? bio;
  String? profileImageUrl;

  User({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.country,
    this.city,
    this.profileImageUrl,
    this.bio,
  });
}
