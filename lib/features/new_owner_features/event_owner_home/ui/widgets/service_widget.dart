import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/widgets/dialogue_widget.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({super.key, required this.service});

  final Map<String, dynamic> service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(service['image']),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Text(
                    service['Service Vendor'],
                    style: AppTextStyles.title,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service['service name'], style: AppTextStyles.subtitle),
                    Text(service['price'], style: AppTextStyles.price),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star_border, color: AppColors.buttonPrimary, size: 16),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('${service['rating']}', style: AppTextStyles.body),
                  ],
                ),
                SizedBox(height: 8),
                Text(service['description'], style: AppTextStyles.body, maxLines: 2,overflow: TextOverflow.ellipsis,),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return DialogueWidget(service: service,);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                    ),
                    child: Text('View Details', style: AppTextStyles.button.copyWith(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
