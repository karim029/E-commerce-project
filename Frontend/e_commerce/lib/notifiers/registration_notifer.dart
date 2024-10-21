import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/repositories/user_Repository.dart';
import 'package:e_commerce/model/register_model.dart';
import 'package:e_commerce/providers/userRepository_provider.dart';

class RegistrationNotifier extends Notifier<RegistrationState> {
  late final UserRepository _userRepository;
  Timer? _resendButtonTimer;

  @override
  RegistrationState build() {
    _userRepository = ref.watch(userRepositoryProvider);
    ref.onDispose(() {
      _resendButtonTimer?.cancel();
    });
    return RegistrationState.initial();
  }

  void ResendButtonTimerCooldown() {
    state = state.copyWith(canResendEmail: false, remainingTime: 60);

    _resendButtonTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        final newRemainingTime = state.remainingTime - 1;
        if (newRemainingTime <= 0) {
          timer.cancel();
          state = state.copyWith(remainingTime: 0, canResendEmail: true);
        } else {
          state = state.copyWith(remainingTime: newRemainingTime);
        }
      },
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  bool validateFields() {
    if (state.name.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty) {
      state = state.copyWith(message: 'All fields are required');
      return false;
    }
    if (!state.email.contains('@')) {
      state = state.copyWith(message: 'Invalid email');
      return false;
    }
    if (state.password != state.confirmPassword) {
      state = state.copyWith(message: 'Passwords do not match');
      return false;
    }
    return true;
  }

  void logoutUser() {
    state = RegistrationState.initial();
  }

  Future<void> registerUser() async {
    if (!validateFields()) {
      return;
    }
    state = state.copyWith(
      isLoading: true,
      message: null,
    );

    final user = RegUserModel(
      name: state.name,
      email: state.email,
      password: state.password,
    );

    try {
      final response = await _userRepository.registerUser(user);
      if (response.success) {
        state = RegistrationState.success(userId: user.userId);
      } else {
        String? errorMsg = response.error;
        if (errorMsg == 'Email is already registered') {
          errorMsg =
              'This email is already in use. Please use a different email.';
        }
        state = state.copyWith(isLoading: false, message: errorMsg);
      }
    } catch (e) {
      print('Error: $e');
      state = state.copyWith(
          isLoading: false, message: 'An error occurred. Please try again.');
    }
  }

  Future<void> verifyUser() async {
    try {
      final response =
          await _userRepository.checkEmailVerification(state.userId!);
      if (response) {
        state = state.copyWith(isVerified: true);
      } else {
        state = state.copyWith(message: 'User not verified... try again');
      }
    } catch (e) {
      state = state.copyWith(
          isVerified: false, message: 'An error occurred. Please try again.');
    }
  }

  Future<void> resendVerification() async {
    if (!state.canResendEmail) return;

    state = state.copyWith(message: null);
    ResendButtonTimerCooldown();
    try {
      final response =
          await _userRepository.resendVerificationEmail(state.userId!);
      if (response.success) {
        state = state.copyWith(message: response.message);
      } else {
        state = state.copyWith(message: response.message);
      }
    } catch (e) {
      print('Error: $e');

      state = state.copyWith(message: 'An error occurred. Please try again.');
    }
  }
}

class RegistrationState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? message;
  final bool isRegistered;
  final bool? isVerified;
  final String? userId;
  final bool canResendEmail;
  final int remainingTime;

  RegistrationState({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isLoading,
    required this.isRegistered,
    required this.canResendEmail,
    required this.remainingTime,
    this.message,
    this.userId,
    this.isVerified,
  });

  factory RegistrationState.initial() {
    return RegistrationState(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      isRegistered: false,
      isVerified: false,
      userId: null,
      canResendEmail: true,
      remainingTime: 0,
    );
  }

  factory RegistrationState.success({String? userId}) {
    return RegistrationState(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      isRegistered: true,
      isVerified: false,
      userId: userId,
      canResendEmail: true,
      remainingTime: 0,
    );
  }

  RegistrationState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? message,
    bool? isVerified,
    bool? isRegistered,
    String? userId,
    bool? canResendEmail,
    int? remainingTime,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isRegistered: isRegistered ?? this.isRegistered,
      isVerified: isVerified ?? this.isVerified,
      userId: userId ?? this.userId,
      canResendEmail: canResendEmail ?? this.canResendEmail,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

final registrationNotifierProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(() {
  return RegistrationNotifier();
});
