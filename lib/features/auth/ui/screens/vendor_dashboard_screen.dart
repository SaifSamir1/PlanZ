import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';


class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Vendor Dashboard',
          style: AppTextStyles.headline2,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqNbKVTGAWlEe65Ao0ILXrAQzupIZOpp6qYw&s",
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Earnings Summary
            Divider(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earnings Summary',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$4,567.89',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Next Payout:\n July 25, 2024',
                    style: TextStyle(color: AppColors.primaryDark
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'View Payout History',
                    style: TextStyle(
                        color: AppColors.primaryDark
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Manage Packages
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryGold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon:  Icon(Icons.inventory_2, color: AppColors.primaryGold),
                    label: const Text(
                      'Manage Packages',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Requests & Notifications Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Requests List
            _buildRequestCard(
              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqNbKVTGAWlEe65Ao0ILXrAQzupIZOpp6qYw&s",
              context,
              title: 'Annual Tech Conference',
              subtitle: 'Standard Catering Package',
              date: 'July 15, 2024 at 10:00 AM',
              status: 'Verified',
              statusColor: Colors.green,
              buttons: ['Accept', 'Message'],
            ),
            _buildRequestCard(
              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqNbKVTGAWlEe65Ao0ILXrAQzupIZOpp6qYw&s",
              context,
              title: 'Wedding Ceremony',
              subtitle: 'Premium Photo & Video',
              date: 'August 01, 2024 at 03:00 PM',
              status: 'Pending',
              statusColor: Colors.orange,
              buttons: ['Accept', 'Reject', 'Message'],
            ),
            _buildRequestCard(
              imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqNbKVTGAWlEe65Ao0ILXrAQzupIZOpp6qYw&s",
              context,
              title: 'Startup Pitch Event',
              subtitle: 'Full Audio Visual Setup',
              date: 'June 28, 2024 at 09:00 AM',
              status: 'Rejected',
              statusColor: Colors.red,
              buttons: ['Reject', 'Message'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, {
        required String imageUrl,
        required String title,
        required String subtitle,
        required String date,
        required String status,
        required Color statusColor,
        required List<String> buttons,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                child: Image.network(
                  imageUrl,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(subtitle, style: const TextStyle(color: AppColors.primaryDark)),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(children: [
            Icon(Icons.calendar_month_outlined,color: AppColors.primaryDark,size: 18,),
            Text(date, style: const TextStyle(color: AppColors.primaryDark)),
          ],),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: buttons.map((btn) {
              Color bg;
              Color textColor = Colors.white;

              switch (btn) {
                case 'Accept':
                  bg = Colors.green;
                  break;
                case 'Reject':
                  bg = Colors.red;
                  break;
                case 'Message':
                  bg = Colors.grey.shade300;
                  textColor = Colors.black;
                  break;
                default:
                  bg = Colors.grey;
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bg,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(btn, style: TextStyle(color: textColor)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
