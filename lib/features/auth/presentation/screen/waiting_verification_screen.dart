import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/provider.dart';

class WaitingVerificationScreen extends StatelessWidget {
  final String email;

  const WaitingVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _WaitingVerificationView(email));
  }
}

class _WaitingVerificationView extends ConsumerStatefulWidget {
  final String email;

  const _WaitingVerificationView(this.email);

  @override
  _WaitingVerificationViewState createState() =>_WaitingVerificationViewState();
}

class _WaitingVerificationViewState extends ConsumerState<_WaitingVerificationView> {
  
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void onResend() async {
    final auth = ref.read(authProvider.notifier);
    // try {
      await auth.sendMagicLink(widget.email);
      // showSnackBar(context, 'Verification link resent!');
    // } 
    // catch (e) {
      // showSnackBar(context,'Error: \\${e.toString()}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
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
              widget.email,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Back to Login'),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onResend, child: const Text('Resend Link')),
          ],
        ),
      ),
    );
  }
}
