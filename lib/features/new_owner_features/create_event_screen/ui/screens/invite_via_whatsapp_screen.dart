// lib/features/new_owner_features/invitations/ui/screens/invite_via_whatsapp_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteViaWhatsAppScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final DateTime eventDate;

  const InviteViaWhatsAppScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
  });

  @override
  State<InviteViaWhatsAppScreen> createState() => _InviteViaWhatsAppScreenState();
}

class _InviteViaWhatsAppScreenState extends State<InviteViaWhatsAppScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final List<Map<String, String>> _invitedContacts = [];

  @override
  void initState() {
    super.initState();
    _messageController.text = _getDefaultMessage();
  }

  String _getDefaultMessage() {
    return '''
🎉 You're Invited! 🎉

Event: ${widget.eventName}
Date: ${widget.eventDate.day}/${widget.eventDate.month}/${widget.eventDate.year}

We would love to have you join us for this special occasion!

Please confirm your attendance through our app: Plan Z

Looking forward to seeing you there! 💕
''';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Invite via WhatsApp',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Info Card
              _buildEventInfoCard(),
              
              const SizedBox(height: 24),
              
              // Instructions
              _buildInstructions(),
              
              const SizedBox(height: 24),
              
              // Guest Name Field
              _buildNameField(),
              
              const SizedBox(height: 16),
              
              // Phone Number Field
              _buildPhoneField(),
              
              const SizedBox(height: 24),
              
              // Message Preview
              _buildMessagePreview(),
              
              const SizedBox(height: 24),
              
              // Send Button
              _buildSendButton(),
              
              const SizedBox(height: 24),
              
              // Recently Invited
              if (_invitedContacts.isNotEmpty) _buildRecentlyInvited(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event,
              color: AppColors.primaryGold,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.eventDate.day}/${widget.eventDate.month}/${widget.eventDate.year}',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primaryGold,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '1. Enter guest name and phone number\n'
                  '2. Customize the invitation message\n'
                  '3. Send via WhatsApp directly\n'
                  '4. Guest receives personalized invitation',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Name',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter guest name',
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryGold),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGold,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter guest name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
          decoration: InputDecoration(
            hintText: 'e.g., 01012345678',
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            prefixIcon: const Icon(Icons.phone, color: AppColors.primaryGold),
            prefixText: '+20 ',
            prefixStyle: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGold,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          '💡 Tip: Enter number without country code (+20)',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invitation Message',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _messageController.text = _getDefaultMessage();
                });
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textSecondary.withOpacity(0.2),
            ),
          ),
          child: TextFormField(
            controller: _messageController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Customize your invitation message...',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Message preview looks good!',
              style: AppTextStyles.body.copyWith(
                color: AppColors.success,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _sendWhatsAppInvitation,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.send, size: 24),
        label: Text(
          _isLoading ? 'Sending...' : 'Send via WhatsApp',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff25D366), // WhatsApp Green
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildRecentlyInvited() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Invited',
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _invitedContacts.clear();
                });
              },
              child: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _invitedContacts.length,
          itemBuilder: (context, index) {
            final contact = _invitedContacts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['name']!,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+20${contact['phone']}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Sent ✓',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _sendWhatsAppInvitation() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    // setState(() {
    //   _isLoading = true;
    // });

    // try {
    //   final String phone = '20${_phoneController.text.trim()}'; // Egypt code
    //   final String message = _messageController.text;
      
    //   // WhatsApp URL
    //   final Uri whatsappUrl = Uri.parse(
    //     'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    //   );

    //   // Try to launch WhatsApp
    //   if (await canLaunchUrl(whatsappUrl)) {
    //     await launchUrl(
    //       whatsappUrl,
    //       mode: LaunchMode.externalApplication,
    //     );

    //     // Add to recently invited
    //     setState(() {
    //       _invitedContacts.insert(0, {
    //         'name': _nameController.text.trim(),
    //         'phone': _phoneController.text.trim(),
    //       });
    //     });

    //     // Show success message
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Row(
    //             children: [
    //               const Icon(Icons.check_circle, color: Colors.white),
    //               const SizedBox(width: 12),
    //               Expanded(
    //                 child: Text(
    //                   'WhatsApp opened! Send the message to ${_nameController.text}',
    //                 ),
    //               ),
    //             ],
    //           ),
    //           backgroundColor: AppColors.success,
    //           behavior: SnackBarBehavior.floating,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //         ),
    //       );
    //     }

    //     // Clear form
    //     _phoneController.clear();
    //     _nameController.clear();
    //     _messageController.text = _getDefaultMessage();
    //   } else {
    //     throw Exception('Could not launch WhatsApp');
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Row(
    //           children: [
    //             const Icon(Icons.error_outline, color: Colors.white),
    //             const SizedBox(width: 12),
    //             const Expanded(
    //               child: Text('Failed to open WhatsApp. Please try again.'),
    //             ),
    //           ],
    //         ),
    //         backgroundColor: AppColors.error,
    //         behavior: SnackBarBehavior.floating,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //       ),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
  }
}
