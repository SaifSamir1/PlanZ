import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';

enum PaymentOption { creditCard, paypal, applePay }

enum InvitationTemplate { elegant, geometric, rustic, vibrant }

class PaymentAndInvitationsScreen extends StatefulWidget {
  const PaymentAndInvitationsScreen({super.key});

  @override
  State<PaymentAndInvitationsScreen> createState() =>
      _PaymentAndInvitationsScreenState();
}

class _PaymentAndInvitationsScreenState
    extends State<PaymentAndInvitationsScreen> {
  PaymentOption? _selectedPayment;
  InvitationTemplate? _selectedTemplate;
  final TextEditingController _attendeesController = TextEditingController();

  @override
  void dispose() {
    _attendeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'event_owner.payment_and_invitation_screen.title'.tr(),
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentSection(),
            const SizedBox(height: 28),
            _buildEventDetailsSection(),
            const SizedBox(height: 28),
            _buildInvitationTemplatesSection(),
            const SizedBox(height: 30),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'event_owner.payment_and_invitation_screen.payment_options'.tr(),
            style: AppTextStyles.title,
          ),
        ),
        const SizedBox(height: 16),
        SlideInLeft(
          duration: const Duration(milliseconds: 700),
          child: _buildPaymentOption(
            title: 'event_owner.payment_and_invitation_screen.credit_card'.tr(),
            icon: Icons.credit_card_rounded,
            value: PaymentOption.creditCard,
          ),
        ),
        SlideInLeft(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 100),
          child: _buildPaymentOption(
            title: 'event_owner.payment_and_invitation_screen.paypal'.tr(),
            icon: Icons.account_balance_wallet_rounded,
            value: PaymentOption.paypal,
          ),
        ),
        SlideInLeft(
          duration: const Duration(milliseconds: 900),
          delay: const Duration(milliseconds: 200),
          child: _buildPaymentOption(
            title: 'event_owner.payment_and_invitation_screen.apple_pay'.tr(),
            icon: Icons.apple_rounded,
            value: PaymentOption.applePay,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'event_owner.payment_and_invitation_screen.event_details'.tr(),
            style: AppTextStyles.title,
          ),
        ),
        const SizedBox(height: 16),
        SlideInRight(
          duration: const Duration(milliseconds: 700),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _attendeesController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                labelText:
                    'event_owner.payment_and_invitation_screen.number_of_attendees'
                        .tr(),
                labelStyle: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.people_outline_rounded,
                    color: AppColors.primaryDark.withOpacity(0.7),
                    size: 24,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'event_owner.payment_and_invitation_screen.invitation_templates'
                .tr(),
            style: AppTextStyles.title,
          ),
        ),
        const SizedBox(height: 16),
        SlideInUp(
          duration: const Duration(milliseconds: 700),
          child: _buildTemplateOption(
            title: 'event_owner.payment_and_invitation_screen.elegant_floral'
                .tr(),
            description:
                'event_owner.payment_and_invitation_screen.elegant_desc'.tr(),
            image:
                'assets/images/romantic-wedding-invitation-card-with-greenery-floral-free-png.webp',
            value: InvitationTemplate.elegant,
          ),
        ),
        SlideInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 100),
          child: _buildTemplateOption(
            title: 'event_owner.payment_and_invitation_screen.modern_geometric'
                .tr(),
            description: 'event_owner.payment_and_invitation_screen.modern_desc'
                .tr(),
            image: 'assets/images/download.png',
            value: InvitationTemplate.geometric,
          ),
        ),
        SlideInUp(
          duration: const Duration(milliseconds: 900),
          delay: const Duration(milliseconds: 200),
          child: _buildTemplateOption(
            title: 'event_owner.payment_and_invitation_screen.rustic_charm'
                .tr(),
            description: 'event_owner.payment_and_invitation_screen.rustic_desc'
                .tr(),
            image: 'assets/images/rustic_charm.png',
            value: InvitationTemplate.rustic,
          ),
        ),
        SlideInUp(
          duration: const Duration(milliseconds: 1000),
          delay: const Duration(milliseconds: 300),
          child: _buildTemplateOption(
            title:
                'event_owner.payment_and_invitation_screen.vibrant_celebration'
                    .tr(),
            description:
                'event_owner.payment_and_invitation_screen.vibrant_desc'.tr(),
            image: 'assets/images/vibrant_celebration.png',
            value: InvitationTemplate.vibrant,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required PaymentOption value,
  }) {
    final isSelected = _selectedPayment == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryGold : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPayment = value;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGold.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryGold
                        : AppColors.primaryDark.withOpacity(0.7),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                Radio<PaymentOption>(
                  value: value,
                  groupValue: _selectedPayment,
                  onChanged: (PaymentOption? newValue) {
                    setState(() {
                      _selectedPayment = newValue;
                    });
                  },
                  activeColor: AppColors.primaryGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateOption({
    required String title,
    required String description,
    required String image,
    required InvitationTemplate value,
  }) {
    final isSelected = _selectedTemplate == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryGold : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTemplate = value;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.primaryDark.withOpacity(0.5),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.primaryDark.withOpacity(0.6),
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Radio<InvitationTemplate>(
                  value: value,
                  groupValue: _selectedTemplate,
                  onChanged: (InvitationTemplate? newValue) {
                    setState(() {
                      _selectedTemplate = newValue;
                    });
                  },
                  activeColor: AppColors.primaryGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SlideInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle AR preview
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.view_in_ar_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'event_owner.payment_and_invitation_screen.preview_ar'
                              .tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SlideInUp(
            duration: const Duration(milliseconds: 900),
            delay: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle confirm and send invitations
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'event_owner.payment_and_invitation_screen.confirm_send'
                              .tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
