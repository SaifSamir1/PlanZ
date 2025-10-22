import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/text_with_button_and_indicator/text_with_button_and_indicator.dart';
import 'container_with_image.dart';

class OnBoardingScreenBody extends StatefulWidget {
  const OnBoardingScreenBody({
    super.key,
  });

  @override
  State<OnBoardingScreenBody> createState() => _OnBoardingScreenBodyState();
}

class _OnBoardingScreenBodyState extends State<OnBoardingScreenBody> {
  late final PageController _controller = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    _controller.addListener(_onUpdatedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onUpdatedIndex)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: PageViewBuilder(
            controller: _controller,
          ),
        ),
        const SizedBox(
          height: 42,
        ),
        Expanded(
          flex: 2,
          child: TextWithButtonAndIndicator(
            currentIndex: _currentIndex,
            controller: _controller,
          ),
        ),
      ],
    );
  }

  void _onUpdatedIndex() {
    final currentIndex = _controller.page?.round() ?? 0;
    if (currentIndex != _currentIndex) {
      _currentIndex = currentIndex;
      setState(() {});
    }
  }
}
