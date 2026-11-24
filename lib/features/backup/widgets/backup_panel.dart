
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../../core/services/app_container.dart';

class BackupPanel extends StatefulWidget {
  const BackupPanel({super.key, required this.container});
  final AppContainer container;

  @override
  State<BackupPanel> createState() => _BackupPanelState();
}

class _BackupPanelState extends State<BackupPanel> {
  final password = TextEditingController();
  bool busy = false;
  bool visible = false;
  String? message;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  Future<void> exportBackup() async {
    if (password.text.length < 10) {
      setState(() => message = 'Use at least 10 characters for the backup password.');
      return;
    }
    setState(() {
      busy = true;
      message = null;
    });
    try {
      final bytes = await widget.container.backup.exportVault(password.text);
      final path = await FilePicker.saveFile(
        fileName: 'sephiri-backup-${DateTime.now().toIso8601String().substring(0, 10)}.ovb',
        bytes: bytes,
      );
      if (mounted) setState(() => message = path == null ? 'Export cancelled.' : 'Backup exported successfully.');
    } catch (error) {
      if (mounted) setState(() => message = 'Export failed: $error');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> importBackup() async {
    if (password.text.isEmpty) {
      setState(() => message = 'Enter the backup password before importing.');
      return;
    }
    final file = await FilePicker.pickFile();
    if (file == null) return;
    setState(() {
      busy = true;
      message = null;
    });
    try {
      final bytes = await file.readAsBytes();
      final count = await widget.container.backup.importVault(bytes, password.text);
      if (mounted) setState(() => message = 'Imported $count entries.');
    } catch (_) {
      if (mounted) setState(() => message = 'Import failed. Check the backup password and file.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Encrypted backups', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Create an encrypted copy of your vault or restore entries from an existing backup.'),
          const SizedBox(height: 20),
          TextField(
            controller: password,
            obscureText: !visible,
            decoration: InputDecoration(
              labelText: 'Backup password',
              prefixIcon: const Padding(padding: EdgeInsets.all(14), child: HeroIcon(HeroIcons.key)),
              suffixIcon: IconButton(
                onPressed: () => setState(() => visible = !visible),
                icon: HeroIcon(visible ? HeroIcons.eyeSlash : HeroIcons.eye),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: FractionallySizedBox(
              widthFactor: .45,
              child: FilledButton.icon(
                onPressed: busy ? null : exportBackup,
                icon: const HeroIcon(HeroIcons.arrowUpTray),
                label: Text(busy ? 'Working…' : 'Export encrypted backup'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: FractionallySizedBox(
              widthFactor: .45,
              child: OutlinedButton.icon(
                onPressed: busy ? null : importBackup,
                icon: const HeroIcon(HeroIcons.arrowDownTray),
                label: const Text('Import encrypted backup'),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!),
          ],
        ],
      );
}
