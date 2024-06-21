

class User {
  String uid;
  String name;
  String phone;
  String email;
  String password;
  String country;
  String city;
  String? profileImageUrl;

  User({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.country,
    required this.city,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'country': country,
      'city': city,
    };
  }
}

class UserDTO {
  String name;
  String phone;
  String email;
  String password;
  String country;
  String city;

  UserDTO({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.country,
    required this.city
  });
}
