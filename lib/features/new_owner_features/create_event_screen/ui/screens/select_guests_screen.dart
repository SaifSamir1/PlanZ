// lib/features/new_owner_features/invitations/ui/screens/select_guests_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/invite_via_whatsapp_screen.dart';

class SelectGuestsScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventType;
  final DateTime eventDate;

  const SelectGuestsScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.eventDate,
  });

  @override
  State<SelectGuestsScreen> createState() => _SelectGuestsScreenState();
}

class _SelectGuestsScreenState extends State<SelectGuestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> selectedGuests = {};
  String searchQuery = '';

  // Mock Data - App Users (Attendees)
  final List<Map<String, dynamic>> mockUsers = [
    {
      'id': 'user_001',
      'name': 'Ahmed Mohamed',
      'nameAr': 'أحمد محمد',
      'phone': '+201012345678',
      'email': 'ahmed@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Ahmed+Mohamed&background=E3C100&color=fff',
      'eventsAttended': 5,
      'isInvited': false,
    },
    {
      'id': 'user_002',
      'name': 'Sara Ali',
      'nameAr': 'سارة علي',
      'phone': '+201123456789',
      'email': 'sara@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Sara+Ali&background=21225b&color=fff',
      'eventsAttended': 3,
      'isInvited': true,
    },
    {
      'id': 'user_003',
      'name': 'Mohamed Hassan',
      'nameAr': 'محمد حسن',
      'phone': '+201234567890',
      'email': 'mohamed@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Mohamed+Hassan&background=E3C100&color=fff',
      'eventsAttended': 8,
      'isInvited': false,
    },
    {
      'id': 'user_004',
      'name': 'Fatima Ibrahim',
      'nameAr': 'فاطمة إبراهيم',
      'phone': '+201345678901',
      'email': 'fatima@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Fatima+Ibrahim&background=21225b&color=fff',
      'eventsAttended': 12,
      'isInvited': false,
    },
    {
      'id': 'user_005',
      'name': 'Omar Khaled',
      'nameAr': 'عمر خالد',
      'phone': '+201456789012',
      'email': 'omar@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Omar+Khaled&background=E3C100&color=fff',
      'eventsAttended': 2,
      'isInvited': false,
    },
    {
      'id': 'user_006',
      'name': 'Nour Ahmed',
      'nameAr': 'نور أحمد',
      'phone': '+201567890123',
      'email': 'nour@example.com',
      'avatar': 'https://ui-avatars.com/api/?name=Nour+Ahmed&background=21225b&color=fff',
      'eventsAttended': 6,
      'isInvited': true,
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.isEmpty) return mockUsers;
    return mockUsers.where((user) {
      final name = user['name'].toString().toLowerCase();
      final phone = user['phone'].toString();
      final query = searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  int get selectedCount => selectedGuests.length;
  int get alreadyInvitedCount => mockUsers.where((u) => u['isInvited']).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Select Guests',
        showBackButton: true,
        actions: [
          if (selectedCount > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$selectedCount Selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Event Info Header
          _buildEventInfoHeader(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Stats
          _buildStats(),
          
          // Users List
          Expanded(
            child: filteredUsers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(filteredUsers[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildEventInfoHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.1),
            AppColors.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getEventIcon(),
              color: AppColors.primaryGold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.eventDate.day}/${widget.eventDate.month}/${widget.eventDate.year}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon() {
    switch (widget.eventType) {
      case 'Wedding':
        return Icons.favorite;
      case 'Birthday':
        return Icons.cake;
      case 'Corporate':
        return Icons.business;
      case 'Engagement':
        return Icons.diamond;
      default:
        return Icons.event;
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by name or phone...',
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.primaryGold),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Users',
            mockUsers.length.toString(),
            Icons.people,
            AppColors.primaryDark,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Already Invited',
            alreadyInvitedCount.toString(),
            Icons.check_circle,
            AppColors.success,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Available',
            (mockUsers.length - alreadyInvitedCount).toString(),
            Icons.person_add,
            AppColors.primaryGold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.textSecondary.withOpacity(0.2),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final bool isSelected = selectedGuests.contains(user['id']);
    final bool isInvited = user['isInvited'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryGold
              : isInvited
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.textSecondary.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInvited
              ? null
              : () {
                  setState(() {
                    if (isSelected) {
                      selectedGuests.remove(user['id']);
                    } else {
                      selectedGuests.add(user['id']);
                    }
                  });
                },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    if (isInvited)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 12),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user['phone'],
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 14,
                            color: AppColors.primaryGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user['eventsAttended']} events attended',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primaryGold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Selection/Status
                if (isInvited)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Invited',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedGuests.add(user['id']);
                        } else {
                          selectedGuests.remove(user['id']);
                        }
                      });
                    },
                    activeColor: AppColors.primaryGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
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
            Icons.person_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Users Found',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Send Invitations Button
          if (selectedCount > 0)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendInvitations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Send Invitations to $selectedCount Guests',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          if (selectedCount > 0) const SizedBox(height: 12),
          
          // Invite via WhatsApp Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InviteViaWhatsAppScreen(
                      eventId: widget.eventId,
                      eventName: widget.eventName,
                      eventDate: widget.eventDate,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.phone, color: AppColors.primaryDark),
              label: const Text(
                'Invite via WhatsApp',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryDark, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendInvitations() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Send Invitations?'),
        content: Text(
          'You are about to send invitations to $selectedCount guests for "${widget.eventName}".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Send invitations logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invitations sent to $selectedCount guests!'),
                  backgroundColor: AppColors.success,
                ),
              );
              setState(() {
                selectedGuests.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
