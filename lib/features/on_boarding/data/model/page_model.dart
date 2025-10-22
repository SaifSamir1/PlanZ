import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class PageModel {
  final String title;
  final String subTitle;
  final Color color;
  final double progress;

  PageModel({
    required this.title,
    required this.subTitle,
    required this.color,
    required this.progress,
  });

  static List<PageModel> pagesDetails = [
    PageModel(
      title: 'Create Your Event in Minutes',
      subTitle:
          'Pick your event type, set a budget, explore vendors, and preview your event before booking.',
      color: AppColors.primaryGold,
      progress: 0.33,
    ),
    PageModel(
      title: 'Grow Your Business',
      subTitle:
          "Add packages, set prices, and get discovered by event organizers looking for your services.",
      color: AppColors.blue300,
      progress: 0.66,
    ),
    PageModel(
      title: 'Stay Connected',
      subTitle:
          "Receive invitations, RSVP instantly, and get reminders — never miss an event.",
      color: AppColors.primaryDark,
      progress: 1.0,
    ),
  ];
}
