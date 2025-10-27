import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../data/model/functions.dart';
import '../../data/model/page_model.dart';

class InsiderCircular extends StatefulWidget {
  const InsiderCircular({
    super.key,
    required this.currentIndex,
    required this.controller,
  });
  
  final int currentIndex;
  final PageController controller;

  @override
  State<InsiderCircular> createState() => _InsiderCircularState();
}

class _InsiderCircularState extends State<InsiderCircular>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _scaleController.forward();
    await _scaleController.reverse();
    
    if (mounted) {
      navigationViaButton(
        widget.currentIndex,
        widget.controller,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PageModel.pagesDetails[widget.currentIndex].color,
                      boxShadow: [
                        BoxShadow(
                          color: PageModel.pagesDetails[widget.currentIndex].color
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: getProperIcon(widget.currentIndex),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
