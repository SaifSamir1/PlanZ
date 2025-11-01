// lib/features/attendee/presentation/widgets/invitations/invitation_filter_chips.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class InvitationFilterChips extends StatelessWidget {
  final InvitationStatus? selectedStatus;
  final Function(InvitationStatus?) onFilterChanged;

  const InvitationFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            label: "All",
            isSelected: selectedStatus == null,
            onTap: () => onFilterChanged(null),
            icon: Icons.list_rounded,
          ),
          _buildFilterChip(
            label: "Pending",
            isSelected: selectedStatus == InvitationStatus.pending,
            onTap: () => onFilterChanged(InvitationStatus.pending),
            icon: Icons.schedule_rounded,
            color: Colors.orange,
          ),
          _buildFilterChip(
            label: "Accepted",
            isSelected: selectedStatus == InvitationStatus.accepted,
            onTap: () => onFilterChanged(InvitationStatus.accepted),
            icon: Icons.check_circle_rounded,
            color: Colors.green,
          ),
          _buildFilterChip(
            label: "Rejected",
            isSelected: selectedStatus == InvitationStatus.rejected,
            onTap: () => onFilterChanged(InvitationStatus.rejected),
            icon: Icons.cancel_rounded,
            color: Colors.red,
          ),
          _buildFilterChip(
            label: "Maybe",
            isSelected: selectedStatus == InvitationStatus.maybeAttending,
            onTap: () => onFilterChanged(InvitationStatus.maybeAttending),
            icon: Icons.help_outline_rounded,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.buttonPrimary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : chipColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : chipColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: chipColor,
        side: BorderSide(
          color: isSelected ? chipColor : Colors.grey[300]!,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        showCheckmark: false,
      ),
    );
  }
}
