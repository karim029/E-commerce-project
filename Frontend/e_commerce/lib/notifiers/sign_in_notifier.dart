import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/model/signin_user_model.dart';
import 'package:e_commerce/providers/userRepository_provider.dart';
import 'package:e_commerce/repositories/user_Repository.dart';

class SignInNotifier extends Notifier<SignInState> {
  late final UserRepository _userRepository;
  SignInUserModel user = SignInUserModel(
    signInUserEmail: '',
    signInPass: '',
  );
  @override
  SignInState build() {
    _userRepository = ref.watch(userRepositoryProvider);
    return SignInState.initial();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateVerificationCode(String code) {
    state = state.copyWith(verificationCode: code);
  }

  bool validateFields() {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'All fields are required');
      return false;
    }
    if (!state.email.contains('@')) {
      state = state.copyWith(errorMessage: 'Invalid email');
      return false;
    }
    return true;
  }

  void logoutUser() {
    state = SignInState.initial();
  }

  Future<void> signInUser() async {
    if (!validateFields()) {
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    user = SignInUserModel(
      signInUserEmail: state.email,
      signInPass: state.password,
    );

    try {
      final response = await _userRepository.signInUser(user);
      if (response.success) {
        // take the userid from the response body
        state = SignInState.success(
          name: response.name,
          userId: response.userId,
        );
      } else {
        state = state.copyWith(
            isLoading: false, errorMessage: response.error, isSignedIn: false);
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred. Please try again.');
    }
  }

  Future<bool> requestCode(String email) async {
    try {
      final response = await _userRepository.requestPassResetCode(email);
      if (response.success) {
        state.copyWith(
          errorMessage: response.message,
        );
        return true;
      } else {
        state = state.copyWith(
          errorMessage: 'Email doesn\'t exist',
        );
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyResetCode(String email, String resetCode) async {
    try {
      final response = await _userRepository.verifyResetCode(email, resetCode);
      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          verificationCode: resetCode,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while verifying the reset code.',
      );
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      final response =
          await _userRepository.resetPassword(state.email, newPassword);
      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while resetting the password.',
      );
      return false;
    }
  }
}

class SignInState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final bool isSignedIn;
  final String? name;
  String? userId;
  String? verificationCode;

  SignInState(
      {required this.email,
      required this.password,
      required this.isLoading,
      required this.isSignedIn,
      this.verificationCode,
      this.errorMessage,
      this.name,
      this.userId});

  factory SignInState.initial() {
    return SignInState(
      email: '',
      password: '',
      isLoading: false,
      isSignedIn: false,
    );
  }

  factory SignInState.success({String? userId, String? name}) {
    return SignInState(
      email: '',
      password: '',
      isLoading: false,
      isSignedIn: true,
      userId: userId,
      name: name,
    );
  }

  SignInState copyWith(
      {String? email,
      String? password,
      String? verificationCode,
      String? name,
      bool? isLoading,
      bool? isSignedIn,
      String? errorMessage,
      String? userId}) {
    return SignInState(
        verificationCode: verificationCode ?? this.verificationCode,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
        isSignedIn: isSignedIn ?? this.isSignedIn,
        errorMessage: errorMessage ?? this.errorMessage,
        userId: userId ?? this.userId);
  }
}

final signInNotifierProvider =
    NotifierProvider<SignInNotifier, SignInState>(() {
  return SignInNotifier();
});
