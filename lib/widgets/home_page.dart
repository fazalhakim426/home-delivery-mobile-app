import 'package:flutter/material.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      body: const Center(child: Text('Home Page')),
    );
  }
}