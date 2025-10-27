import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/stakeholders_selection_screen.dart';

Icon getProperIcon(int currentIndex) => currentIndex != 2
    ? const Icon(
        Icons.arrow_forward_rounded,
        key: ValueKey('next_icon'),
        color: Colors.white,
        size: 24,
      )
    : const Icon(
        Icons.check_rounded,
        key: ValueKey('done_icon'),
        color: Colors.white,
        size: 24,
      );

void navigationViaButton(
  int currentIndex,
  PageController controller,
  BuildContext context,
) async {
  if (currentIndex != 2) {
    controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const StakeholdersSelectionScreen(),
      ),
    );
  }
}
