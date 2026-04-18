import '../../domain/entities/auth_user.dart';

class UserModel extends AuthUser {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.avatarUrl,
    super.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final metadata = map['user_metadata'] as Map<String, dynamic>?;
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: metadata?['full_name'] as String?,
      avatarUrl: metadata?['avatar_url'] as String?,
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'user_metadata': {
        'full_name': fullName,
        'avatar_url': avatarUrl,
      },
      'phone': phone,
    };
  }
}
