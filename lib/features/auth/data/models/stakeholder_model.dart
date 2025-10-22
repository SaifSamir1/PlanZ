import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

class StakeHolderModel {
  final IconData icon;
  final String titel;
  final String description;
  final UserType userType;

  StakeHolderModel({
    required this.icon,
    required this.titel,
    required this.description,
    required this.userType,
  });
}
