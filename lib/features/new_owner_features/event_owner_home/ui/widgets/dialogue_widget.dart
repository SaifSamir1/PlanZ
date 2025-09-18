import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class DialogueWidget extends StatelessWidget {
   const DialogueWidget({super.key, required this.service});
  final Map <String, dynamic> service ;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            child: Image.asset(service['image']),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service['service name'], style: AppTextStyles.title),
                SizedBox(height: 8),
                Text(service['description'],style: AppTextStyles.body.copyWith(color: AppColors.blue600)),
                Divider(),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Price: ', style: AppTextStyles.subtitle.copyWith(color: AppColors.blue600)),
                    SizedBox(width: 2,),
                    Text('${service['price']}', style: AppTextStyles.body.copyWith(color: AppColors.buttonPrimary)),
                    SizedBox(width: 43.9,),
                    Text('Rating: ', style: AppTextStyles.subtitle.copyWith(color: AppColors.blue600)),
                    SizedBox(width: 2,),
                    Text('${service['rating']}', style: AppTextStyles.body.copyWith(color: AppColors.buttonPrimary)),
                    SizedBox(width: 2,),
                    Icon(Icons.star_border,color: AppColors.buttonPrimary,size: 20,),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Reviews: ', style: AppTextStyles.subtitle.copyWith(color: AppColors.blue600)),
                    Spacer(),
                    Text('${service['reviews']}', style: AppTextStyles.body.copyWith(color: AppColors.buttonPrimary)),
                    Icon(Icons.person_outlined,color: AppColors.buttonPrimary,size: 20,)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: AppColors.buttonPrimary),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel',style: AppTextStyles.price.copyWith(fontSize: 11),),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
                          ),
                        onPressed: () {
                          // Handle booking logic here
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.shopping_cart_outlined,color: AppColors.background,size: 15,),
                            Text('Add to Cart',style: AppTextStyles.button.copyWith(fontSize: 11),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}