// lib/features/events/presentation/screens/basic_event_info_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/budget_setup_screen.dart';

class BasicEventInfoScreen extends StatefulWidget {
  final Map<String, dynamic> eventType;

  const BasicEventInfoScreen({
    super.key,
    required this.eventType,
  });

  @override
  State<BasicEventInfoScreen> createState() => _BasicEventInfoScreenState();
}

class _BasicEventInfoScreenState extends State<BasicEventInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _eventNameController = TextEditingController();
  final _guestCountController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  
  // Form Values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCity;
  String? _selectedArea;

  @override
  void dispose() {
    _eventNameController.dispose();
    _guestCountController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      _buildSectionTitle(),

                      const SizedBox(height: 24),

                      // Event Name Field
                      _buildEventNameField(),

                      const SizedBox(height: 20),

                      // Event Date Field
                      _buildEventDateField(),

                      const SizedBox(height: 20),

                      // Event Time Field
                      _buildEventTimeField(),

                      const SizedBox(height: 20),

                      // Location Section
                      _buildLocationSection(),

                      const SizedBox(height: 20),

                      // Guest Count Field
                      _buildGuestCountField(),

                      const SizedBox(height: 20),

                      // Additional Notes Field
                      _buildAdditionalNotesField(),

                      const SizedBox(height: 32),

                      // Next Button
                      _buildNextButton(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        'Event Information',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Progress Indicator Widget
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const StepProgressIndicator(
        currentStep: 2,
        totalSteps: 8,
      ),
    );
  }

  /// Section Title
  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.description_outlined,
            color: AppColors.primaryGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Event Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Event Name Field
  Widget _buildEventNameField() {
    return CustomTextField(
      controller: _eventNameController,
      label: 'Event Name',
      hint: 'e.g., Sarah & Ahmed Wedding',
      prefixIcon: Icons.event,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter event name';
        }
        if (value.trim().length < 3) {
          return 'Event name must be at least 3 characters';
        }
        return null;
      },
    );
  }

  /// Event Date Field
  Widget _buildEventDateField() {
    return DatePickerField(
      label: 'Event Date',
      hint: 'Select event date',
      selectedDate: _selectedDate,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      validator: (value) {
        if (_selectedDate == null) {
          return 'Please select event date';
        }
        if (_selectedDate!.isBefore(DateTime.now())) {
          return 'Event date must be in the future';
        }
        return null;
      },
    );
  }

  /// Event Time Field
  Widget _buildEventTimeField() {
    return TimePickerField(
      label: 'Event Time',
      hint: 'Select event time',
      selectedTime: _selectedTime,
      onTimeSelected: (time) {
        setState(() {
          _selectedTime = time;
        });
      },
      validator: (value) {
        if (_selectedTime == null) {
          return 'Please select event time';
        }
        return null;
      },
    );
  }

  /// Location Section (City & Area)
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Label
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // City Dropdown
        CustomDropdownField(
          label: 'City',
          hint: 'Select city',
          value: _selectedCity,
          items: _mockCities,
          prefixIcon: Icons.location_city,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
              _selectedArea = null; // Reset area when city changes
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a city';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Area Dropdown (depends on selected city)
        CustomDropdownField(
          label: 'Area',
          hint: _selectedCity == null 
              ? 'Select city first' 
              : 'Select area',
          value: _selectedArea,
          items: _selectedCity != null 
              ? _mockAreas[_selectedCity!] ?? []
              : [],
          prefixIcon: Icons.location_on,
          enabled: _selectedCity != null,
          onChanged: (value) {
            setState(() {
              _selectedArea = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an area';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Guest Count Field
  Widget _buildGuestCountField() {
    return CustomTextField(
      controller: _guestCountController,
      label: 'Expected Guest Count',
      hint: 'e.g., 300',
      prefixIcon: Icons.people,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter expected guest count';
        }
        final count = int.tryParse(value.trim());
        if (count == null || count <= 0) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  /// Additional Notes Field
  Widget _buildAdditionalNotesField() {
    return CustomTextField(
      controller: _additionalNotesController,
      label: 'Additional Notes',
      hint: 'Any special requirements or notes (Optional)',
      prefixIcon: Icons.note_alt_outlined,
      maxLines: 4,
      isRequired: false,
    );
  }

  /// Next Button
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next: Setup Budget',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }

  /// Handle Next Button Press
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // Gather all data
      final eventInfo = {
        'eventType': widget.eventType,
        'eventName': _eventNameController.text.trim(),
        'eventDate': _selectedDate,
        'eventTime': _selectedTime,
        'city': _selectedCity,
        'area': _selectedArea,
        'guestCount': int.parse(_guestCountController.text.trim()),
        'additionalNotes': _additionalNotesController.text.trim(),
      };

      // Show success message (temporary)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event information saved!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Navigate to BudgetSetupScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetSetupScreen(
            eventInfo: eventInfo,
          ),
        ),
      );

      print('Event Info: $eventInfo'); // For debugging
    }
  }

  /// Mock Data - Cities
  static final List<String> _mockCities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Mansoura',
    'Tanta',
    'Zagazig',
    'Aswan',
    'Luxor',
  ];

  /// Mock Data - Areas (based on city)
  static final Map<String, List<String>> _mockAreas = {
    'Cairo': [
      'Nasr City',
      'Heliopolis',
      'Maadi',
      'Zamalek',
      'Dokki',
      'New Cairo',
      '6th of October',
      'Tagamoa',
    ],
    'Alexandria': [
      'Smouha',
      'Stanley',
      'Miami',
      'Sidi Gaber',
      'Sporting',
      'Montaza',
    ],
    'Giza': [
      'Mohandessin',
      'Dokki',
      '6th of October',
      'Haram',
      'Faisal',
    ],
    'Mansoura': [
      'City Center',
      'El Mahalla',
      'Talkha',
    ],
    'Tanta': [
      'City Center',
      'El Mahalla',
      'Kafr El Zayat',
    ],
    'Zagazig': [
      'City Center',
      'El Mansoura Street',
    ],
    'Aswan': [
      'City Center',
      'Corniche',
    ],
    'Luxor': [
      'City Center',
      'Karnak',
      'West Bank',
    ],
  };
}
// lib/features/events/presentation/widgets/step_progress_indicator.dart

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Progress Text
        Text(
          'Progress:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),

        // Progress Dots
        Expanded(
          child: Row(
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.primaryGold
                        : AppColors.blue100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Step Counter
        Text(
          '($currentStep/$totalSteps)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGold,
          ),
        ),
      ],
    );
  }
}

// lib/features/events/presentation/widgets/custom_text_field.dart

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isRequired;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isRequired = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (!isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '(Optional)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Text Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.primaryGold,
              size: 22,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
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
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// lib/features/events/presentation/widgets/date_picker_field.dart
// lib/features/events/presentation/widgets/date_picker_field.dart

class DatePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? Function(String?)? validator;

  const DatePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Date Picker Field
        TextFormField(
          readOnly: true,
          validator: validator,
          onTap: () => _selectDate(context),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: selectedDate != null
                ? _formatDate(selectedDate!)
                : hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: selectedDate != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.primaryGold,
              size: 22,
            ),
            suffixIcon: selectedDate != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      // Clear selection by calling with a null-equivalent date
                      // Or you can add a callback for clearing
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
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
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Format date without intl package
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)), // 2 years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.background,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

// lib/features/events/presentation/widgets/time_picker_field.dart


class TimePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? Function(String?)? validator;

  const TimePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedTime,
    required this.onTimeSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Time Picker Field
        TextFormField(
          readOnly: true,
          validator: validator,
          onTap: () => _selectTime(context),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: selectedTime != null
                ? selectedTime!.format(context)
                : hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: selectedTime != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: const Icon(
              Icons.access_time,
              color: AppColors.primaryGold,
              size: 22,
            ),
            suffixIcon: selectedTime != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => onTimeSelected(const TimeOfDay(hour: 18, minute: 0)),
                  )
                : null,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
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
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.background,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }
}


// lib/features/events/presentation/widgets/custom_dropdown_field.dart

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final IconData prefixIcon;
  final bool enabled;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.prefixIcon,
    this.enabled = true,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown Field
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          onChanged: enabled ? onChanged : null,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: enabled ? AppColors.primaryGold : AppColors.textSecondary,
              size: 22,
            ),
            filled: true,
            fillColor: enabled ? AppColors.background : AppColors.blue50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
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
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          dropdownColor: AppColors.background,
          icon: Icon(
            Icons.arrow_drop_down,
            color: enabled ? AppColors.primaryGold : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
