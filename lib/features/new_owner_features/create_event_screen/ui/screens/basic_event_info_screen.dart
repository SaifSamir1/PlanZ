// lib/features/events/presentation/screens/basic_event_info_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/budget_setup_screen.dart';
// lib/features/events/presentation/screens/basic_event_info_screen.dart

import 'package:flutter_bloc/flutter_bloc.dart';

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

  // Mock Cities and Areas (يمكن استبدالها بـ JSON أو API)
  final List<String> _cities = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Sharm El Sheikh',
    'Hurghada',
    'Luxor',
    'Aswan',
  ];

  final Map<String, List<String>> _areas = {
    'Cairo': ['Nasr City', 'Heliopolis', 'Maadi', 'Zamalek', 'Downtown'],
    'Giza': ['6th October', 'Sheikh Zayed', 'Dokki', 'Mohandessin'],
    'Alexandria': ['Miami', 'Smouha', 'Stanley', 'Sidi Gaber'],
    'Sharm El Sheikh': ['Naama Bay', 'Sharks Bay', 'Hadaba'],
    'Hurghada': ['Sakkala', 'Dahar', 'Marina'],
    'Luxor': ['East Bank', 'West Bank'],
    'Aswan': ['City Center', 'Nile Corniche'],
  };

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
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Basic Event Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Event Type Summary Card
            _buildEventTypeSummaryCard(),
            const SizedBox(height: 24),

            // Event Name Field
            _buildEventNameField(),
            const SizedBox(height: 16),

            // Date & Time Row
            Row(
              children: [
                Expanded(child: _buildDateField()),
                const SizedBox(width: 12),
                Expanded(child: _buildTimeField()),
              ],
            ),
            const SizedBox(height: 16),

            // City Dropdown
            _buildCityDropdown(),
            const SizedBox(height: 16),

            // Area Dropdown
            _buildAreaDropdown(),
            const SizedBox(height: 16),

            // Guest Count Field
            _buildGuestCountField(),
            const SizedBox(height: 16),

            // Additional Notes Field
            _buildAdditionalNotesField(),
            const SizedBox(height: 32),

            // Continue Button
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }
 /// ✅ Helper to build icon (supports emoji or asset path)
  Widget _buildIcon(dynamic icon) {
    if (icon == null) {
      return const Icon(Icons.event, size: 48, color: AppColors.primaryDark);
    }

    final iconStr = icon.toString();

    // Check if it's an asset path
    if (iconStr.startsWith('assets/')) {
      return Image.asset(
        iconStr,
        width: 15,
        height: 15,
        fit: BoxFit.contain,
        color: AppColors.primaryDark, // ✅ Tint icon white
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.event, size: 48, color: AppColors.primaryDark);
        },
      );
    }

    // Otherwise, it's an emoji
    return Text(
      iconStr,
      style: const TextStyle(fontSize: 40),
    );
  }

  /// Event Type Summary Card
  Widget _buildEventTypeSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold, width: 1.5),
      ),
      child: Row(
        children: [
          _buildIcon(widget.eventType['icon']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventType['eventTypeName'] ?? 'Event',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.eventType['description'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Event Name Field
  Widget _buildEventNameField() {
    return TextFormField(
      controller: _eventNameController,
      decoration: InputDecoration(
        labelText: 'Event Name',
        hintText: 'e.g., Ahmed & Sara Wedding',
        prefixIcon: const Icon(Icons.celebration),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter event name';
        }
        return null;
      },
    );
  }

  /// Date Field
  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
          errorText: _selectedDate == null && _formKey.currentState?.validate() == false
              ? 'Required'
              : null,
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Select Date',
          style: TextStyle(
            color: _selectedDate != null
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Time Field
  Widget _buildTimeField() {
    return InkWell(
      onTap: _selectTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Time',
          prefixIcon: const Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.cardBackground,
          errorText: _selectedTime == null && _formKey.currentState?.validate() == false
              ? 'Required'
              : null,
        ),
        child: Text(
          _selectedTime != null
              ? _selectedTime!.format(context)
              : 'Select Time',
          style: TextStyle(
            color: _selectedTime != null
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// City Dropdown
  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      decoration: InputDecoration(
        labelText: 'City',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
      items: _cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value;
          _selectedArea = null; // Reset area when city changes
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a city';
        }
        return null;
      },
    );
  }

  /// Area Dropdown
  Widget _buildAreaDropdown() {
    final areas = _selectedCity != null ? _areas[_selectedCity!] ?? [] : [];

    return DropdownButtonFormField<String>(
      value: _selectedArea,
      decoration: InputDecoration(
        labelText: 'Area',
        prefixIcon: const Icon(Icons.location_on),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
      items: areas.isEmpty
          ? []
          : areas.map((area) {
              return DropdownMenuItem<String>(
                value: area,
                child: Text(area),
              );
            }).toList(),
      onChanged: areas.isEmpty
          ? null
          : (value) {
              setState(() {
                _selectedArea = value;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Please select an area';
        }
        return null;
      },
    );
  }

  /// Guest Count Field
  Widget _buildGuestCountField() {
    return TextFormField(
      controller: _guestCountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Expected Guest Count',
        hintText: 'e.g., 200',
        prefixIcon: const Icon(Icons.people),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter guest count';
        }
        final guestCount = int.tryParse(value);
        if (guestCount == null || guestCount <= 0) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  /// Additional Notes Field
  Widget _buildAdditionalNotesField() {
    return TextFormField(
      controller: _additionalNotesController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Additional Notes (Optional)',
        hintText: 'Any special requirements or preferences...',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Icon(Icons.notes),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _onContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Continue to Budget Setup',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Select Date
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)), // 2 years
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Select Time
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  /// Handle Continue Button
  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Additional validation for date and time
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select event date')),
        );
        return;
      }

      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select event time')),
        );
        return;
      }

      // Save to EventCreationCubit
      context.read<EventCreationCubit>().setBasicInfo(
            eventName: _eventNameController.text.trim(),
            eventDate: _selectedDate!,
            eventTime: _selectedTime!,
            city: _selectedCity!,
            area: _selectedArea!,
            guestCount: int.parse(_guestCountController.text.trim()),
            additionalNotes: _additionalNotesController.text.trim().isNotEmpty
                ? _additionalNotesController.text.trim()
                : null,
          );

      // Prepare eventInfo Map for next screen (backward compatibility)
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

      // Navigate to BudgetSetupScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetSetupScreen(
            eventInfo: eventInfo,
          ),
        ),
      );
    }
  }
}

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
