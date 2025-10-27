// lib/features/events/presentation/screens/select_event_type_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';

class SelectEventTypeScreen extends StatelessWidget {
  const SelectEventTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Event Type',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Text Section
              _buildIntroSection(),

              const SizedBox(height: 24),

              // Event Types Grid
              Expanded(
                child: _buildEventTypesGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Intro Section Widget
  Widget _buildIntroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Event',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the type of event you want to create and we\'ll help you plan every detail',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Event Types Grid Widget
  Widget _buildEventTypesGrid(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.73,
      ),
      itemCount: _mockEventTypes.length,
      itemBuilder: (context, index) {
        final eventType = _mockEventTypes[index];
        return EventTypeCard(
          eventType: eventType,
          onTap: () => _onEventTypeSelected(context, eventType),
        );
      },
    );
  }

  /// Handle Event Type Selection
  void _onEventTypeSelected(BuildContext context, Map<String, dynamic> eventType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${eventType['name']}',
          style: const TextStyle(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicEventInfoScreen(
          eventType: eventType,
        ),
      ),
    );
  }

  /// Mock Data - Event Types
  static final List<Map<String, dynamic>> _mockEventTypes = [
    {
      'id': 'evt_wedding',
      'name': 'Wedding',
      'nameAr': 'حفل زفاف',
      'icon': '💒',
      'description': 'Plan your perfect wedding day',
      'descriptionAr': 'خطط ليوم زفافك المثالي',
      'color': AppColors.accentPurple,
    },
    {
      'id': 'evt_birthday',
      'name': 'Birthday Party',
      'nameAr': 'حفلة عيد ميلاد',
      'icon': '🎂',
      'description': 'Celebrate your special day',
      'descriptionAr': 'احتفل بيومك الخاص',
      'color': AppColors.info,
    },
    {
      'id': 'evt_corporate',
      'name': 'Corporate Event',
      'nameAr': 'حدث شركات',
      'icon': '💼',
      'description': 'Professional business gatherings',
      'descriptionAr': 'اجتماعات عمل احترافية',
      'color': AppColors.primaryDark,
    },
    {
      'id': 'evt_engagement',
      'name': 'Engagement Party',
      'nameAr': 'حفلة خطوبة',
      'icon': '💍',
      'description': 'Celebrate your engagement',
      'descriptionAr': 'احتفل بخطوبتك',
      'color': AppColors.error,
    },
    {
      'id': 'evt_baby_shower',
      'name': 'Baby Shower',
      'nameAr': 'استقبال المولود',
      'icon': '👶',
      'description': 'Welcome your little one',
      'descriptionAr': 'استقبل مولودك الجديد',
      'color': AppColors.warning,
    },
    {
      'id': 'evt_graduation',
      'name': 'Graduation Party',
      'nameAr': 'حفلة تخرج',
      'icon': '🎓',
      'description': 'Celebrate your achievement',
      'descriptionAr': 'احتفل بإنجازك',
      'color': AppColors.success,
    },
  ];
}

// lib/features/events/presentation/widgets/event_type_card.dart


class EventTypeCard extends StatelessWidget {
  final Map<String, dynamic> eventType;
  final VoidCallback onTap;

  const EventTypeCard({
    super.key,
    required this.eventType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.blue100,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              splashColor: eventType['color'].withOpacity(0.1),
              highlightColor: eventType['color'].withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Section
                    _buildIconSection(),

                    const SizedBox(height: 12),

                    // Event Name
                    _buildEventName(),

                    const SizedBox(height: 8),

                    // Description
                    _buildDescription(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Icon Section with Background
  Widget _buildIconSection() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: eventType['color'].withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: eventType['color'].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          eventType['icon'],
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
      ),
    );
  }

  /// Event Name Text
  Widget _buildEventName() {
    return Text(
      eventType['name'],
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// Description Text
  Widget _buildDescription() {
    return Text(
      eventType['description'],
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary.withOpacity(0.8),
        height: 1.3,
      ),
    );
  }
}
