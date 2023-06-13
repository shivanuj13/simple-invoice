import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String mobile;
  String address;
  String logoUrl;
  DateTime createdAt;
  String token;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.address,
    required this.logoUrl,
    required this.createdAt,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'mobile': mobile,
      'address': address,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      mobile: map['mobile'] ?? '',
      address: map['address'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, mobile: $mobile, address: $address, logoUrl: $logoUrl, createdAt: $createdAt, token: $token)';
  }
}


// {
//       "_id": "6485d453441aa213344da27e",
//       "name": "Anuj Kumar",
//       "email": "anuj@gmail.com",
//       "mobile": "9876543210",
//       "password": "$2b$10$ehaR6w2T9yVy9oURsitN0eNl7K8mR3aDgx0lDw2eZXjuFOIJV27uC",
//       "address": "abc,xyz",
//       "logoUrl": "",
//       "createdAt": "2023-06-11T14:04:03.925Z",
//       "updatedAt": "2023-06-11T14:04:03.925Z",
//       "__v": 0
//     }