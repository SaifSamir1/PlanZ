import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../data/model/page_model.dart';

class OuterCircular extends StatefulWidget {
  const OuterCircular({super.key, required this.currentIndex});
  
  final int currentIndex;

  @override
  State<OuterCircular> createState() => _OuterCircularState();
}

class _OuterCircularState extends State<OuterCircular>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _updateAnimation();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(OuterCircular oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateAnimation();
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _updateAnimation() {
    final currentProgress = PageModel.pagesDetails[widget.currentIndex].progress;
    _animation = Tween<double>(
      begin: _previousProgress,
      end: currentProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _previousProgress = currentProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: SizedBox.square(
        dimension: 70,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CircularProgressIndicator(
              backgroundColor: Colors.grey.withOpacity(0.2),
              value: _animation.value,
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(
                PageModel.pagesDetails[widget.currentIndex].color,
              ),
            );
          },
        ),
      ),
    );
  }
}
