import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/services/app_container.dart';
import '../../core/security/recovery_dialogs.dart';
import '../../core/services/password_health_service.dart';
import '../../core/services/vault_service.dart';
import '../../models/vault_entry.dart';
import '../../widgets/layout/app_scaffold.dart';
import '../backup/backup_screen.dart';
import '../entry/entry_editor_screen.dart';
import '../entry/widgets/category_support.dart';
import '../generator/generator_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/entry_tile.dart';
import 'widgets/password_health_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.container});
  final AppContainer container;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VaultService vault;
  final health = PasswordHealthService();
  final searchController = TextEditingController();
  String query = '';
  Timer? _lockCountdownTimer;
  bool _wasLockoutActive = false;

  @override
  void initState() {
    super.initState();
    vault = VaultService(
      database: widget.container.database,
      crypto: widget.container.crypto,
      keyProvider: () => widget.container.session.vaultKey,
    );
    _lockCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final active = widget.container.settings.entryUnlockBlocked;
      if (mounted && (active || _wasLockoutActive)) setState(() {});
      _wasLockoutActive = active;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _lockCountdownTimer?.cancel();
    super.dispose();
  }

  Future<void> add() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EntryEditorScreen(container: widget.container, vault: vault),
      ),
    );
  }

  Future<void> edit(VaultEntryModel entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EntryEditorScreen(
          container: widget.container,
          vault: vault,
          entry: entry,
        ),
      ),
    );
  }

  Future<void> _lockEntry(VaultEntryModel entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lock entry?'),
        content: Text('You will need your master password to unlock "${entry.title}". The entry will remain locked until you unlock it.'),
        actions: [
          TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () => Navigator.pop(context, true), child: const Text('Lock entry')),
        ],
      ),
    );
    if (confirmed == true && entry.id != null) {
      await vault.save(entry.copyWith(locked: true));
    }
  }

  Future<void> _unlockEntry(VaultEntryModel entry) async {
    final settings = widget.container.settings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlock entry?'),
        content: Text('Unlock "${entry.title}" permanently? You will need to confirm your master password.'),
        actions: [
          TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () => Navigator.pop(context, true), child: const Text('Continue')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final password = TextEditingController();
    var recovered = false;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm master password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: password, autofocus: !settings.entryUnlockBlocked, enabled: !settings.entryUnlockBlocked, obscureText: true, onSubmitted: (_) => Navigator.pop(context, true), decoration: const InputDecoration(labelText: 'Master password', prefixIcon: Icon(Icons.lock))),
            if (settings.entryUnlockBlocked) ...[
              const SizedBox(height: 10),
              Text(_entryLockCountdown(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800)),
            ],
          ],
        ),
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
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: settings.entryUnlockBlocked ? null : () => Navigator.pop(context, true), child: const Text('Unlock')),
        ],
      ),
    );
    if (accepted == true && mounted) {
      final valid = recovered || (!settings.entryUnlockBlocked && await widget.container.session.verifyMasterPassword(password.text));
      if (valid) {
        await settings.clearEntryLockFailures();
        if (entry.id != null) await vault.save(entry.copyWith(locked: false));
        if (mounted) {
          if (entry.id != null) {
            final refreshed = await vault.getEntry(entry.id!);
            await edit(refreshed);
          }
        }
      } else {
        if (!settings.entryUnlockBlocked) await settings.recordEntryLockFailure();
        if (mounted) {
          final blocked = settings.entryUnlockBlocked;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(blocked ? 'Entry unlocking is temporarily unavailable.' : 'Incorrect master password.')));
          setState(() {});
        }
      }
    }
    password.dispose();
  }

  String _entryLockCountdown() {
    final remaining = widget.container.settings.entryLockRemaining;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _delete(VaultEntryModel entry) async {
    final id = entry.id;
    if (id == null) return;
    await vault.delete(id);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${entry.title} deleted')));
    }
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Sephiri Password Manager',
    actions: [
      IconButton(
        tooltip: 'Password generator',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GeneratorScreen(container: widget.container),
          ),
        ),
        icon: const HeroIcon(HeroIcons.sparkles),
      ),
      IconButton(
        tooltip: 'Backup and restore',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BackupScreen(container: widget.container),
          ),
        ),
        icon: const HeroIcon(HeroIcons.arrowDownTray),
      ),
      IconButton(
        tooltip: 'Settings',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsScreen(container: widget.container),
          ),
        ),
        icon: const HeroIcon(HeroIcons.cog6Tooth),
      ),
      IconButton(
        tooltip: 'Lock vault',
        onPressed: widget.container.session.lock,
        icon: const HeroIcon(HeroIcons.lockClosed),
      ),
      const SizedBox(width: 8),
    ],
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: const Color.fromARGB(255, 34, 44, 49),
      foregroundColor: Colors.white,
      onPressed: add,
      icon: const HeroIcon(HeroIcons.plus),
      label: const Text('New entry'),
    ),
    body: StreamBuilder<List<VaultEntryModel>>(
      stream: vault.watchEntries(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Could not load vault: ${snapshot.error}'));
        }
        final allEntries = snapshot.data ?? const <VaultEntryModel>[];
        final q = query.toLowerCase().trim();
        final filtered = allEntries.where((entry) {
          return q.isEmpty ||
              entry.title.toLowerCase().contains(q) ||
              entry.username.toLowerCase().contains(q) ||
              entry.url.toLowerCase().contains(q) ||
              entry.category.toLowerCase().contains(q) ||
              entry.tags.any((tag) => tag.toLowerCase().contains(q));
        }).toList();

        final groups = <String, List<VaultEntryModel>>{};
        for (final entry in filtered) {
          groups
              .putIfAbsent(
                entry.category.trim().isEmpty ? 'Other' : entry.category,
                () => [],
              )
              .add(entry);
        }
        final categories = groups.keys.toList()..sort();

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 1100
                ? 4
                : constraints.maxWidth >= 680
                ? 3
                : 2;
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 1000 ? 36 : 18,
                vertical: 22,
              ),
              children: [
                Text(
                  'Your vault',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'All your important logins, organised in one secure place.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: searchController,
                  onChanged: (value) => setState(() => query = value),
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14),
                      child: HeroIcon(HeroIcons.magnifyingGlass),
                    ),
                    hintText: 'Search titles, usernames, websites or tags',
                  ),
                ),
                const SizedBox(height: 18),
                PasswordHealthCard(report: health.analyze(allEntries)),
                if (widget.container.settings.entryUnlockBlocked) ...[
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.center, child: Text(_entryLockCountdown(), style: const TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.w800))),
                ],
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${filtered.length} entries',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (categories.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          const HeroIcon(HeroIcons.key, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            query.isEmpty
                                ? 'Your vault is empty'
                                : 'No matching entries',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            query.isEmpty
                                ? 'Create your first login to get started.'
                                : 'Try a different search term.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ...categories.map((category) {
                  final items = groups[category]!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      leading: categoryIcon(category, widget.container.settings),
                      title: Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${items.length} ${items.length == 1 ? 'entry' : 'entries'}',
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 142,
                              ),
                          itemBuilder: (context, index) {
                            final entry = items[index];
                            return EntryTile(
                              entry: entry,
                              onTap: () => edit(entry),
                              onDelete: () => _delete(entry),
                              onLock: () => _lockEntry(entry),
                              onUnlock: () => _unlockEntry(entry),
                              settings: widget.container.settings,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 90),
              ],
            );
          },
        );
      },
    ),
  );
}
