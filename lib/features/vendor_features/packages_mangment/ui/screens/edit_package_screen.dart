import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/custom_item.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/custom_list_tile.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/custom_status.dart';

class EditPackageScreen extends StatelessWidget {
  const EditPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue50,
      appBar: AppBar(
        backgroundColor: AppColors.blue50,
        title: Text('Package Editor', style: AppTextStyles.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Package Details', style: AppTextStyles.title),
                  SizedBox(height: 8),
                  Text(
                    'Fill in the details for your event package.',
                    style: AppTextStyles.body,
                  ),
                  SizedBox(height: 8),

                  CustomListTile(
                    subtext: 'Premium Photography Package',
                    text: 'Package Name',
                    maxlines: 1,
                  ),
                  CustomListTile(
                    subtext:
                        'A high-end photography package offering full-day coverage, two photographers, a custom album, and digital rights for all edited images. Perfect for large-scale events and weddings seeking comprehensive visual storytelling.',
                    text: 'Description',
                    maxlines: 3,
                  ),
                  CustomListTile(subtext: '400 \$', text: 'Price', maxlines: 1),
                  Text('Package Items', style: AppTextStyles.title),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        CustomItem(text: 'Full-day coverage (up to 10 hours)'),
                        SizedBox(height: 8),
                        CustomItem(text: 'Two professional photographers'),
                        SizedBox(height: 8),
                        CustomItem(
                          text: 'Custom-designed 12x12 inch photo album',
                        ),
                        SizedBox(height: 8),
                        CustomItem(
                          text:
                              'High-resolution digital gallery with print rights',
                        ),
                        SizedBox(height: 8),
                        CustomItem(text: 'Print rights for all edited images'),

                        SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: BorderSide(color: AppColors.primaryGold),
                            ),
                            onPressed: () {},
                            label: Text(
                              'Add Item',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primaryGold,
                              ),
                            ),
                            icon: Icon(Icons.add, size: 25,color: AppColors.primaryGold,),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),
                  Text('Available Appointments', style: AppTextStyles.subtitle),

                  SizedBox(height: 8),
                  TextFormField(
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Every Saturday and Sunday, 10 AM - 6 PM',
                      hintStyle: AppTextStyles.body,
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryGold,
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryGold),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryGold),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text('Status', style: AppTextStyles.subtitle),
                  CustomStatus(text: 'Draft'),
                  CustomStatus(text: 'Published'),
                  CustomStatus(text: 'Archived'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: AppColors.primaryGold),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Save Draft',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: () {},
                        child: Text('Publish', style: AppTextStyles.body),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
