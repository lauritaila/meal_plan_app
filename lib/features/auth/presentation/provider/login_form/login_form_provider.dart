import 'package:formz/formz.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/repository/repository_provider.dart';
import 'package:meal_plan_app/features/shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; 

part 'login_form_provider.g.dart';


class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
LoginFormState:
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  email: $email
  password: $password
''';
  }
}


@riverpod
class LoginForm extends _$LoginForm { 
  @override
  LoginFormState build() {
    return LoginFormState();
  }

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  Future<void> onFormSubmitted() async {
    _touchEveryField(); 

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isPosting: true);

    try {
      await ref.read(authRepositoryProvider).logIn(
        state.email.value,
        state.password.value,
      );

    } finally {
      state = state.copyWith(isPosting: false);
    }
  }
  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}