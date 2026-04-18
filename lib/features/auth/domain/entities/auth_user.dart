import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;

  const AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
  });

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, phone];
}
