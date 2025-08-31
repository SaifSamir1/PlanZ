import 'package:flutter/material.dart';

void main() {
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Z',
      home: Scaffold(
        appBar: AppBar(title: const Text('Plan Z')),
        body: Center(child: Text("Hello World")),
      ),
    );
  }
}
