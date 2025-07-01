import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/shared.dart';
import '../provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _LoginForm(),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormState = ref.watch(loginFormProvider);
    final loginFormNotifier = ref.read(loginFormProvider.notifier);

    // ESCUCHANDO ERRORES DEL AUTHPROVIDER (¡AQUÍ ESTÁ EL CAMBIO PRINCIPAL!)
    ref.listen(authProvider, (previous, next) {
      if (next is ErrorAuthState) { // <--- Usamos 'is' para verificar el tipo
        showSnackbar(context, next.message); // Accedemos directamente a 'message'
      } else if (next is MessageAuthState) { // <--- Usamos 'is' para verificar el tipo
        showSnackbar(context, next.message); // Accedemos directamente a 'message'
      }
      // No hacemos nada para otros tipos de estado (InitialAuthState, LoadingAuthState, etc.)
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      // ... (el resto del código del build method es el mismo) ...
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        // ... (otros widgets) ...
        children: [
          // ... (text fields, buttons, etc.) ...
CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: loginFormNotifier.onEmailChanged,
            errorMessage: loginFormState.isFormPosted
                ? loginFormState.email.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: loginFormNotifier.onPasswordChanged,
            onFieldSubmitted: (_) => loginFormNotifier.onFormSubmitted(),
            errorMessage: loginFormState.isFormPosted
                ? loginFormState.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.black,
              onPressed: loginFormState.isPosting
                  ? null
                  : loginFormNotifier.onFormSubmitted,
            ),
          ),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Crea una aquí'),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}