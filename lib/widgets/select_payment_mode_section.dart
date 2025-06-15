import 'package:flutter/material.dart';

/// Enum for payment modes
enum PaymentMode { pay, card }

/// Section widget for selecting payment mode, matching the provided UI
class SelectPaymentModeSection extends StatelessWidget {
  final PaymentMode selectedMode;
  final ValueChanged<PaymentMode> onModeChanged;
  const SelectPaymentModeSection({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'select payment mode',
            style: TextStyle(
              fontFamily: 'Inter', // fallback to Roboto/SF if not available
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.25,
              color: Colors.white,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: const Text(
              'choose your preferred payment method to make payment.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.45,
                color: Color(0x99FFFFFF),
                letterSpacing: 0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Capsule toggle row
          PaymentModeToggle(selected: selectedMode, onChanged: onModeChanged),
        ],
      ),
    );
  }
}

/// Capsule toggle for payment mode selection
class PaymentModeToggle extends StatelessWidget {
  final PaymentMode selected;
  final ValueChanged<PaymentMode> onChanged;
  const PaymentModeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CapsuleButton(
          label: 'pay',
          selected: selected == PaymentMode.pay,
          onTap: () => onChanged(PaymentMode.pay),
          selectedGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0x1AFFFFFF)],
          ),
          selectedTextColor: Colors.white,
          selectedFill: Colors.black,
          unselectedTextColor: Colors.white,
          unselectedFill: Colors.transparent,
          borderColor: Colors.transparent,
        ),
        const SizedBox(width: 12),
        _CapsuleButton(
          label: 'card',
          selected: selected == PaymentMode.card,
          onTap: () => onChanged(PaymentMode.card),
          selectedGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF0000), Color(0x00FF0000)],
          ),
          selectedTextColor: Color(0xFFFF0000),
          selectedFill: Colors.transparent,
          unselectedTextColor: Color(0xFFFF0000),
          unselectedFill: Colors.transparent,
          borderColor: Colors.transparent,
        ),
      ],
    );
  }
}

/// Capsule button with animated gradient border and fill
class _CapsuleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final LinearGradient selectedGradient;
  final Color selectedTextColor;
  final Color selectedFill;
  final Color unselectedTextColor;
  final Color unselectedFill;
  final Color borderColor;
  const _CapsuleButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedGradient,
    required this.selectedTextColor,
    required this.selectedFill,
    required this.unselectedTextColor,
    required this.unselectedFill,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Outer: gradient border, Inner: fill
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        height: 36,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: selected ? selectedGradient : null,
          color: selected ? null : borderColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? selectedFill : unselectedFill,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: selected ? selectedTextColor : unselectedTextColor,
                letterSpacing: 0,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
