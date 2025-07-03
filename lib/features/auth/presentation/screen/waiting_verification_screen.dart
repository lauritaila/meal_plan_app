import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WaitingVerificationScreen extends StatelessWidget {
  final String email;
  final VoidCallback? onResend;

  const WaitingVerificationScreen({super.key, required this.email, this.onResend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Check your email',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a magic link to:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Back to Login'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onResend,
                child: const Text('Resend Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 