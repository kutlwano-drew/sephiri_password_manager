
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/services/app_container.dart';
import '../../../core/security/recovery_dialogs.dart';

class SetupForm extends StatefulWidget {
  const SetupForm({super.key, required this.container});
  final AppContainer container;

  @override
  State<SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends State<SetupForm> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool busy = false;
  bool visible = false;
  String? error;

  String get strength {
    final value = password.text;
    if (value.isEmpty) return 'Enter a master password';
    final classes = [
      RegExp(r'[a-z]').hasMatch(value),
      RegExp(r'[A-Z]').hasMatch(value),
      RegExp(r'[0-9]').hasMatch(value),
      RegExp(r'[^A-Za-z0-9]').hasMatch(value),
    ].where((x) => x).length;
    if (value.length >= 14 && classes >= 3) return 'Strong';
    if (value.length >= 10 && classes >= 2) return 'Medium';
    return 'Weak';
  }

  Color strengthColor(ThemeData theme) {
    if (strength.startsWith('Strong')) return Colors.green;
    if (strength.startsWith('Medium')) return Colors.orange;
    return theme.colorScheme.error;
  }

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (password.text != confirm.text) {
        throw StateError('Passwords do not match.');
      }
      await widget.container.session.createVault(password.text);
      if (mounted) {
        await showRecoveryQuestionSetupDialog(
          context,
          widget.container.session,
          allowCancel: false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => error = e.toString().replaceFirst('Bad state: ', ''));
      }
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: HeroIcon(HeroIcons.lockClosed, size: 38, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 20),
          Text('Create your vault', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            'One strong master password protects everything in your vault.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: constraints.maxWidth * .90,
            child: TextField(
              controller: password,
              obscureText: !visible,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Master password',
                prefixIcon: const Padding(padding: EdgeInsets.all(14), child: HeroIcon(HeroIcons.key)),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => visible = !visible),
                  icon: HeroIcon(visible ? HeroIcons.eyeSlash : HeroIcons.eye),
                ),
              ),
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * .90,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 20),
              child: Row(
                children: [
                  HeroIcon(HeroIcons.shieldCheck, size: 16, color: strengthColor(theme)),
                  const SizedBox(width: 7),
                  Text(strength, style: TextStyle(color: strengthColor(theme), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * .90,
            child: TextField(
              controller: confirm,
              obscureText: !visible,
              decoration: const InputDecoration(
                labelText: 'Confirm master password',
                prefixIcon: Padding(padding: EdgeInsets.all(14), child: HeroIcon(HeroIcons.checkCircle)),
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: constraints.maxWidth * .45,
              height: 52,
              child: FilledButton(
                onPressed: busy ? null : submit,
                child: Text(busy ? 'Creating vault…' : 'Create vault'),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Your master password is never sent anywhere.', style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
