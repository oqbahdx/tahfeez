import '../../domain/entities/user.dart';

class UserModel extends User {
  String? password;

  UserModel({
    required super.id,
    super.userName,
    required super.email,
    super.role,
    super.isActive,
    super.fullName,
    super.createdAt,
    super.updatedAt,
    super.status,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      userName: json['userName'],
      email: json['email'] ?? '',
      role: json['role'],
      isActive: json['isActive'],
      fullName: json['fullName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'role': role,
      'isActive': isActive,
      'fullName': fullName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'role': role,
      'isActive': isActive ?? true,
    };
  }
}
