// lib/features/events/presentation/screens/basic_event_info_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/cities_area_data.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/budget_setup_screen.dart';
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
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

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
    _locationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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

            // Location Field
            _buildLocationField(),
            const SizedBox(height: 16),

            // Address Field
            _buildAddressField(),
            const SizedBox(height: 16),

            // Phone Field
            _buildPhoneField(),
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
      items: cities.map((city) {
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
    final areas1 = _selectedCity != null ? areas[_selectedCity!] ?? [] : [];

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
      items: areas1.isEmpty
          ? []
          : areas1.map((area) {
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
        'location': _locationController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'guestCount': int.parse(_guestCountController.text.trim()),
        'additionalNotes': _additionalNotesController.text.trim(),
      };

      // ✅ Debug: Print eventInfo before passing
      debugPrint('🔍 [BasicEventInfoScreen] eventInfo prepared:');
      eventInfo.forEach((key, value) {
        if (value is Map) {
          debugPrint('   $key: [Map]');
        } else if (value is List) {
          debugPrint('   $key: [List]');
        } else {
          debugPrint('   $key: $value');
        }
      });

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

  /// Location Field
  Widget _buildLocationField() => TextFormField(
    controller: _locationController,
    decoration: InputDecoration(
      labelText: 'Event Location/Venue Name',
      hintText: 'e.g., Grand Ballroom, Nile Hilton',
      prefixIcon: const Icon(Icons.location_on),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: AppColors.cardBackground,
    ),
    validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter event location' : null,
  );

  /// Address Field
  Widget _buildAddressField() => TextFormField(
    controller: _addressController,
    decoration: InputDecoration(
      labelText: 'Full Address',
      hintText: 'e.g., 123 Main Street, Downtown Cairo',
      prefixIcon: const Icon(Icons.home),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: AppColors.cardBackground,
    ),
    validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter address' : null,
  );

  /// Phone Field
  Widget _buildPhoneField() => TextFormField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      labelText: 'Your Phone Number',
      hintText: 'e.g., +20 100 123 4567',
      prefixIcon: const Icon(Icons.phone),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: AppColors.cardBackground,
    ),
    validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter phone number' : null,
  );
}
