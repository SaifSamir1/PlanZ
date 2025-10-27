

// lib/core/widgets/custom_elevated_app_bar.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double elevation;
  final bool showBottomCurve;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useGradient;
  final double toolbarHeight;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.elevation = 0,
    this.showBottomCurve = true,
    this.bottom,
    this.backgroundColor,
    this.textColor,
    this.useGradient = true,
    this.toolbarHeight = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = backgroundColor ?? const Color(0xff21225b);
    final Color textColorFinal = textColor ?? Colors.white;

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      
      // Flexible Space with Gradient
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: useGradient
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryDark,
                    primaryDark.withOpacity(0.85),
                    Color(0xff2d2f70), // لون أفتح شوية
                  ],
                  stops: const [0.0, 0.5, 1.0],
                )
              : null,
          color: useGradient ? null : primaryDark,
        ),
        // Add decorative circles (optional)
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Leading
      leading: _buildLeading(context, textColorFinal),
      
      // Title
      title: Text(
        title,
        style: TextStyle(
          color: textColorFinal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      
      // Actions
      actions: actions,
      
      // Bottom (TabBar, etc.)
      bottom: bottom,
      
      // Custom Shape (Curved Bottom)
      shape: showBottomCurve
          ? const _CustomAppBarShape()
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context, Color textColor) {
    if (leading != null) {
      return leading;
    }
    
    if (showBackButton) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: textColor,
          size: 22,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0) + (showBottomCurve ? 20 : 0),
      );
}

// Custom Shape for Curved Bottom
class _CustomAppBarShape extends ContinuousRectangleBorder {
  const _CustomAppBarShape();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    
    path.lineTo(0, rect.height - 20);
    
    // Create smooth curve at the bottom
    path.quadraticBezierTo(
      rect.width / 2, // control point x
      rect.height + 10, // control point y (extends below)
      rect.width, // end point x
      rect.height - 20, // end point y
    );
    
    path.lineTo(rect.width, 0);
    path.close();
    
    return path;
  }
}


class CustomElevatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomElevatedAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff21225b),
            const Color(0xff2d2f70),
            const Color(0xff3a3d85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff21225b).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Leading
              if (showBackButton || leading != null)
                leading ??
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    ),
              
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: showBackButton || leading != null
                      ? TextAlign.start
                      : TextAlign.center,
                ),
              ),
              
              // Actions
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}



class CustomFloatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomFloatingAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xff21225b),
              const Color(0xff2d2f70),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff21225b).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Leading
              if (showBackButton)
                GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              
              if (showBackButton) const SizedBox(width: 12),
              
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Actions
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}



class CustomGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomGlassAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xff21225b).withOpacity(0.7),
                    const Color(0xff2d2f70).withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Back Button
                    if (showBackButton)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: onBackPressed ?? () => Navigator.pop(context),
                      ),
                    
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Actions
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(92);
}
