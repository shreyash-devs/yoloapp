import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurvedBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CurvedBottomNavBar({
    super.key,
    this.currentIndex = 1,
    required this.onTap,
  });

  @override
  State<CurvedBottomNavBar> createState() => _CurvedBottomNavBarState();
}

class _CurvedBottomNavBarState extends State<CurvedBottomNavBar> {
  static const _navItems = [
    _NavItem(icon: Icons.home_outlined, label: 'home'),
    _NavItem(icon: Icons.qr_code_2, label: 'yolo pay', isQr: true),
    _NavItem(icon: Icons.auto_awesome, label: 'ginie'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipPath(
        clipper: _BarClipper(),
        child: SizedBox(
          height: 88,
          width: double.infinity,
          child: Stack(
            children: [
              // Gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.25,
                    colors: [Color(0xFF111111), Color(0xFF000000)],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
              ),
              // Subtle inner shadow/gloss
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              // Curved white stroke
              CustomPaint(
                size: const Size(double.infinity, 88),
                painter: _BorderPainter(),
              ),
              // Navigation bar
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_navItems.length, (i) {
                    final selected = widget.currentIndex == i;
                    final item = _navItems[i];
                    return _NavButton(
                      icon: item.icon,
                      label: item.label,
                      selected: selected,
                      isQr: item.isQr,
                      onTap: () => widget.onTap(i),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isQr;
  const _NavItem({required this.icon, required this.label, this.isQr = false});
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isQr;
  final VoidCallback onTap;
  final double borderWidth = 1.2; // Consistent with capsule button

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isQr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = isQr ? (selected ? 26 : 24) : 24;
    final Color selectedIconColor =
        Colors.white; // White icon on black selected circle
    final Color unselectedIconColor = Colors.white.withOpacity(0.4);
    final Color labelColor = selected
        ? Colors.white
        : Colors.white.withOpacity(0.4);

    // Define the gradient for the selected state (white glow, similar to pay button)
    final LinearGradient selectedBorderGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ui.Color(0xFFFFFFFF),
        ui.Color(0x1AFFFFFF),
      ], // White to transparent white
    );

    // Define the fill color for the selected circle
    final Color selectedFillColor =
        Colors.black; // Black fill for the circle itself

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Outer Container for the border and glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 48, // circleSize was 48
              height: 48, // circleSize was 48
              padding: EdgeInsets.all(
                selected ? borderWidth : 0,
              ), // Apply padding for border
              decoration: BoxDecoration(
                gradient: selected
                    ? selectedBorderGradient
                    : null, // Apply gradient only when selected
                color: selected
                    ? null
                    : Colors.white.withOpacity(
                        0.07,
                      ), // Background for unselected
                shape: BoxShape.circle,
                boxShadow:
                    selected // Apply glow only when selected
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.25),
                          blurRadius: 8,
                          spreadRadius: 1.5,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedContainer(
                // Inner Container for the fill and icon
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: selected
                      ? selectedFillColor
                      : Colors
                            .transparent, // Black fill for selected, transparent for unselected
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: selected ? selectedIconColor : unselectedIconColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 12,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----- Path helpers ----- */

class _BarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double topPad = 20;
    const double peak = -40;
    final Path p = Path()
      ..moveTo(0, topPad)
      ..quadraticBezierTo(size.width / 2, peak, size.width, topPad)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double topPad = 20;
    const double peak = -40;

    // White glow effect (thicker, more transparent white at center)
    final Paint glowPaint = Paint()
      ..shader = ui.Gradient.linear(
        ui.Offset(0, topPad),
        ui.Offset(size.width, topPad),
        [
          ui.Color(0x00FFFFFF), // transparent white at ends
          ui.Color(0x44FFFFFF), // semi-transparent white in middle
          ui.Color(0x00FFFFFF), // transparent white at ends
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 4);

    // Crisp white edge (thinner, more opaque white at center)
    final Paint edgePaint = Paint()
      ..shader = ui.Gradient.linear(
        ui.Offset(0, topPad),
        ui.Offset(size.width, topPad),
        [
          ui.Color(0x00FFFFFF), // transparent white at ends
          ui.Color(0xAAFFFFFF), // more opaque white in middle
          ui.Color(0x00FFFFFF), // transparent white at ends
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final Path path = Path()
      ..moveTo(0, topPad)
      ..quadraticBezierTo(size.width / 2, peak, size.width, topPad);

    // Draw glow first, then crisp edge
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, edgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
