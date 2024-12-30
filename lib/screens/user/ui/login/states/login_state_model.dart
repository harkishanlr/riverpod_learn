class LoginState {
  const LoginState();
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial();
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();
}

class LoginStateSuccess extends LoginState {
  const LoginStateSuccess();
}

class LoginStateError extends LoginState {
  final String error;

  const LoginStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginStateError &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
