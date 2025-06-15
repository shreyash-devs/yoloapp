import 'package:flutter/material.dart' as flutter;
import 'package:faker/faker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class CardScreen extends flutter.StatefulWidget {
  const CardScreen({flutter.Key? key}) : super(key: key);

  @override
  flutter.State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends flutter.State<CardScreen> {
  bool isFrozen = false;
  bool isCardMode = true;
  final faker = Faker();
  late String cardNumber;
  late String expiry;
  late String cvv;
  late String cardHolder;

  @override
  void initState() {
    super.initState();
    cardNumber = _generateCardNumber();
    expiry = _generateExpiry();
    cvv = _generateCVV();
    cardHolder = faker.person.firstName();
  }

  String _generateCardNumber() {
    return List.generate(
      4,
      (_) => faker.randomGenerator.numbers(9, 4).join(),
    ).join(' ');
  }

  String _generateExpiry() {
    final month = faker.randomGenerator
        .integer(12, min: 1)
        .toString()
        .padLeft(2, '0');
    final year =
        (DateTime.now().year + faker.randomGenerator.integer(5, min: 1)) % 100;
    return '$month/${year.toString().padLeft(2, '0')}';
  }

  String _generateCVV() {
    return faker.randomGenerator.numbers(9, 3).join();
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.Scaffold(
      backgroundColor: flutter.Colors.black,
      body: flutter.SafeArea(
        child: flutter.Column(
          crossAxisAlignment: flutter.CrossAxisAlignment.start,
          children: [
            const flutter.SizedBox(height: 24),
            flutter.Padding(
              padding: const flutter.EdgeInsets.symmetric(horizontal: 24.0),
              child: flutter.Column(
                crossAxisAlignment: flutter.CrossAxisAlignment.start,
                children: [
                  flutter.Text(
                    'select payment mode',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white,
                      fontWeight: flutter.FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const flutter.SizedBox(height: 8),
                  flutter.Text(
                    'choose your preferred payment method to make payment.',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const flutter.SizedBox(height: 24),
                  flutter.Row(
                    children: [
                      _buildModeButton('pay', !isCardMode),
                      const flutter.SizedBox(width: 12),
                      _buildModeButton('card', isCardMode),
                    ],
                  ),
                  const flutter.SizedBox(height: 24),
                  flutter.Text(
                    'YOUR DIGITAL DEBIT CARD',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const flutter.SizedBox(height: 16),
                  _buildCard(),
                ],
              ),
            ),
            const flutter.Spacer(),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  flutter.Widget _buildModeButton(String label, bool selected) {
    return flutter.Expanded(
      child: flutter.GestureDetector(
        onTap: () {
          setState(() {
            isCardMode = label == 'card';
          });
        },
        child: flutter.Container(
          height: 38,
          decoration: flutter.BoxDecoration(
            color: selected ? flutter.Colors.white : flutter.Colors.transparent,
            border: flutter.Border.all(
              color: selected ? flutter.Colors.white : flutter.Colors.red,
              width: 1.5,
            ),
            borderRadius: flutter.BorderRadius.circular(20),
          ),
          alignment: flutter.Alignment.center,
          child: flutter.Text(
            label,
            style: GoogleFonts.montserrat(
              color: selected ? flutter.Colors.black : flutter.Colors.red,
              fontWeight: flutter.FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  flutter.Widget _buildCard() {
    return flutter.Stack(
      children: [
        flutter.Container(
          width: double.infinity,
          height: 210,
          decoration: flutter.BoxDecoration(
            borderRadius: flutter.BorderRadius.circular(18),
            gradient: flutter.LinearGradient(
              colors: [
                flutter.Colors.blueGrey.shade900,
                flutter.Colors.black,
                flutter.Colors.red.shade900.withOpacity(0.7),
              ],
              begin: flutter.Alignment.topLeft,
              end: flutter.Alignment.bottomRight,
            ),
            boxShadow: [
              flutter.BoxShadow(
                color: flutter.Colors.black.withOpacity(0.5),
                blurRadius: 16,
                offset: const flutter.Offset(0, 8),
              ),
            ],
          ),
          child: isFrozen
              ? flutter.ClipRRect(
                  borderRadius: flutter.BorderRadius.circular(18),
                  child: flutter.BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: flutter.Container(
                      color: flutter.Colors.black.withOpacity(0.4),
                    ),
                  ),
                )
              : null,
        ),
        flutter.Positioned(
          left: 24,
          top: 28,
          child: flutter.Text(
            'YOLO',
            style: GoogleFonts.montserrat(
              color: flutter.Colors.redAccent,
              fontWeight: flutter.FontWeight.bold,
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
        ),
        flutter.Positioned(
          right: 24,
          top: 28,
          child: flutter.Container(
            padding: const flutter.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: flutter.BoxDecoration(
              color: flutter.Colors.white.withOpacity(0.15),
              borderRadius: flutter.BorderRadius.circular(6),
            ),
            child: flutter.Row(
              children: [
                flutter.Icon(
                  flutter.Icons.credit_card,
                  color: flutter.Colors.white,
                  size: 16,
                ),
                const flutter.SizedBox(width: 4),
                flutter.Text(
                  'VIRTUAL',
                  style: GoogleFonts.montserrat(
                    color: flutter.Colors.white,
                    fontSize: 11,
                    fontWeight: flutter.FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        flutter.Positioned(
          left: 24,
          top: 80,
          child: flutter.Column(
            crossAxisAlignment: flutter.CrossAxisAlignment.start,
            children: [
              flutter.Text(
                cardNumber,
                style: GoogleFonts.robotoMono(
                  color: flutter.Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                  fontWeight: flutter.FontWeight.w500,
                ),
              ),
              const flutter.SizedBox(height: 12),
              flutter.Row(
                children: [
                  flutter.Text(
                    'expiry',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  const flutter.SizedBox(width: 8),
                  flutter.Text(
                    expiry,
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white,
                      fontSize: 13,
                      fontWeight: flutter.FontWeight.w600,
                    ),
                  ),
                  const flutter.SizedBox(width: 24),
                  flutter.Text(
                    'cvv',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  const flutter.SizedBox(width: 8),
                  flutter.Text(
                    isFrozen ? '***' : cvv,
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white,
                      fontSize: 13,
                      fontWeight: flutter.FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const flutter.SizedBox(height: 12),
              flutter.Row(
                children: [
                  flutter.Icon(
                    flutter.Icons.person,
                    color: flutter.Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                  const flutter.SizedBox(width: 6),
                  flutter.Text(
                    cardHolder,
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        flutter.Positioned(
          right: 24,
          bottom: 24,
          child: flutter.Column(
            children: [
              flutter.GestureDetector(
                onTap: () {
                  setState(() {
                    isFrozen = !isFrozen;
                  });
                },
                child: flutter.Container(
                  decoration: flutter.BoxDecoration(
                    color: flutter.Colors.white.withOpacity(0.1),
                    shape: flutter.BoxShape.circle,
                  ),
                  padding: const flutter.EdgeInsets.all(12),
                  child: flutter.Icon(
                    isFrozen
                        ? flutter.Icons.ac_unit
                        : flutter.Icons.ac_unit_outlined,
                    color: flutter.Colors.redAccent,
                    size: 28,
                  ),
                ),
              ),
              const flutter.SizedBox(height: 6),
              flutter.Text(
                isFrozen ? 'unfreeze' : 'freeze',
                style: GoogleFonts.montserrat(
                  color: flutter.Colors.redAccent,
                  fontSize: 13,
                  fontWeight: flutter.FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (!isFrozen)
          flutter.Positioned(
            left: 24,
            bottom: 24,
            child: flutter.GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: cardNumber.replaceAll(' ', '')),
                );
                flutter.ScaffoldMessenger.of(context).showSnackBar(
                  const flutter.SnackBar(
                    content: flutter.Text('Card number copied!'),
                  ),
                );
              },
              child: flutter.Row(
                children: [
                  flutter.Icon(
                    flutter.Icons.copy,
                    color: flutter.Colors.redAccent,
                    size: 18,
                  ),
                  const flutter.SizedBox(width: 6),
                  flutter.Text(
                    'copy details',
                    style: GoogleFonts.montserrat(
                      color: flutter.Colors.redAccent,
                      fontSize: 13,
                      fontWeight: flutter.FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        flutter.Positioned(
          right: 24,
          top: 80,
          child: flutter.Image.asset(
            'assets/icons/rupay.png',
            width: 48,
            height: 28,
            errorBuilder: (context, error, stackTrace) => flutter.Container(),
          ),
        ),
      ],
    );
  }

  flutter.Widget _buildBottomNavBar() {
    return flutter.Container(
      padding: const flutter.EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: flutter.BoxDecoration(
        color: flutter.Colors.black,
        borderRadius: const flutter.BorderRadius.only(
          topLeft: flutter.Radius.circular(24),
          topRight: flutter.Radius.circular(24),
        ),
        boxShadow: [
          flutter.BoxShadow(
            color: flutter.Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const flutter.Offset(0, -4),
          ),
        ],
      ),
      child: flutter.Row(
        mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
        children: [
          _buildNavIcon(flutter.Icons.home, false),
          _buildNavIcon(flutter.Icons.credit_card, true),
          _buildNavIcon(flutter.Icons.account_circle, false),
        ],
      ),
    );
  }

  flutter.Widget _buildNavIcon(flutter.IconData icon, bool selected) {
    return flutter.Icon(
      icon,
      color: selected
          ? flutter.Colors.white
          : flutter.Colors.white.withOpacity(0.3),
      size: 32,
    );
  }
}
