import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/navigation_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  Intl.defaultLocale = 'ar';
  
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanZ Chat',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ChatCubit(),
        child: const NavigationScreen(),
      ),
    );
  }
}