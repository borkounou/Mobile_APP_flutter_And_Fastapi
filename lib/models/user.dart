import 'dart:convert';

class User {
  final String id;
  final String name;
  final String username;
  final String password;
  final String address;
  final String status;
  final String access_token;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.address,
    required this.status,
    required this.access_token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'address': address,
      'status': status,
      'access_token': access_token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? '',
      access_token: map['access_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    String? address,
    String? status,
    String? access_token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      address: address ?? this.address,
      status: status ?? this.status,
      access_token: access_token ?? this.access_token,
    );
  }
}
