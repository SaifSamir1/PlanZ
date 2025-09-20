
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_z/core/theming/text_stayls.dart';

class MainText extends StatelessWidget {
  const MainText({
    super.key,
    required this.currentTitle,
    required this.currentSubTitle,
  });

  final String currentTitle;
  final String currentSubTitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(currentTitle,
                style: AppTextStyles.customSize(
                  size: 20.sp,
                  weight: FontWeight.w700,
                )
                    .copyWith(color: Colors.black)),
          ),
          SizedBox(
            height: 16.h.clamp(13, 18),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32.w,
            ),
            child: Text(
              currentSubTitle,
              style: AppTextStyles.customSize(
                  size: 14.sp,
                  weight: FontWeight.normal,
                )
                  .copyWith(color: Colors.black.withValues(alpha: .8)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
