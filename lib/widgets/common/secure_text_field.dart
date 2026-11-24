
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SecureTextField extends StatefulWidget {
  const SecureTextField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.validator,
    this.onChanged,
    this.showStrength = false,
    this.onCopy,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool showStrength;
  final VoidCallback? onCopy;

  @override
  State<SecureTextField> createState() => _SecureTextFieldState();
}

class _SecureTextFieldState extends State<SecureTextField> {
  bool visible = false;

  String get _strength {
    final value = widget.controller.text;
    if (value.isEmpty) return '';
    final classes = [
      RegExp(r'[a-z]').hasMatch(value),
      RegExp(r'[A-Z]').hasMatch(value),
      RegExp(r'[0-9]').hasMatch(value),
      RegExp(r'[^A-Za-z0-9]').hasMatch(value),
    ].where((matched) => matched).length;
    if (value.length >= 14 && classes >= 3) return 'Strong';
    if (value.length >= 10 && classes >= 2) return 'Medium';
    return 'Weak';
  }

  Color _strengthColor(BuildContext context) {
    switch (_strength) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Weak':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: !visible,
          validator: widget.validator,
          onChanged: (value) {
            setState(() {});
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: HeroIcon(HeroIcons.lockClosed),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.onCopy != null)
                  IconButton(
                    tooltip: 'Copy password',
                    icon: const HeroIcon(HeroIcons.clipboardDocument),
                    onPressed: widget.onCopy,
                  ),
                IconButton(
                  tooltip: visible ? 'Hide password' : 'Show password',
                  icon: HeroIcon(visible ? HeroIcons.eyeSlash : HeroIcons.eye),
                  onPressed: () => setState(() => visible = !visible),
                ),
              ],
            ),
          ),
        ),
        if (widget.showStrength && _strength.isNotEmpty) ...[
          const SizedBox(height: 7),
          Row(
            children: [
              HeroIcon(HeroIcons.shieldCheck, size: 16, color: _strengthColor(context)),
              const SizedBox(width: 7),
              Text(
                _strength,
                style: TextStyle(color: _strengthColor(context), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
