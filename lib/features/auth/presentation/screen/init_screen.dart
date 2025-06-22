
import 'package:flutter/material.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
          ),
          OutlinedButton(onPressed: (){}, child: Text('Login')),
          SizedBox(height: 16),
          FilledButton(onPressed: (){}, child: Text('Register')),
        ],
      ),
    );
  }
}