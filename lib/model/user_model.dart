

class User {
  String id;
  String name;
  String phone;
  String email;
  String password;
  String country;
  String city;
  String? profileImageUrl;

  User({
    required this.id,
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
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'country': country,
      'city': city,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> obj) {
    return User(
        id: obj['id'],
        name: obj['name'],
        phone: obj['phone'],
        email: obj['email'],
        password: obj['password'],
        country: obj['country'],
        city: obj['city'],
        profileImageUrl: obj['profileImageUrl'] ?? '',
    );
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
