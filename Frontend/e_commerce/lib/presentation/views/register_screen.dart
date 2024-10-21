import 'package:flutter/material.dart';
import 'package:e_commerce/presentation/widgets/register_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shop'),
      ),
      body: RegisterWidget(),
    );
  }
}
