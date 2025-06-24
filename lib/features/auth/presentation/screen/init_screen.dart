
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
          ),
          OutlinedButton(onPressed: (){
            context.push('/login');
          }, child: Text('Login')),
          SizedBox(height: 16),
          FilledButton(onPressed: (){}, child: Text('Register')),
        ],
      ),
    );
  }
}