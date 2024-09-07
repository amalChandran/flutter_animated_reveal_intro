import 'package:flutter/material.dart';
import 'package:flutter_animated_reveal_intro/combined_circle.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroItem {
  final IconData icon;
  final String description;
  final Color backgroundColor;
  final Color textColor;

  IntroItem({
    required this.icon,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
  });
}

class IntroScreen1 extends StatefulWidget {
  final String appTitle;
  final List<IntroItem> items;

  const IntroScreen1({
    Key? key,
    required this.appTitle,
    required this.items,
  }) : super(key: key);

  @override
  _IntroScreenState1 createState() => _IntroScreenState1();
}

class _IntroScreenState1 extends State<IntroScreen1>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final int _animationDuration = 500;
  final int _delayDuration = 350;

  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  int _currentIndex = 0;
  int _nextIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationDuration * 2 + _delayDuration),
    );

    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 0.8, curve: Curves.easeIn),
    ));

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 0.8, curve: Curves.easeIn),
    ));

    _animationController.addStatusListener(_handleAnimationStatus);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _currentIndex = _nextIndex;
        _isAnimating = false;
      });
      _animationController.reset();
    }
  }

  void _nextPage() {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
      _nextIndex = (_currentIndex + 1) % widget.items.length;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CombinedExpandingCircles3(
              colors: widget.items, onNextClick: _nextPage),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildContent(widget.items[_currentIndex]),
                          if (_isAnimating)
                            _buildContent(widget.items[_nextIndex]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 150), // Empty layout at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(IntroItem item) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final isCurrentItem = widget.items[_currentIndex] == item;

        return SlideTransition(
          position: _isAnimating
              ? (isCurrentItem ? _slideOutAnimation : _slideInAnimation)
              : AlwaysStoppedAnimation(Offset.zero),
          child: FadeTransition(
            opacity: _isAnimating
                ? (isCurrentItem ? _fadeOutAnimation : _fadeInAnimation)
                : AlwaysStoppedAnimation(1.0),
            child: child,
          ),
        );
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: item.textColor,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              item.description,
              style: GoogleFonts.roboto(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: item.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
