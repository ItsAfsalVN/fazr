// lib/models/user_model.dart

class UserModel {
  final String id;
  final String fullname;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    this.avatar,
  });

  // A 'copyWith' method makes updating the user object cleaner.
  UserModel copyWith({
    String? id,
    String? fullname,
    String? email,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullname': fullname, 'email': email, 'avatar': avatar};
  }
}