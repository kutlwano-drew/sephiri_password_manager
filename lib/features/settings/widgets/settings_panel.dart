import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/services/app_container.dart';
import '../../../core/security/recovery_dialogs.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key, required this.container});
  final AppContainer container;

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late final TextEditingController attemptsController;
  int cooldown = 15;

  @override
  void initState() {
    super.initState();
    attemptsController = TextEditingController(text: widget.container.settings.entryLockMaxAttempts.toString());
    cooldown = widget.container.settings.entryLockCooldownMinutes;
  }

  @override
  void dispose() { attemptsController.dispose(); super.dispose(); }

  Future<void> _changeRecoveryQuestion() async {
    final password = TextEditingController();
    var recovered = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm your master password'),
        content: TextField(controller: password, autofocus: true, obscureText: true, decoration: const InputDecoration(labelText: 'Master password')),
        actions: [
          TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.white),
            onPressed: () async {
              recovered = await showMasterPasswordRecoveryDialog(context, widget.container.session);
              if (recovered && context.mounted) Navigator.pop(context, true);
            },
            child: const Text('Forgot password?'),
          ),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () => Navigator.pop(context, true), child: const Text('Continue')),
        ],
      ),
    );
    final valid = confirmed == true && (recovered || await widget.container.session.verifyMasterPassword(password.text));
    password.dispose();
    if (!valid) {
      if (confirmed == true && mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect master password.')));
      return;
    }
    if (mounted) await showRecoveryQuestionSetupDialog(context, widget.container.session);
  }

  Future<void> _saveLockPolicy() async {
    final attempts = int.tryParse(attemptsController.text.trim());
    if (attempts == null || attempts < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 0 for unlimited attempts, or a positive whole number.')));
      return;
    }
    await widget.container.settings.setEntryLockPolicy(maxAttempts: attempts, cooldownMinutes: cooldown);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry lock policy saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.container.settings;
    const lockOptions = <int, String>{1: '1 minute', 5: '5 minutes', 15: '15 minutes', 30: '30 minutes', 0: 'Never automatically'};
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Preferences', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Personalise how Sephiri protects and displays your vault.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [HeroIcon(HeroIcons.shieldCheck), SizedBox(width: 10), Text('Security', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17))]),
            const SizedBox(height: 18),
            DropdownButtonFormField<int>(
              value: lockOptions.containsKey(settings.autoLockMinutes) ? settings.autoLockMinutes : 5,
              decoration: const InputDecoration(labelText: 'Auto-lock after app is in background', prefixIcon: Padding(padding: EdgeInsets.all(14), child: HeroIcon(HeroIcons.clock))),
              items: lockOptions.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
              onChanged: (value) { if (value != null) settings.setAutoLockMinutes(value); },
            ),
            const SizedBox(height: 8),
            Text('The vault will not lock when you briefly switch apps. The timer starts only after the app enters the background.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const Divider(height: 28),
            const Text('Recovery question and answer', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Choose your own question and answer. If you forget your master password, you will select this question and enter your saved answer to reset it.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Center(child: FractionallySizedBox(widthFactor: .45, child: OutlinedButton.icon(onPressed: _changeRecoveryQuestion, icon: const Icon(Icons.help_outline), label: const Text('Set / change recovery question')))),
            const Divider(height: 28),
            const Text('Locked-entry access policy', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Choose how many incorrect master-password attempts are allowed before a temporary cooldown.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            TextField(controller: attemptsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Maximum attempts', helperText: 'Enter 0 for unlimited attempts', prefixIcon: Padding(padding: EdgeInsets.all(14), child: HeroIcon(HeroIcons.hashtag)))),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(value: <int>[1, 5, 15, 30, 60, 120, 1440].contains(cooldown) ? cooldown : 15, decoration: const InputDecoration(labelText: 'Cooldown duration'), items: const [DropdownMenuItem(value: 1, child: Text('1 minute')), DropdownMenuItem(value: 5, child: Text('5 minutes')), DropdownMenuItem(value: 15, child: Text('15 minutes')), DropdownMenuItem(value: 30, child: Text('30 minutes')), DropdownMenuItem(value: 60, child: Text('1 hour')), DropdownMenuItem(value: 120, child: Text('2 hours')), DropdownMenuItem(value: 1440, child: Text('24 hours'))], onChanged: (v) { if (v != null) setState(() => cooldown = v); }),
            const SizedBox(height: 14),
            Center(child: FractionallySizedBox(widthFactor: .45, child: FilledButton(onPressed: _saveLockPolicy, style: FilledButton.styleFrom(foregroundColor: Colors.white, minimumSize: const Size(0, 44)), child: const Text('Save policy', style: TextStyle(color: Colors.white))))),
            const SizedBox(height: 12),
            Center(child: FractionallySizedBox(widthFactor: .45, child: OutlinedButton.icon(onPressed: widget.container.session.lock, icon: const HeroIcon(HeroIcons.lockClosed), label: const Text('Lock vault now')))),
          ]))),
          const SizedBox(height: 14),
          Card(child: SwitchListTile(secondary: const HeroIcon(HeroIcons.moon), title: const Text('Dark appearance'), subtitle: const Text('Use a darker interface throughout the app.'), value: settings.darkMode, onChanged: settings.setDarkMode)),
          const SizedBox(height: 14),
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Row(children: [HeroIcon(HeroIcons.circleStack), SizedBox(width: 10), Text('Local protection', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17))]),
            SizedBox(height: 14),
            _InfoRow(label: 'Storage', value: 'Local SQLite database'),
            _InfoRow(label: 'Key derivation', value: 'Argon2id'),
            _InfoRow(label: 'Encryption', value: 'XChaCha20-Poly1305'),
            _InfoRow(label: 'Network access', value: 'No account or sync server'),
          ]))),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(children: [Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), Flexible(child: Text(value, textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)))]));
}
