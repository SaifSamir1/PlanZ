import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/auth/ui/screens/profile_screen.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/create_event_screen.dart';

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
      home: ProfileScreen(),
      // title: 'PlanZ Chat',
      debugShowCheckedModeBanner: false,
      // home: BlocProvider(
      //   create: (context) => ChatCubit(),
      //   child: const CreateEventScreen(),
      // ),
    );
  }
}
