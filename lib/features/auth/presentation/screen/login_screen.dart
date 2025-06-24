import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {}
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Password',
              hint: 'Enter your password',
              obscureText: true,
              onChanged: (value) {}
            ),
            const SizedBox(height: 30),
            FilledButton(onPressed: () {}, style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              backgroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ), child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}