// lib/features/new_owner_features/invitations/ui/screens/select_guests_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectGuestsScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventType;
  final DateTime eventDate;
  final bool fromCreateEvent;

  const SelectGuestsScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.eventDate,
    required this.fromCreateEvent,
  });

  @override
  State<SelectGuestsScreen> createState() => _SelectGuestsScreenState();
}

class _SelectGuestsScreenState extends State<SelectGuestsScreen> {
  /// ============================================
  /// Variables
  /// ============================================
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _personalMessageController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final Set<String> _selectedGuestIds = {};
  String _searchQuery = '';
  bool _isSendingInvitations = false;
  bool _isLoadingAttendees = true;

  // ✅ Real Data من Firebase - Attendees Collection
  List<UserModel> _attendeesList = [];
  List<UserModel> _filteredAttendees = [];
  Set<String> _alreadyInvitedIds = {};

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _personalMessageController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  /// ✅ Load Attendees من Firebase
  Future<void> _loadAttendees() async {
    try {
      debugPrint('📥 Loading attendees from Firebase...');

      // ✅ جلب جميع الـ Attendees من collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // ✅ اقرأ من attendees collection
      final QuerySnapshot snapshot = await firestore
          .collection('attendees')
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('❌ No attendees found');
        setState(() {
          _isLoadingAttendees = false;
          _attendeesList = [];
          _filteredAttendees = [];
        });
        return;
      }

      // ✅ تحويل البيانات إلى UserModel
      final List<UserModel> attendees = [];
      for (final doc in snapshot.docs) {
        try {
          final user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
          attendees.add(user);
        } catch (e) {
          debugPrint('⚠️ Error parsing attendee: $e');
        }
      }

      // ✅ جلب الـ Already Invited (من event_invitations)
      final invitationsSnapshot = await firestore
          .collection('event_invitations')
          .where('eventId', isEqualTo: widget.eventId)
          .get();

      final Set<String> invitedIds = {};
      for (final doc in invitationsSnapshot.docs) {
        final attendeeId = doc.data()['attendeeId'] as String?;
        if (attendeeId != null) {
          invitedIds.add(attendeeId);
        }
      }

      debugPrint('✅ Loaded ${attendees.length} attendees');
      debugPrint('✅ Already invited: ${invitedIds.length}');

      setState(() {
        _attendeesList = attendees;
        _filteredAttendees = attendees;
        _alreadyInvitedIds = invitedIds;
        _isLoadingAttendees = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading attendees: $e');
      _showError('Failed to load attendees: $e');
      setState(() {
        _isLoadingAttendees = false;
      });
    }
  }

  /// ✅ Filter Attendees based on Search Query
  void _filterAttendees(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredAttendees = _attendeesList;
        return;
      }

      final lowerQuery = query.toLowerCase();
      _filteredAttendees = _attendeesList.where((attendee) {
        final name = attendee.name.toLowerCase();
        final email = attendee.email.toLowerCase();
        final phone = attendee.phoneNumber ?? '';

        return name.contains(lowerQuery) ||
            email.contains(lowerQuery) ||
            phone.contains(lowerQuery);
      }).toList();
    });
  }

  /// ✅ Statistics
  int get _selectedCount => _selectedGuestIds.length;
  int get _alreadyInvitedCount => _alreadyInvitedIds.length;
  int get _availableCount => _attendeesList.length - _alreadyInvitedCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Select Guests',
        actions: [
          if (_selectedCount > 0)
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_selectedCount Selected',
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
      body: _isLoadingAttendees
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // ✅ Event Info Header
                  _buildEventInfoHeader(),

                  // ✅ Search Bar
                  _buildSearchBar(),

                  // ✅ Stats
                  _buildStats(),

                  // ✅ Users List
                  if (_filteredAttendees.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredAttendees.length,
                      itemBuilder: (context, index) {
                        return _buildAttendeeCard(
                          _filteredAttendees[index],
                          index,
                        );
                      },
                    ),
                  
                  // ✅ Bottom spacing
                  const SizedBox(height: 16),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(child: _buildBottomBar()),
    );
  }

  /// ============================================
  /// Event Info Header
  /// ============================================
  Widget _buildEventInfoHeader() {
    final formattedDate = DateFormat('MMM d, yyyy').format(widget.eventDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.15),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getEventIcon(),
              color: AppColors.primaryGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Search Bar
  /// ============================================
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterAttendees,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search by name, email or phone...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.primaryGold, size: 18),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                  iconSize: 18,
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _filterAttendees('');
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  /// ============================================
  /// Stats
  /// ============================================
  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            _attendeesList.length.toString(),
            Icons.people,
            Colors.blue,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Invited',
            _alreadyInvitedCount.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Available',
            _availableCount.toString(),
            Icons.person_add,
            AppColors.primaryGold,
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Stat Item
  /// ============================================
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      ],
    );
  }

  /// ============================================
  /// Stat Divider
  /// ============================================
  Widget _buildStatDivider() {
    return Container(width: 1, height: 30, color: Colors.grey[300]);
  }

  /// ============================================
  /// Attendee Card
  /// ============================================
  Widget _buildAttendeeCard(UserModel attendee, int index) {
    final isSelected = _selectedGuestIds.contains(attendee.id);
    final isInvited = _alreadyInvitedIds.contains(attendee.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryGold
              : isInvited
              ? Colors.green.withOpacity(0.3)
              : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 1),
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
                      _selectedGuestIds.remove(attendee.id);
                    } else {
                      _selectedGuestIds.add(attendee.id);
                    }
                  });
                },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // ✅ Avatar with Status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        attendee.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isInvited)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),

                // ✅ User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendee.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Email
                      Row(
                        children: [
                          Icon(Icons.email, size: 11, color: Colors.grey[600]),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              attendee.email,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (attendee.phoneNumber != null) ...[
                        const SizedBox(height: 2),
                        // Phone
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 11,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                attendee.phoneNumber ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // ✅ Selection/Status Indicator
                if (isInvited)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Invited',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            _selectedGuestIds.add(attendee.id);
                          } else {
                            _selectedGuestIds.remove(attendee.id);
                          }
                        });
                      },
                      activeColor: AppColors.primaryGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Empty State
  /// ============================================
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_rounded, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text(
            'No Users Found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _searchQuery.isEmpty
                ? 'No attendees available'
                : 'Try a different search',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Bottom Bar
  /// ============================================
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
          // ✅ Show message if no guests selected
          if (_selectedCount == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Select guests to send invitations',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // ✅ Send Invitations Button (In-App)
          if (_selectedCount > 0) ...[
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _isSendingInvitations
                    ? null
                    : () => _showPersonalMessageDialog(false),
                icon: _isSendingInvitations
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withOpacity(0.8),
                          ),
                        ),
                      )
                    : const Icon(Icons.send, size: 16),
                label: Text(
                  _isSendingInvitations
                      ? 'Sending...'
                      : 'Send In-App to $_selectedCount',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Send via WhatsApp Button (Selected Guests)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _isSendingInvitations
                    ? null
                    : () => _showPersonalMessageDialog(true),
                icon: const Icon(Icons.chat_bubble, size: 16),
                label: Text(
                  'Send via WhatsApp to $_selectedCount',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp green
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // ✅ Send via WhatsApp Direct (Without Selection)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _isSendingInvitations ? null : _showSendWhatsAppDirectDialog,
              icon: const Icon(Icons.phone, size: 16),
              label: const Text(
                'Send via WhatsApp Direct',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          if (widget.fromCreateEvent)
            // ✅ Skip Button (Always visible)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Skipped sending invitations'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.close),
                label: const Text('Skip for Now'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(
                    color: AppColors.primaryDark,
                    width: 1.5,
                  ),
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

  /// ============================================
  /// Send WhatsApp Direct Dialog (Phone + Message)
  /// ============================================
  void _showSendWhatsAppDirectDialog() {
    _phoneNumberController.clear();
    _personalMessageController.clear();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chat_bubble,
                        color: Color(0xFF25D366),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Send via WhatsApp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter phone number and message',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 14),

                // ✅ Phone Number TextField
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: const TextStyle(fontSize: 11),
                    hintText: '+20 123 456 7890',
                    hintStyle: const TextStyle(fontSize: 11),
                    prefixIcon: const Icon(Icons.phone, color: Color(0xFF25D366), size: 18),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF25D366),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ Message TextField
                TextField(
                  controller: _personalMessageController,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: const TextStyle(fontSize: 11),
                    hintText: 'Write your invitation message...',
                    hintStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF25D366),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    counterStyle: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[500],
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 14),

                // ✅ Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _phoneNumberController.clear();
                          _personalMessageController.clear();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.primaryDark),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final phone = _phoneNumberController.text.trim();
                          final message = _personalMessageController.text.trim();

                          if (phone.isEmpty) {
                            _showError('Please enter a phone number');
                            return;
                          }

                          Navigator.pop(context);
                          _sendWhatsAppDirect(phone, message);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Send', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Show Personal Message Dialog
  /// ============================================
  void _showPersonalMessageDialog(bool isWhatsApp) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Title
                Row(
                  children: [
                    Icon(
                      isWhatsApp ? Icons.chat_bubble : Icons.message,
                      color: isWhatsApp
                          ? const Color(0xFF25D366)
                          : AppColors.primaryGold,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isWhatsApp ? 'Send via WhatsApp' : 'Send Invitation',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Add a personal message (optional)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),

                // ✅ Personal Message TextField
                TextField(
                  controller: _personalMessageController,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Write a personal message...',
                    hintStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isWhatsApp
                            ? const Color(0xFF25D366)
                            : AppColors.primaryGold,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    counterStyle: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[500],
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 14),

                // ✅ Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _personalMessageController.clear();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.primaryDark),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (isWhatsApp) {
                            _sendViaWhatsApp();
                          } else {
                            _sendInvitations();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isWhatsApp
                              ? const Color(0xFF25D366)
                              : AppColors.primaryGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Send', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Send via WhatsApp
  /// ============================================
  Future<void> _sendViaWhatsApp() async {
    if (_selectedCount == 0) {
      _showError('Please select at least one guest');
      return;
    }

    setState(() => _isSendingInvitations = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showError('User not authenticated');
        setState(() => _isSendingInvitations = false);
        return;
      }

      debugPrint(
        '📱 Sending WhatsApp invitations to $_selectedCount guests...',
      );

      final personalMessage = _personalMessageController.text.trim();
      final formattedDate = DateFormat(
        'MMM d, yyyy • h:mm a',
      ).format(widget.eventDate);

      int successCount = 0;
      int failCount = 0;

      // ✅ Send to each selected guest
      for (final guestId in _selectedGuestIds) {
        // ✅ Get attendee from list
        final attendee = _attendeesList.firstWhere(
          (a) => a.id == guestId,
          orElse: () => UserModel(
            id: '',
            name: '',
            email: '',
            userType: UserType.attendee,
            isActive: true,
          ),
        );

        if (attendee.id.isEmpty) {
          debugPrint('⚠️ Skipping guest - not found');
          failCount++;
          continue;
        }

        final guestName = attendee.name;
        final phoneNumber = attendee.phoneNumber;
        final guestEmail = attendee.email;

        if (guestName.isEmpty || phoneNumber == null || phoneNumber.isEmpty) {
          debugPrint('⚠️ Skipping $guestName - no phone number');
          failCount++;
          continue;
        }

        // ✅ Prepare WhatsApp message
        String whatsappMessage =
            '''
🎉 *Event Invitation*

Hello $guestName!

You're invited to: *${widget.eventName}*
📅 Date: $formattedDate
🎭 Type: ${widget.eventType}
''';

        if (personalMessage.isNotEmpty) {
          whatsappMessage += '\n💬 Personal Message:\n"$personalMessage"\n';
        }

        whatsappMessage += '''

We'd love to have you there! 🎊

Please confirm your attendance.

---
Sent via PlanZ App
''';

        // ✅ Clean phone number (remove spaces, dashes, etc.)
        String cleanedPhone = phoneNumber.replaceAll(
          RegExp(r'[^\d+]'),
          '',
        );

        // ✅ Add country code if not present
        if (!cleanedPhone.startsWith('+')) {
          cleanedPhone = '+20$cleanedPhone'; // Egypt country code
        }

        // ✅ Encode message for URL
        final encodedMessage = Uri.encodeComponent(whatsappMessage);
        final whatsappUrl = 'https://wa.me/$cleanedPhone?text=$encodedMessage';

        // ✅ Try to launch WhatsApp
        try {
          final uri = Uri.parse(whatsappUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            successCount++;

            // ✅ Save invitation to Firestore
            final attendeeToSave = _attendeesList.firstWhere(
              (a) => a.id == guestId,
              orElse: () => UserModel(
                id: '',
                name: guestName,
                email: guestEmail ?? '',
                userType: UserType.attendee,
                isActive: true,
              ),
            );
            await _saveWhatsAppInvitation(attendeeToSave, personalMessage);

            debugPrint('✅ Sent WhatsApp to $guestName');

            // ✅ Small delay between messages
            await Future.delayed(const Duration(milliseconds: 500));
          } else {
            debugPrint('❌ Cannot launch WhatsApp for $guestName');
            failCount++;
          }
        } catch (e) {
          debugPrint('❌ Error sending to $guestName: $e');
          failCount++;
        }
      }

      debugPrint(
        '✅ WhatsApp sending complete: $successCount success, $failCount failed',
      );

      // ✅ Show result
      if (!mounted) return;
      setState(() => _isSendingInvitations = false);

      if (successCount > 0) {
        _showWhatsAppSuccessDialog(successCount, failCount);
      } else {
        _showError(
          'Failed to send WhatsApp messages. Please check phone numbers.',
        );
      }
    } catch (e) {
      debugPrint('❌ Error in WhatsApp sending: $e');
      _showError('Failed to send WhatsApp invitations: ${e.toString()}');
      setState(() => _isSendingInvitations = false);
    }
  }

  /// ============================================
  /// Save WhatsApp Invitation to Firestore
  /// ============================================
  Future<void> _saveWhatsAppInvitation(
    UserModel attendee,
    String personalMessage,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final invitationId = firestore.collection('event_invitations').doc().id;
      final currentUser = FirebaseAuth.instance.currentUser;

      final invitation = {
        'invitationId': invitationId,
        'eventId': widget.eventId,
        'eventName': widget.eventName,
        'eventOwnerId': currentUser!.uid,
        'eventOwnerName': currentUser.displayName ?? 'Event Owner',
        'attendeeId': attendee.id,
        'inviteeName': attendee.name,
        'inviteeEmail': attendee.email,
        'inviteePhone': attendee.phoneNumber,
        'invitationType': 'phone',
        'status': 'pending',
        'personalMessage': personalMessage.isEmpty ? null : personalMessage,
        'guestCount': 1,
        'reminderSent': false,
        'reminderCount': 0,
        'notificationSent': false,
        'sentAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('event_invitations')
          .doc(invitationId)
          .set(invitation);
      debugPrint('✅ Saved WhatsApp invitation for ${attendee.name}');
    } catch (e) {
      debugPrint('❌ Error saving WhatsApp invitation: $e');
    }
  }

  /// ============================================
  /// Send WhatsApp Direct (Without Selection)
  /// ============================================
  Future<void> _sendWhatsAppDirect(String phoneNumber, String customMessage) async {
    try {
      setState(() => _isSendingInvitations = true);

      debugPrint('📱 Sending WhatsApp direct to: $phoneNumber');

      final formattedDate = DateFormat(
        'MMM d, yyyy • h:mm a',
      ).format(widget.eventDate);

      // ✅ Build message
      String whatsappMessage = '''
🎉 *Event Invitation*

You're invited to: *${widget.eventName}*
📅 Date: $formattedDate
🎭 Type: ${widget.eventType}
''';

      if (customMessage.isNotEmpty) {
        whatsappMessage += '\n💬 Message:\n"$customMessage"\n';
      }

      whatsappMessage += '''

We'd love to have you there! 🎊

---
Sent via PlanZ App
''';

      // ✅ Clean phone number
      String cleanedPhone = phoneNumber.replaceAll(
        RegExp(r'[^\d+]'),
        '',
      );

      // ✅ Add country code if not present
      if (!cleanedPhone.startsWith('+')) {
        cleanedPhone = '+20$cleanedPhone'; // Egypt country code
      }

      // ✅ Encode message for URL
      final encodedMessage = Uri.encodeComponent(whatsappMessage);
      final whatsappUrl = 'https://wa.me/$cleanedPhone?text=$encodedMessage';

      // ✅ Try to launch WhatsApp
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        debugPrint('✅ Sent WhatsApp to $phoneNumber');

        if (!mounted) return;
        setState(() => _isSendingInvitations = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ WhatsApp message sent successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        debugPrint('❌ Cannot launch WhatsApp');
        if (!mounted) return;
        setState(() => _isSendingInvitations = false);
        _showError('Cannot launch WhatsApp. Please check if it is installed.');
      }
    } catch (e) {
      debugPrint('❌ Error sending WhatsApp: $e');
      if (!mounted) return;
      setState(() => _isSendingInvitations = false);
      _showError('Failed to send WhatsApp message: ${e.toString()}');
    }
  }

  /// ============================================
  /// WhatsApp Success Dialog
  /// ============================================
  void _showWhatsAppSuccessDialog(int successCount, int failCount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Success Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF25D366),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Title
              const Text(
                'WhatsApp Invitations Sent! 📱',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // ✅ Message
              Text(
                'Successfully sent to $successCount guest${successCount > 1 ? 's' : ''}${failCount > 0 ? '\n$failCount failed (no phone number)' : ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ✅ Done Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    setState(() {
                      _selectedGuestIds.clear();
                      _personalMessageController.clear();
                      _isSendingInvitations = false;
                    });
                    _loadAttendees(); // Reload to update invited status
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Send Invitations Method ✅ (In-App)
  /// ============================================
  Future<void> _sendInvitations() async {
    if (_selectedCount == 0) {
      _showError('Please select at least one guest');
      return;
    }

    setState(() => _isSendingInvitations = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showError('User not authenticated');
        setState(() => _isSendingInvitations = false);
        return;
      }

      debugPrint('📨 Sending invitations to $_selectedCount guests...');

      final personalMessage = _personalMessageController.text.trim();

      // ✅ Prepare Invitee Data from selected attendees
      final List<Map<String, dynamic>> inviteesData = [];

      for (final attendeeId in _selectedGuestIds) {
        final attendee = _attendeesList.firstWhere(
          (a) => a.id == attendeeId,
          orElse: () => UserModel(
            id: '',
            name: '',
            email: '',
            userType: UserType.attendee,
            isActive: true,
          ),
        );

        if (attendee.id.isNotEmpty) {
          inviteesData.add({
            'attendeeId': attendee.id,
            'inviteeName': attendee.name,
            'inviteeEmail': attendee.email,
            'inviteePhone': attendee.phoneNumber ?? '',
            'invitationType': 'inApp',
            'guestCount': 1,
            'personalMessage': personalMessage.isEmpty ? null : personalMessage,
            'attendeeFcmToken': attendee.fcmToken,  // ✅ إضافة FCM Token
          });
        }
      }

      debugPrint('✅ Invitees Data prepared: ${inviteesData.length} guests');
      if (personalMessage.isNotEmpty) {
        debugPrint('💬 Personal Message: $personalMessage');
      }

      // ✅ Call Cubit to Send Bulk Invitations
      if (!mounted) return;

      context.read<EventOwnerCubit>().sendBulkInvitations(
        eventId: widget.eventId,
        eventName: widget.eventName,
        eventOwnerId: currentUser.uid,
        eventOwnerName: currentUser.displayName ?? 'Event Owner',
        // ✅ Event Details
        eventDate: widget.eventDate,
        eventType: widget.eventType,
        invitees: inviteesData,
      );

      // ✅ Show Success Dialog
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      debugPrint('❌ Error sending invitations: $e');
      _showError('Failed to send invitations: ${e.toString()}');
      setState(() => _isSendingInvitations = false);
    }
  }

  /// ============================================
  /// Success Dialog - Stay on page to invite more
  /// ============================================
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Success Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Title
              const Text(
                'Invitations Sent! ✅',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Message
              Text(
                'Successfully sent to $_selectedCount guest${_selectedCount > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ✅ Buttons
              Column(
                children: [
                  // ✅ Invite More Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        setState(() {
                          _selectedGuestIds.clear();
                          _personalMessageController.clear();
                          _isSendingInvitations = false;
                        });
                        // Stay on the page to invite more
                      },
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text(
                        'Invite More',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Done Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        setState(() {
                          _selectedGuestIds.clear();
                          _personalMessageController.clear();
                          _isSendingInvitations = false;
                        });
                        Navigator.pop(context); // Close SelectGuestsScreen
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(
                          color: AppColors.primaryDark,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Error Message
  /// ============================================
  void _showError(String message) {
    setState(() => _isSendingInvitations = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
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
      case 'Conference':
        return Icons.school;
      case 'Party':
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }
}
