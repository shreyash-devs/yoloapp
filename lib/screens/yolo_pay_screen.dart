import 'package:flutter/material.dart' as flutter;
import 'package:flutter/widgets.dart' as widgets show Image;
import 'package:flutter/material.dart' as material show Image as FlutterImage;
import 'package:google_fonts/google_fonts.dart';
import 'package:faker/faker.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class YoloPayScreen extends flutter.StatefulWidget {
  const YoloPayScreen({super.key});

  @override
  flutter.State<YoloPayScreen> createState() => _YoloPayScreenState();
}

class _YoloPayScreenState extends flutter.State<YoloPayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFrozen = false;
  bool isFlipped = false;
  
  // Card details
  final String cardNumber = faker.random.integer(1000000000000000).toString().padLeft(16, '0');
  final String expiryDate = '${faker.random.integer(12).toString().padLeft(2, '0')}/${faker.random.integer(30).toString().padLeft(2, '0')}';
  final String cvv = faker.random.integer(999).toString().padLeft(3, '0');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFreeze() {
    setState(() {
      isFrozen = !isFrozen;
      if (isFrozen) {
        _controller.forward();
        isFlipped = true;
      } else {
        _controller.reverse();
        isFlipped = false;
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    flutter.ScaffoldMessenger.of(context).showSnackBar(
      const flutter.SnackBar(content: flutter.Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return flutter.Scaffold(
      backgroundColor: const ui.Color(0xFF000000),
      body: flutter.SafeArea(
        child: flutter.Column(
          children: [
            _buildTopBar(),
            flutter.Expanded(
              child: flutter.SingleChildScrollView(
                child: flutter.Column(
                  crossAxisAlignment: flutter.CrossAxisAlignment.start,
                  children: [
                    _buildPaymentModeSection(),
                    _buildCardSection(),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return flutter.Container(
      padding: const flutter.EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: flutter.Row(
        mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
        children: [
          flutter.Text(
            'YOLO',
            style: GoogleFonts.poppins(
              color: flutter.Colors.white,
              fontSize: 24,
              fontWeight: flutter.FontWeight.w600,
            ),
          ),
          flutter.Icon(
            flutter.Icons.notifications_outlined,
            color: flutter.Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModeSection() {
    return flutter.Padding(
      padding: const flutter.EdgeInsets.fromLTRB(20, 30, 20, 25),
      child: flutter.Column(
        crossAxisAlignment: flutter.CrossAxisAlignment.start,
        children: [
          flutter.Text(
            'Select Payment Mode',
            style: GoogleFonts.poppins(
              color: flutter.Colors.white,
              fontSize: 22,
              fontWeight: flutter.FontWeight.w600,
            ),
          ),
          const flutter.SizedBox(height: 8),
          flutter.Text(
            'Choose your preferred payment method for seamless transactions',
            style: GoogleFonts.poppins(
              color: flutter.Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const flutter.SizedBox(height: 25),
          flutter.Row(
            children: [
              _buildPaymentButton('pay', true),
              const flutter.SizedBox(width: 15),
              _buildPaymentButton('card', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(String text, bool isSelected) {
    return flutter.Container(
      width: 100,
      height: 40,
      decoration: flutter.BoxDecoration(
        borderRadius: flutter.BorderRadius.circular(20),
        gradient: flutter.LinearGradient(
          begin: flutter.Alignment.topCenter,
          end: flutter.Alignment.bottomCenter,
          colors: [
            flutter.Colors.white.withOpacity(0.2),
            flutter.Colors.white.withOpacity(0.0),
          ],
        ),
      ),
      child: flutter.Center(
        child: flutter.Text(
          text.toUpperCase(),
          style: GoogleFonts.poppins(
            color: flutter.Colors.white,
            fontSize: 14,
            fontWeight: flutter.FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection() {
    return flutter.Column(
      crossAxisAlignment: flutter.CrossAxisAlignment.start,
      children: [
        flutter.Padding(
          padding: const flutter.EdgeInsets.only(left: 20),
          child: flutter.Text(
            'YOUR DIGITAL DEBIT CARD',
            style: GoogleFonts.poppins(
              color: flutter.Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: flutter.FontWeight.w500,
            ),
          ),
        ),
        const flutter.SizedBox(height: 20),
        flutter.Padding(
          padding: const flutter.EdgeInsets.symmetric(horizontal: 20),
          child: flutter.Row(
            crossAxisAlignment: flutter.CrossAxisAlignment.start,
            children: [
              flutter.Expanded(
                child: _buildCard(),
              ),
              const flutter.SizedBox(width: 20),
              _buildFreezeButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return flutter.AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final transform = flutter.Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(3.14159 * _animation.value);
        return flutter.Transform(
          transform: transform,
          alignment: flutter.Alignment.center,
          child: _animation.value < 0.5 ? _buildCardFront() : _buildCardBack(),
        );
      },
    );
  }

  Widget _buildCardFront() {
    return flutter.Container(
      width: 186,
      height: 296,
      decoration: flutter.BoxDecoration(
        borderRadius: flutter.BorderRadius.circular(16),
        gradient: const flutter.LinearGradient(
          begin: flutter.Alignment.topLeft,
          end: flutter.Alignment.bottomRight,
          colors: [
            ui.Color(0xFF1E1E1E),
            ui.Color(0xFF2D2D2D),
          ],
        ),
      ),
      child: flutter.ClipRRect(
        borderRadius: flutter.BorderRadius.circular(16),
        child: flutter.BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: flutter.Container(
            padding: const flutter.EdgeInsets.all(20),
            decoration: flutter.BoxDecoration(
              borderRadius: flutter.BorderRadius.circular(16),
              border: flutter.Border.all(
                color: flutter.Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: flutter.Column(
              crossAxisAlignment: flutter.CrossAxisAlignment.start,
              children: [
                flutter.Row(
                  mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
                  children: [
                    flutter.Container(
                      height: 40,
                      width: 80,
                      child: material.FlutterImage.asset(
                        'assets/icons/yes_bank.png',
                        fit: flutter.BoxFit.contain,
                      ),
                    ),
                    flutter.Text(
                      'PREPAID',
                      style: GoogleFonts.poppins(
                        color: flutter.Colors.white,
                        fontSize: 12,
                        fontWeight: flutter.FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const flutter.Spacer(),
                flutter.Text(
                  cardNumber.replaceAllMapped(
                    RegExp(r'.{4}'),
                    (match) => '${match.group(0)} ',
                  ),
                  style: GoogleFonts.poppins(
                    color: flutter.Colors.white,
                    fontSize: 16,
                    fontWeight: flutter.FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                const flutter.SizedBox(height: 8),
                flutter.GestureDetector(
                  onTap: () => _copyToClipboard(cardNumber),
                  child: flutter.Container(
                    padding: const flutter.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: flutter.BoxDecoration(
                      color: flutter.Colors.white.withOpacity(0.1),
                      borderRadius: flutter.BorderRadius.circular(12),
                    ),
                    child: flutter.Row(
                      mainAxisSize: flutter.MainAxisSize.min,
                      children: [
                        flutter.Icon(
                          flutter.Icons.copy,
                          color: flutter.Colors.white,
                          size: 14,
                        ),
                        const flutter.SizedBox(width: 4),
                        flutter.Text(
                          'Copy Details',
                          style: GoogleFonts.poppins(
                            color: flutter.Colors.white,
                            fontSize: 12,
                            fontWeight: flutter.FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const flutter.Spacer(),
                flutter.Row(
                  mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
                  children: [
                    flutter.Column(
                      crossAxisAlignment: flutter.CrossAxisAlignment.start,
                      children: [
                        flutter.Text(
                          'EXPIRY',
                          style: GoogleFonts.poppins(
                            color: flutter.Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const flutter.SizedBox(height: 4),
                        flutter.Text(
                          expiryDate,
                          style: GoogleFonts.poppins(
                            color: flutter.Colors.white,
                            fontSize: 14,
                            fontWeight: flutter.FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    flutter.Column(
                      crossAxisAlignment: flutter.CrossAxisAlignment.start,
                      children: [
                        flutter.Text(
                          'CVV',
                          style: GoogleFonts.poppins(
                            color: flutter.Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const flutter.SizedBox(height: 4),
                        flutter.Text(
                          cvv,
                          style: GoogleFonts.poppins(
                            color: flutter.Colors.white,
                            fontSize: 14,
                            fontWeight: flutter.FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const flutter.SizedBox(height: 20),
                flutter.Container(
                  height: 40,
                  width: 60,
                  child: material.FlutterImage.asset(
                    'assets/icons/rupay.png',
                    fit: flutter.BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return flutter.Container(
      width: 186,
      height: 296,
      decoration: flutter.BoxDecoration(
        borderRadius: flutter.BorderRadius.circular(16),
        gradient: const flutter.LinearGradient(
          begin: flutter.Alignment.topLeft,
          end: flutter.Alignment.bottomRight,
          colors: [
            ui.Color(0xFF1E1E1E),
            ui.Color(0xFF2D2D2D),
          ],
        ),
      ),
      child: flutter.ClipRRect(
        borderRadius: flutter.BorderRadius.circular(16),
        child: flutter.BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: flutter.Container(
            padding: const flutter.EdgeInsets.all(20),
            decoration: flutter.BoxDecoration(
              borderRadius: flutter.BorderRadius.circular(16),
              border: flutter.Border.all(
                color: flutter.Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: flutter.Column(
              crossAxisAlignment: flutter.CrossAxisAlignment.start,
              children: [
                const flutter.Spacer(),
                flutter.Container(
                  height: 40,
                  color: flutter.Colors.white,
                ),
                const flutter.SizedBox(height: 20),
                flutter.Container(
                  height: 40,
                  color: flutter.Colors.white.withOpacity(0.1),
                  child: flutter.Center(
                    child: flutter.Text(
                      cvv,
                      style: GoogleFonts.poppins(
                        color: flutter.Colors.white,
                        fontSize: 14,
                        fontWeight: flutter.FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const flutter.Spacer(),
                flutter.Container(
                  height: 40,
                  width: 60,
                  child: material.FlutterImage.asset(
                    'assets/icons/rupay.png',
                    fit: flutter.BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFreezeButton() {
    return flutter.GestureDetector(
      onTap: _toggleFreeze,
      child: flutter.Column(
        mainAxisAlignment: flutter.MainAxisAlignment.center,
        children: [
          flutter.Container(
            height: 60,
            width: 60,
            padding: const flutter.EdgeInsets.all(1.5),
            decoration: flutter.BoxDecoration(
              shape: flutter.BoxShape.circle,
              gradient: isFrozen
                  ? flutter.LinearGradient(
                      begin: flutter.Alignment.topCenter,
                      end: flutter.Alignment.bottomCenter,
                      colors: [
                        ui.Color(0xFFFF3B3B).withOpacity(0.6),
                        ui.Color(0x00FF0000).withOpacity(0.0),
                      ],
                    )
                  : flutter.LinearGradient(
                      begin: flutter.Alignment.topCenter,
                      end: flutter.Alignment.bottomCenter,
                      colors: [
                        ui.Color(0xFFFFFFFF).withOpacity(0.4),
                        ui.Color(0x00FFFFFF).withOpacity(0.0),
                      ],
                    ),
              boxShadow: [
                flutter.BoxShadow(
                  color: isFrozen
                      ? ui.Color(0xFFFF3B3B).withOpacity(0.3)
                      : ui.Color(0xFFFFFFFF).withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: flutter.Container(
              decoration: const flutter.BoxDecoration(
                shape: flutter.BoxShape.circle,
                color: ui.Color(0xFF000000),
              ),
              child: flutter.Center(
                child: flutter.Icon(
                  flutter.Icons.ac_unit,
                  color: isFrozen ? flutter.Colors.redAccent : flutter.Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const flutter.SizedBox(height: 8),
          flutter.Text(
            isFrozen ? 'unfreeze' : 'freeze',
            style: GoogleFonts.poppins(
              color: isFrozen ? flutter.Colors.redAccent : flutter.Colors.white,
              fontWeight: flutter.FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return flutter.Container(
      height: 80,
      decoration: flutter.BoxDecoration(
        color: flutter.Colors.black,
        borderRadius: const flutter.BorderRadius.only(
          topLeft: flutter.Radius.circular(30),
          topRight: flutter.Radius.circular(30),
        ),
        boxShadow: [
          flutter.BoxShadow(
            color: flutter.Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: flutter.CustomPaint(
        painter: _BorderPainter(),
        child: flutter.Row(
          mainAxisAlignment: flutter.MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavIcon(flutter.Icons.home_outlined, true),
            _buildNavIcon(flutter.Icons.credit_card_outlined, false),
            _buildNavIcon(flutter.Icons.person_outline, false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(flutter.IconData icon, bool isSelected) {
    return flutter.Container(
      width: 60,
      height: 60,
      decoration: flutter.BoxDecoration(
        shape: flutter.BoxShape.circle,
        color: isSelected ? flutter.Colors.black : flutter.Colors.transparent,
        boxShadow: isSelected
            ? [
                flutter.BoxShadow(
                  color: flutter.Colors.white.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: flutter.Center(
        child: flutter.Icon(
          icon,
          color: isSelected ? flutter.Colors.white : flutter.Colors.white.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }
}

class _BorderPainter extends flutter.CustomPainter {
  @override
  void paint(flutter.Canvas canvas, flutter.Size size) {
    final paint = flutter.Paint()
      ..style = flutter.PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = flutter.LinearGradient(
        begin: flutter.Alignment.centerLeft,
        end: flutter.Alignment.centerRight,
        colors: [
          flutter.Colors.transparent,
          flutter.Colors.white.withOpacity(0.3),
          flutter.Colors.white.withOpacity(0.3),
          flutter.Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(flutter.Rect.fromLTWH(0, 0, size.width, 0));

    final path = flutter.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant flutter.CustomPainter oldDelegate) => false;
}
