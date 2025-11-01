// lib/features/attendee/presentation/widgets/invitation_details/invitation_details_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InvitationDetailsLoading extends StatelessWidget {
  const InvitationDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header Shimmer
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Content Shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  // Card 1
                  _buildShimmerCard(height: 150),
                  const SizedBox(height: 16),

                  // Card 2
                  _buildShimmerCard(height: 100),
                  const SizedBox(height: 16),

                  // Card 3
                  _buildShimmerCard(height: 120),
                  const SizedBox(height: 16),

                  // Card 4
                  _buildShimmerCard(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
