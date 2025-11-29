import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final currentUser = UserManager().currentUser;
    if (currentUser != null) {
      setState(() {
        _nameController.text = currentUser.name;
        _phoneController.text = currentUser.phoneNumber ?? '';
      });
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: AppColors.buttonPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Update your profile information',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // ✅ Name TextField
                TextField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(fontSize: 13),
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.person, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.buttonPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Phone TextField
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(fontSize: 13),
                    hintText: '+20 123 456 7890',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.phone, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.buttonPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.primaryDark),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final newName = _nameController.text.trim();
                          final newPhone = _phoneController.text.trim();

                          // Validation
                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('auth.enter_full_name'.tr()),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            final userId = UserManager().userId;

                            if (user != null && userId != null) {
                              // 1. Update Firebase Auth
                              await user.updateDisplayName(newName);

                              // 2. Update Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .set({
                                    'name': newName,
                                    'phoneNumber': newPhone.isNotEmpty
                                        ? newPhone
                                        : null,
                                  }, SetOptions(merge: true));

                              // 3. Update UserManager
                              await UserManager().updateUserFields(
                                name: newName,
                                phoneNumber: newPhone.isNotEmpty
                                    ? newPhone
                                    : null,
                              );

                              if (!mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'settings.username_updated'.tr(),
                                  ),
                                  backgroundColor: AppColors.accentGreen,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              setState(() {});
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'settings.error'.tr(args: [e.toString()]),
                                  ),
                                  backgroundColor: AppColors.error,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserManager().currentUser;

    return Card(
      elevation: 3,
      color: AppColors.background,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              FadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonPrimary.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.buttonPrimary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: SlideInLeft(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.name ?? 'User',
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentUser?.email ?? 'No email',
                        style: TextStyle(
                          color: AppColors.primaryDark.withOpacity(0.6),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      if (currentUser?.phoneNumber != null &&
                          (currentUser?.phoneNumber ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            currentUser?.phoneNumber ?? '',
                            style: TextStyle(
                              color: AppColors.primaryDark.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SlideInRight(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 400),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonPrimary.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showEditDialog,
                      borderRadius: BorderRadius.circular(14),
                      child: Icon(
                        Icons.edit_outlined,
                        color: AppColors.buttonPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
