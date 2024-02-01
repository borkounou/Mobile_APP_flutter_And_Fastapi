import 'dart:convert';

class UserToken {
  final String id;
  final String name;
  final String username;
  final String password;
  final String address;
  final String status;
  final String access_token;
  final String token_type;

  UserToken(
      {required this.id,
      required this.name,
      required this.username,
      required this.password,
      required this.address,
      required this.status,
      required this.access_token,
      required this.token_type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'address': address,
      'status': status,
      'access_token': access_token,
      'token_type': token_type
    };
  }

  factory UserToken.fromMap(Map<String, dynamic> map) {
    return UserToken(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? '',
      access_token: map['access_token'] ?? '',
      token_type: map['token_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserToken.fromJson(String source) =>
      UserToken.fromMap(json.decode(source));

  UserToken copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    String? address,
    String? status,
    String? access_token,
    String? token_type,
  }) {
    return UserToken(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      address: address ?? this.address,
      status: status ?? this.status,
      access_token: access_token ?? this.access_token,
      token_type: access_token ?? this.access_token,
    );
  }
}
