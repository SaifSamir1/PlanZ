import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/text_with_button_and_indicator/main_text.dart';
import '../../data/model/page_model.dart';

class TextWithAnimation extends StatelessWidget {
  const TextWithAnimation({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: FadeInUp(
        key: ValueKey(currentIndex),
        duration: const Duration(milliseconds: 600),
        child: MainText(
          currentTitle: PageModel.pagesDetails[currentIndex].title,
          currentSubTitle: PageModel.pagesDetails[currentIndex].subTitle,
        ),
      ),
    );
  }
}
