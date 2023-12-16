import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PulseLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const PulseLoadingIndicator({
    super.key,
    this.size = 150.0,
    this.color = Colors.grey,
  });

  @override
  State createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.4,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animationController.drive(
          CurveTween(curve: Curves.easeInOutCubic),
        ),
        child: SvgPicture.asset(
          'assets/icon.svg', // Replace with your SVG asset path
          height: widget.size,
          width: widget.size,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
