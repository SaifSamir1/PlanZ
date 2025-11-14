import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        leading: BackButton(color: AppColors.background,),
        title: "Notifications",
        actions: [
          
          // User Avatar
          SlideInRight(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xfff8f9fa),
                radius: 19,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.buttonPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AttendeeCubit, AttendeeState>(
        builder: (context, state) {
          if (state is GetNotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetNotificationsError) {
            return Center(child: Text("⚠️ ${state.message}"));
          }

          if (state is GetNotificationsSuccess) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications yet 👀",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final type = notif['type'];
                final title = notif['title'] ?? "Notification";
                final message = notif['message'] ?? "";
                final time = notif['timestamp'] != null
                    ? DateTime.tryParse(notif['timestamp'].toString())
                    : null;

                IconData icon;
                Color color;

                switch (type) {
                  case "invitation":
                    icon = Icons.mail;
                    color = Colors.blue;
                    break;
                  case "update":
                    icon = Icons.refresh;
                    color = Colors.orange;
                    break;
                  case "reminder":
                    icon = Icons.alarm;
                    color = Colors.green;
                    break;
                  default:
                    icon = Icons.info;
                    color = Colors.grey;
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: time != null
                        ? Text(
                            "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          )
                        : null,
                  ),
                );
              },
            );
          }

          return const Center(child: Text("No notifications"));
        },
      ),
    );
  }
}
