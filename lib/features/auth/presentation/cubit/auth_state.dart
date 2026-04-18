part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthUnverified extends AuthState {
  final String email;
  const AuthUnverified(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthOtpSent extends AuthState {
  final String email;
  const AuthOtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthPasswordResetEmailSent extends AuthState {
  final String email;
  const AuthPasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthPasswordResetSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
