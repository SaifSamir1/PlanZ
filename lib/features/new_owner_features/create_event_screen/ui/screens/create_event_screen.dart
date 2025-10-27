





// ignore_for_file: deprecated_member_use

// lib/screens/create_event_screen.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/core/widgets/custom_app_button.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';
import 'package:plan_z/features/auth/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateEventCubit(),
      child: const CreateEventView(),
    );
  }
}

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CreateEventAppBar(),
      body: BlocListener<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is CreateEventSuccess) {
            // Navigate to next screen or show success
            debugPrint('Event Type: ${state.selectedEventTypeId}');
            debugPrint('Budget: ${state.budget}');
          }
        },
        child: const CreateEventBody(),
      ),
    );
  }
}


class CreateEventBody extends StatelessWidget {
  const CreateEventBody({super.key});

  @override
  Widget build(BuildContext context) {
    final eventTypes = EventTypesData.getEventTypes();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const CreateEventHeader(),
                  const SizedBox(height: 24),
                  EventTypesGrid(eventTypes: eventTypes),
                  const SizedBox(height: 32),
                  const BudgetSection(),
                  const SizedBox(height: 24),
                  const CreateEventContinueButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventTypesGrid extends StatelessWidget {
  final List<EventType> eventTypes;

  const EventTypesGrid({
    super.key,
    required this.eventTypes,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.69,
      ),
      itemCount: eventTypes.length,
      itemBuilder: (context, index) {
        final eventType = eventTypes[index];
        
        // تحديد نوع الـ animation حسب الموضع
        Widget animatedCard;
        
        if (index.isEven) {
          // الكاردات اللي في اليسار (0, 2, 4...) تيجي من الشمال
          animatedCard = SlideInLeft(
            duration: Duration(milliseconds: 600 + (index * 100)),
            delay: Duration(milliseconds: index * 50),
            child: EventTypeCard(
              key: ValueKey(eventType.id),
              eventType: eventType,
              onTap: () {
                context.read<CreateEventCubit>().selectEventType(eventType.id);
              },
            ),
          );
        } else {
          // الكاردات اللي في اليمين (1, 3, 5...) تيجي من اليمين
          animatedCard = SlideInRight(
            duration: Duration(milliseconds: 600 + (index * 100)),
            delay: Duration(milliseconds: index * 50),
            child: EventTypeCard(
              key: ValueKey(eventType.id),
              eventType: eventType,
              onTap: () {
                context.read<CreateEventCubit>().selectEventType(eventType.id);
              },
            ),
          );
        }
        
        return animatedCard;
      },
    );
  }
}

class EventTypeCard extends StatelessWidget {
  final EventType eventType;
  final VoidCallback onTap;

  const EventTypeCard({
    super.key,
    required this.eventType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      buildWhen: (previous, current) {
        if (current is! CreateEventSelectionChanged) return false;
        
        final cubit = context.read<CreateEventCubit>();
        final wasSelected = cubit.isEventTypeSelected(eventType.id);
        
        if (previous is CreateEventSelectionChanged) {
          final previouslySelected = previous.selectedEventTypeId == eventType.id;
          return wasSelected != previouslySelected;
        }
        
        return wasSelected;
      },
      builder: (context, state) {
        final isSelected = context.read<CreateEventCubit>().isEventTypeSelected(eventType.id);
        
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: _buildCardDecoration(isSelected),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: EventCardImage(
                    eventType: eventType,
                    isSelected: isSelected,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: EventCardContent(eventType: eventType),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? AppColors.primaryGold : Colors.grey.shade200,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.15)
              : Colors.black.withOpacity(0.04),
          blurRadius: isSelected ? 12 : 6,
          offset: Offset(0, isSelected ? 4 : 2),
        ),
      ],
    );
  }
}

class BudgetSection extends StatefulWidget {
  const BudgetSection({super.key});

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Budget',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          hintText: 'e.g., 5000',
          onChanged: (value) {
            final budget = double.tryParse(value);
            if (budget != null) {
              context.read<CreateEventCubit>().updateBudget(budget);
            }
          },
          prefixIcon: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '\$',
              style: AppTextStyles.withWeight(
                AppTextStyles.subtitle,
                FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const BudgetDescription(),
      ],
    );
  }
}


class BudgetDescription extends StatelessWidget {
  const BudgetDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'All values in USD. Enter your estimated total event budget.',
      style: AppTextStyles.withColor(AppTextStyles.body, AppColors.blue400),
    );
  }
}


class CreateEventAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateEventAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomAppBar(
        title: 'Payment History',
        showBackButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: const AssetImage(
                'assets/images/undraw_female-avatar_7t6k.png',
              ),
              radius: 18,
              backgroundColor: AppColors.primaryGold.withOpacity(0.2),
            ),
          ),
        ],
      ); AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        color: AppColors.textPrimary,
      ),
      title: FadeInDown(
                duration: const Duration(milliseconds: 600),

        child: Text(
          'Create Event',
          style: AppTextStyles.title,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}



class CreateEventContinueButton extends StatelessWidget {
  const CreateEventContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: AppButton(
        text: 'Continue',
        onPressed: () {
          context.read<CreateEventCubit>().validateAndContinue();
        },
        width: double.infinity,
        height: 56,
        backgroundColor: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(12),
        shadow: BoxShadow(
          color: AppColors.primaryGold.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ),
    );
  }
}


class CreateEventHeader extends StatelessWidget {
  const CreateEventHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Choose Event Type',
      style: AppTextStyles.headline3,
    );
  }
}

class EventCardImage extends StatelessWidget {
  final EventType eventType;
  final bool isSelected;

  const EventCardImage({
    super.key,
    required this.eventType,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: AppColors.blue50,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                eventType.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return EventImagePlaceholder(eventTypeId: eventType.id);
                },
              ),
            ),
            if (isSelected) const SelectionIndicator(),
          ],
        ),
      ),
    );
  }
}



class EventCardContent extends StatelessWidget {
  final EventType eventType;

  const EventCardContent({
    super.key,
    required this.eventType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventType.title,
            style: AppTextStyles.withWeight(
              AppTextStyles.customSize(
                size: 15,
                color: AppColors.textPrimary,
              ),
              FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              eventType.description,
              style: AppTextStyles.customSize(
                size: 10,
                color: const Color.fromARGB(255, 83, 86, 167),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionIndicator extends StatelessWidget {
  const SelectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primaryGold,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}


class EventImagePlaceholder extends StatelessWidget {
  final String eventTypeId;

  const EventImagePlaceholder({
    super.key,
    required this.eventTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getGradientDecoration(),
      child: Center(
        child: Icon(
          _getIconData(),
          size: 50,
          color: _getIconColor(),
        ),
      ),
    );
  }

  BoxDecoration _getGradientDecoration() {
    switch (eventTypeId) {
      case 'wedding':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade100,
              Colors.purple.shade100,
              Colors.pink.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case 'conference':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.indigo.shade100,
              Colors.blue.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case 'birthday':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade100,
              Colors.yellow.shade100,
              Colors.orange.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case 'other':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade100,
              Colors.blueGrey.shade100,
              Colors.grey.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      default:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue50, AppColors.blue100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
    }
  }

  IconData _getIconData() {
    switch (eventTypeId) {
      case 'wedding':
        return Icons.favorite_rounded;
      case 'conference':
        return Icons.business_center_rounded;
      case 'birthday':
        return Icons.cake_rounded;
      case 'other':
        return Icons.event_rounded;
      default:
        return Icons.image_rounded;
    }
  }

  Color _getIconColor() {
    switch (eventTypeId) {
      case 'wedding':
        return Colors.pink.shade400;
      case 'conference':
        return Colors.blue.shade500;
      case 'birthday':
        return Colors.orange.shade500;
      case 'other':
        return Colors.grey.shade500;
      default:
        return AppColors.blue300;
    }
  }
}
