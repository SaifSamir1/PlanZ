// lib/features/events/presentation/screens/select_event_type_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/services/json_service.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/basic_event_info_screen.dart';

class SelectEventTypeScreen extends StatefulWidget {
  const SelectEventTypeScreen({super.key});

  @override
  State<SelectEventTypeScreen> createState() => _SelectEventTypeScreenState();
}

class _SelectEventTypeScreenState extends State<SelectEventTypeScreen> {
  List<Map<String, dynamic>> _eventTypes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEventTypes();
  }

  /// Load Event Types from JSON
  Future<void> _loadEventTypes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final eventTypes = await JsonService.getAllEventTypes();

      setState(() {
        _eventTypes = eventTypes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load event types: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Select Event Type',
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage != null
              ? _buildErrorView()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroSection(),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _buildEventTypesGrid(context),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// Loading View Widget
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading event types...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we prepare your options',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Error View Widget
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 56,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'An error occurred while loading event types',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadEventTypes,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
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
          'What type of event are you planning?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryGold.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            'Choose your event type to get started with customized planning',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Event Types Grid Widget
  Widget _buildEventTypesGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: _eventTypes.length,
      itemBuilder: (context, index) {
        final eventType = _eventTypes[index];
        return _buildEventTypeCard(context, eventType);
      },
    );
  }

  /// Event Type Card Widget
  Widget _buildEventTypeCard(
    BuildContext context,
    Map<String, dynamic> eventType,
  ) {
    Color cardColor = AppColors.primaryDark;
    if (eventType['color'] != null) {
      try {
        final colorString = eventType['color'] as String;
        cardColor = Color(
          int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
        );
      } catch (e) {
        cardColor = AppColors.primaryDark;
      }
    }

    return GestureDetector(
      onTap: () => _onEventTypeSelected(context, eventType),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardColor,
                cardColor.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Icon with background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildIcon(eventType['icon']),
                ),
                const SizedBox(height: 14),
                // ✅ Event Type Name
                Text(
                  eventType['eventTypeName'] ?? 'Event',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                // ✅ Description
                Flexible(
                  child: Text(
                    eventType['description'] ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Helper to build icon (supports emoji or asset path)
  Widget _buildIcon(dynamic icon) {
    if (icon == null) {
      return const Icon(Icons.event, size: 44, color: Colors.white);
    }

    final iconStr = icon.toString();

    // Check if it's an asset path
    if (iconStr.startsWith('assets/')) {
      return Image.asset(
        iconStr,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.event, size: 44, color: Colors.white);
        },
      );
    }

    // Otherwise, it's an emoji
    return Text(
      iconStr,
      style: const TextStyle(fontSize: 42),
    );
  }

  /// Handle Event Type Selection
  void _onEventTypeSelected(
    BuildContext context,
    Map<String, dynamic> eventType,
  ) {
    context.read<EventCreationCubit>().setEventType(
          eventTypeId: eventType['eventTypeId'],
          eventTypeName: eventType['eventTypeName'],
          eventTypeNameAr: eventType['eventTypeNameAr'],
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
}
