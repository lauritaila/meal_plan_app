// lib/features/auth/presentation/providers/signup_form_provider.dart

import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:meal_plan_app/features/shared/shared.dart';

import '../provider.dart'; 
part 'sign_up_form_provider.g.dart';

class SignupFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name; 
  final Email email;
  final Password password;

  SignupFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(), 
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  SignupFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
  }) =>
      SignupFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
  SignupFormState:
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  name: $name
  email: $email
  password: $password
''';
  }
}

@riverpod
class SignupForm extends _$SignupForm {
  @override
  SignupFormState build() {
    return SignupFormState();
  }

  void onNameChanged(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password]),
    );
  }

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([state.name, newEmail, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.name, state.email, newPassword]),
    );
  }

  Future<void> onFormSubmitted() async {
    _touchEveryField();

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isPosting: true); 
    try {
      await ref.read(authRepositoryProvider).signUp(
            state.email.value,
            state.password.value,
            state.name.value
          );
    } catch (e) {
      ref.read(authProvider.notifier).showSnackbar(e.toString());
    } finally {
      state = state.copyWith(isPosting: false); 
    }
  }

  void _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true, 
      name: name,
      email: email,
      password: password,
      isValid: Formz.validate([name, email, password]),
    );
  }
}