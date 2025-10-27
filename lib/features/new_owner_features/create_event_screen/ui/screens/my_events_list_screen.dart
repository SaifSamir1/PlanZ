// lib/features/new_owner_features/invitations/ui/screens/my_events_list_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/select_guests_screen.dart';

class MyEventsListScreen extends StatefulWidget {
  const MyEventsListScreen({super.key});

  @override
  State<MyEventsListScreen> createState() => _MyEventsListScreenState();
}

class _MyEventsListScreenState extends State<MyEventsListScreen> {
  String selectedFilter = 'All';

  // Mock Data - Events
  final List<Map<String, dynamic>> mockEvents = [
    {
      'id': 'event_001',
      'name': 'Ahmed & Sara Wedding',
      'nameAr': 'فرح أحمد وسارة',
      'type': 'Wedding',
      'typeIcon': '💍',
      'date': DateTime(2025, 12, 15),
      'time': '6:00 PM',
      'venue': 'Grand Palace Hotel',
      'totalGuests': 300,
      'confirmedGuests': 245,
      'pendingGuests': 35,
      'declinedGuests': 20,
      'status': 'Confirmed',
      'statusColor': AppColors.success,
      'image': 'https://images.unsplash.com/photo-1519741497674-611481863552',
    },
    {
      'id': 'event_002',
      'name': 'Omar Birthday Party',
      'nameAr': 'عيد ميلاد عمر',
      'type': 'Birthday',
      'typeIcon': '🎂',
      'date': DateTime(2025, 11, 20),
      'time': '5:00 PM',
      'venue': 'Kids Paradise',
      'totalGuests': 50,
      'confirmedGuests': 42,
      'pendingGuests': 6,
      'declinedGuests': 2,
      'status': 'Confirmed',
      'statusColor': AppColors.success,
      'image': 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d',
    },
    {
      'id': 'event_003',
      'name': 'Tech Company Annual Meeting',
      'nameAr': 'الاجتماع السنوي للشركة',
      'type': 'Corporate',
      'typeIcon': '💼',
      'date': DateTime(2025, 10, 30),
      'time': '10:00 AM',
      'venue': 'Business Center',
      'totalGuests': 150,
      'confirmedGuests': 120,
      'pendingGuests': 25,
      'declinedGuests': 5,
      'status': 'Planning',
      'statusColor': AppColors.warning,
      'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
    },
    {
      'id': 'event_004',
      'name': 'Mohamed & Fatima Engagement',
      'nameAr': 'خطوبة محمد وفاطمة',
      'type': 'Engagement',
      'typeIcon': '💕',
      'date': DateTime(2025, 11, 5),
      'time': '7:00 PM',
      'venue': 'Nile View Restaurant',
      'totalGuests': 80,
      'confirmedGuests': 0,
      'pendingGuests': 0,
      'declinedGuests': 0,
      'status': 'Draft',
      'statusColor': AppColors.textSecondary,
      'image': 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3',
    },
  ];

  List<Map<String, dynamic>> get filteredEvents {
    if (selectedFilter == 'All') return mockEvents;
    return mockEvents.where((e) => e['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Events',
        showBackButton: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list, color: Colors.white),
        //     onPressed: _showFilterBottomSheet,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // // Stats Card
          // _buildStatsCard(),
          
          // Events List
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final totalEvents = mockEvents.length;
    final confirmedEvents = mockEvents.where((e) => e['status'] == 'Confirmed').length;
    final draftEvents = mockEvents.where((e) => e['status'] == 'Draft').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Events', totalEvents.toString(), Icons.event),
          _buildDivider(),
          _buildStatItem('Confirmed', confirmedEvents.toString(), Icons.check_circle),
          _buildDivider(),
          _buildStatItem('Draft', draftEvents.toString(), Icons.edit_note),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.title.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final DateTime eventDate = event['date'];
    final int daysUntil = eventDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectGuestsScreen(
                  eventId: event['id'],
                  eventName: event['name'],
                  eventType: event['type'],
                  eventDate: event['date'],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Event Image & Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(event['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        event['typeIcon'],
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event['name'],
                              style: AppTextStyles.title.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: event['statusColor'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              event['status'],
                              style: AppTextStyles.body.copyWith(
                                color: event['statusColor'],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Date & Time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${eventDate.day}/${eventDate.month}/${eventDate.year}',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              event['time'],
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),

                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Guests Count
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: AppColors.primaryGold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${event['confirmedGuests']}/${event['totalGuests']} Guests',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primaryGold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (daysUntil >= 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                daysUntil == 0
                                    ? 'Today'
                                    : daysUntil == 1
                                        ? 'Tomorrow'
                                        : '$daysUntil days',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primaryGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Events Found',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Filter Events',
              style: AppTextStyles.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('All', selectedFilter == 'All'),
            _buildFilterOption('Confirmed', selectedFilter == 'Confirmed'),
            _buildFilterOption('Planning', selectedFilter == 'Planning'),
            _buildFilterOption('Draft', selectedFilter == 'Draft'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.primaryGold
              : AppColors.textSecondary.withOpacity(0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.primaryGold.withOpacity(0.1) : Colors.white,
      ),
      child: RadioListTile<String>(
        value: title,
        groupValue: selectedFilter,
        onChanged: (value) {
          setState(() {
            selectedFilter = value!;
          });
          Navigator.pop(context);
        },
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        activeColor: AppColors.primaryGold,
      ),
    );
  }
}
