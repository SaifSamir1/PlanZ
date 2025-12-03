import 'package:easy_localization/easy_localization.dart';
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

  static List<PageModel> get pagesDetails => [
    PageModel(
      title: 'onboarding.title_1'.tr(),
      subTitle: 'onboarding.subtitle_1'.tr(),
      color: AppColors.primaryGold,
      progress: 0.33,
    ),
    PageModel(
      title: 'onboarding.title_2'.tr(),
      subTitle: 'onboarding.subtitle_2'.tr(),
      color: AppColors.blue300,
      progress: 0.66,
    ),
    PageModel(
      title: 'onboarding.title_3'.tr(),
      subTitle: 'onboarding.subtitle_3'.tr(),
      color: AppColors.primaryDark,
      progress: 1.0,
    ),
  ];
}
