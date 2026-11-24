import 'package:flutter/material.dart';
import '../../core/services/app_container.dart';
import '../../core/services/vault_service.dart';
import '../../models/vault_entry.dart';
import '../../widgets/layout/app_scaffold.dart';
import 'widgets/entry_form.dart';

class EntryEditorScreen extends StatelessWidget {
  const EntryEditorScreen({super.key, required this.container, required this.vault, this.entry});
  final AppContainer container; final VaultService vault; final VaultEntryModel? entry;
  @override Widget build(BuildContext context) => AppScaffold(title: entry == null ? 'New entry' : 'Edit entry', body: EntryForm(container: container, vault: vault, entry: entry));
}
