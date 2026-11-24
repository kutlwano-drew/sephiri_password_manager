import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/services/app_container.dart';
import '../../../core/security/recovery_dialogs.dart';

class UnlockForm extends StatefulWidget {
  const UnlockForm({super.key, required this.container});

  final AppContainer container;

  @override
  State<UnlockForm> createState() => _UnlockFormState();
}

class _UnlockFormState extends State<UnlockForm> {
  final password = TextEditingController();

  bool busy = false;
  bool visible = false;
  String? error;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  Future<void> unlock() async {
    if (busy || password.text.isEmpty) return;

    setState(() {
      busy = true;
      error = null;
    });

    try {
      await widget.container.session.unlock(password.text);
    } catch (_) {
      if (mounted) {
        setState(() {
          error = 'Incorrect master password. Try again.';
        });
      }
    }

    if (mounted) {
      setState(() => busy = false);
    }
  }

  Future<void> forgotPassword() async {
    await showMasterPasswordRecoveryDialog(context, widget.container.session);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lock icon
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: .10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: HeroIcon(
              HeroIcons.lockClosed,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Heading
        Text(
          'Welcome back',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 4),

        // Description
        Text(
          'Enter your master password to unlock your vault.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 16),

        // Password field
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: password,
            autofocus: true,
            obscureText: !visible,
            onSubmitted: (_) => unlock(),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              labelText: 'Master password',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: HeroIcon(HeroIcons.key, size: 20),
              ),
              suffixIcon: IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: visible ? 'Hide password' : 'Show password',
                onPressed: () {
                  setState(() => visible = !visible);
                },
                icon: HeroIcon(
                  visible ? HeroIcons.eyeSlash : HeroIcons.eye,
                  size: 20,
                ),
              ),
            ),
          ),
        ),

        // Error message
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
          ),
        ],

        const SizedBox(height: 14),

        // Unlock button
        FractionallySizedBox(
          widthFactor: .45,
          child: SizedBox(
            height: 42,
            child: FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: busy ? null : unlock,
              child: Text(
                busy ? 'Unlocking…' : 'Unlock vault',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        TextButton(
          onPressed: busy ? null : forgotPassword,
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 30),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          ),
          child: const Text('Forgot password?'),
        ),

        const SizedBox(height: 6),

        // Security note
        Text(
          'Your passwords are encrypted and stored on this device.',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
