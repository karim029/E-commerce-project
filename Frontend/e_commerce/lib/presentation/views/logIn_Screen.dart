import 'package:flutter/material.dart';
import 'package:e_commerce/presentation/widgets/logIn_widget.dart';

class logInScreen extends StatelessWidget {
  const logInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shop'),
      ),
      body: LogInWidget(),
    );
  }
}
