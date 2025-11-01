// lib/features/events/presentation/screens/select_event_type_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/services/json_service.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';

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
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroSection(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildEventTypesGrid(context),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// Error View Widget
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEventTypes,
            child: const Text('Retry'),
          ),
        ],
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose your event type to get started with customized planning',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
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
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // ✅ More height
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0), // ✅ Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIcon(eventType['icon']),
              const SizedBox(height: 10),
              Text(
                eventType['eventTypeName'] ?? 'Event',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  eventType['description'] ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Helper to build icon (supports emoji or asset path)
  Widget _buildIcon(dynamic icon) {
    if (icon == null) {
      return const Icon(Icons.event, size: 48, color: Colors.white);
    }

    final iconStr = icon.toString();

    // Check if it's an asset path
    if (iconStr.startsWith('assets/')) {
      return Image.asset(
        iconStr,
        width: 48,
        height: 48,
        fit: BoxFit.contain,
        color: Colors.white, // ✅ Tint icon white
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.event, size: 48, color: Colors.white);
        },
      );
    }

    // Otherwise, it's an emoji
    return Text(
      iconStr,
      style: const TextStyle(fontSize: 40),
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
