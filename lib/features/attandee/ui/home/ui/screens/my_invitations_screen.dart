// lib/features/attendee/presentation/screens/my_invitations_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/invitation_details_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/empty_invitations_widget.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_card.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_filter_chips.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitations_loading_shimmer.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class MyInvitationsScreen extends StatefulWidget {
  const MyInvitationsScreen({super.key});

  @override
  State<MyInvitationsScreen> createState() => _MyInvitationsScreenState();
}

class _MyInvitationsScreenState extends State<MyInvitationsScreen> {
  InvitationStatus? selectedStatus;
  UserManager userManager = UserManager();
  @override
  void initState() {
    super.initState();

    // Load all invitations
    _loadInvitations();
  }

  void _loadInvitations() {
    if (selectedStatus == null) {
      context.read<AttendeeCubit>().getMyInvitations(
        userManager.currentUser!.id,
      );
    } else {
      context.read<AttendeeCubit>().getInvitationsByStatus(
        attendeeId: userManager.currentUser!.id,
        status: selectedStatus!,
      );
    }
  }

  void _onFilterChanged(InvitationStatus? status) {
    setState(() {
      selectedStatus = status;
    });
    _loadInvitations();
  }

  Future<void> _onRefresh() async {
    _loadInvitations();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "My Invitations",
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to Search Screen
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.buttonPrimary,
        child: Column(
          children: [
            // Filter Chips
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: InvitationFilterChips(
                selectedStatus: selectedStatus,
                onFilterChanged: _onFilterChanged,
              ),
            ),

            const SizedBox(height: 8),

            // Invitations List
            Expanded(child: _buildInvitationsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildInvitationsList() {
    return BlocBuilder<AttendeeCubit, AttendeeState>(
      builder: (context, state) {
        // Loading States
        if (state is GetMyInvitationsLoading ||
            state is GetInvitationsByStatusLoading) {
          return const InvitationsLoadingShimmer();
        }

        // Error States
        if (state is GetMyInvitationsError) {
          return _buildErrorWidget(state.message);
        }

        if (state is GetInvitationsByStatusError) {
          return _buildErrorWidget(state.message);
        }

        // Success States
        List<EventInvitationModel> invitations = [];

        if (state is GetMyInvitationsSuccess) {
          invitations = state.invitations;
        } else if (state is GetInvitationsByStatusSuccess) {
          invitations = state.invitations;
        }

        // Empty State
        if (invitations.isEmpty) {
          return EmptyInvitationsWidget(filterStatus: selectedStatus);
        }

        // Display Invitations
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: invitations.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 50 * index),
              child: InvitationCard(
                invitation: invitations[index],
                onTap: () {
                  // Navigate to Invitation Details
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InvitationDetailsScreen(
                        invitationId: invitations[index].invitationId,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              "Failed to load invitations",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadInvitations,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
