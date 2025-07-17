import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_plan_app/features/shared/widgets/widgets.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomFilledButton(
                  text: 'Login',
                  buttonColor: colors.onPrimary,
                  textColor: colors.primary,
                  onPressed: () {
                    context.push('/login');
                  },
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomFilledButton(text: 'Register', onPressed: () {
                  context.push('/signup');
                }, buttonColor: colors.primary, textColor: colors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
