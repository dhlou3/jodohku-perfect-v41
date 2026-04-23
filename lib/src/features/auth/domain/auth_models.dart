enum AuthStatus {
  unauthenticated,
  authenticating,
  awaitingOtp,
  authenticated,
  error
}

class JodohkuAuthState {
  final AuthStatus status;
  final String? email;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final String? errorMessage;

  JodohkuAuthState({
    this.status = AuthStatus.unauthenticated,
    this.email,
    this.biometricAvailable = false,
    this.biometricEnabled = false,
    this.errorMessage,
  });

  JodohkuAuthState copyWith({
    AuthStatus? status,
    String? email,
    bool? biometricAvailable,
    bool? biometricEnabled,
    String? errorMessage,
  }) {
    return JodohkuAuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
