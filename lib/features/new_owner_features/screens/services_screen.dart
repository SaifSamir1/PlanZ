import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/widgets/service_widget.dart';

class ServicesScreen extends StatelessWidget {
   ServicesScreen({super.key});

  final List<Map<String, dynamic>> services = const [
    {
      'Service Vendor': 'Elegant Affairs Catering',
      'image': 'assets/images/food_catering.png',
      'service name': 'Classic Wedding Buffet',
      'price': '\$8500',
      'description': 'Full-service catering for up to 100 guests, including appetizers, main courses, dessert bar, and non-alcoholic beverages. Professional staff and custom menu options.',
      'rating': '4.8/5',
      'reviews':'120'
    },
    {
      'Service Vendor': 'Blissful Blooms Florist',
      'image': 'assets/images/florist.png',
      'service name': 'Romantic Floral Decor',
      'price': '\$3200',
      'description': 'Exquisite floral arrangements for ceremony and reception, including bridal bouquet, centerpieces, and decorative accents. Personal consultation for theme and color palette.',
      'rating': '4.9/5',
      'reviews':'240'
    },
    {
      'Service Vendor': 'Harmony Melodies Band',
      'image': 'assets/images/harmony_music.png',
      'service name': 'Live Reception Music',
      'price': '\$4500',
      'description': 'A 5-piece live band offering 4 hours of performance, covering a wide range of genres from jazz to contemporary hits. Custom song requests included.',
      'rating': '4.7/5',
      'reviews':'330'
    },
    {
      'Service Vendor': 'Enchanted Moments Photography',
      'image': 'assets/images/photography.png',
      'service name': 'Premium Wedding Photography',
      'price': '\$5800',
      'description': 'All-day photography coverage (up to 10 hours) by two photographers, high-resolution digital album, and a beautiful custom-designed photo album.',
      'rating': '5.0/5',
      'reviews':'508'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.buttonPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Select Services',style: AppTextStyles.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return ServiceWidget(service: services[index],);
                },
              ),
            ),
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //AR Page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                    ),
                    child: Text('Preview in AR', style: AppTextStyles.button.copyWith(color: Colors.white),),
                  ),
                ),
          ],
        ),
      
      ),
    );
  }
}
