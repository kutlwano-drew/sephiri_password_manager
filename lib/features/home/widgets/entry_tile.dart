import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../models/vault_entry.dart';
import '../../../core/services/app_settings.dart';
import '../../entry/widgets/category_support.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
    required this.onLock,
    required this.onUnlock,
    required this.settings,
  });

  final VaultEntryModel entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandIcon = _socialIcon(entry.category);
    final accent = categoryColor(entry.category, settings, fallback: _socialColor(entry.category, theme.colorScheme.primary));
    final custom = settings.customCategory(entry.category) != null;
    return InkWell(
      onTap: entry.locked ? onUnlock : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: accent,
        child: Stack(
          children: [
            Positioned(
              right: 8,
              bottom: -18,
              child: custom
                  ? categoryIcon(entry.category, settings, size: 104, color: Colors.white.withValues(alpha: .13))
                  : brandIcon != null
                      ? FaIcon(brandIcon, size: 104, color: Colors.white.withValues(alpha: .13))
                      : HeroIcon(_iconFor(entry.category), size: 104, color: Colors.white.withValues(alpha: .13)),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      if (entry.locked) const HeroIcon(HeroIcons.lockClosed, size: 17, color: Colors.white),
                      if (entry.favorite) const HeroIcon(HeroIcons.star, size: 17, color: Colors.white),
                      PopupMenuButton<String>(
                        tooltip: 'Entry actions',
                        onSelected: (value) {
                          if (value == 'delete') onDelete();
                          if (value == 'lock') onLock();
                          if (value == 'unlock') onUnlock();
                        },
                        itemBuilder: (_) => [
                          if (entry.locked)
                            const PopupMenuItem(value: 'unlock', child: Text('Unlock entry'))
                          else
                            const PopupMenuItem(value: 'lock', child: Text('Lock entry')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                        icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 19, color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    entry.title.isEmpty ? 'Untitled' : entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.locked ? 'Locked entry' : (entry.username.isEmpty ? entry.category : entry.username),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: .88)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData? _socialIcon(String category) {
    switch (category.toLowerCase()) {
      case 'facebook': return FontAwesomeIcons.facebook;
      case 'instagram': return FontAwesomeIcons.instagram;
      case 'x / twitter': case 'twitter': case 'x': return FontAwesomeIcons.xTwitter;
      case 'tiktok': return FontAwesomeIcons.tiktok;
      case 'linkedin': return FontAwesomeIcons.linkedin;
      case 'snapchat': return FontAwesomeIcons.snapchat;
      case 'reddit': return FontAwesomeIcons.reddit;
      case 'pinterest': return FontAwesomeIcons.pinterest;
      case 'youtube': return FontAwesomeIcons.youtube;
      case 'whatsapp': return FontAwesomeIcons.whatsapp;
      case 'discord': return FontAwesomeIcons.discord;
      case 'github': return FontAwesomeIcons.github;
      case 'twitch': return FontAwesomeIcons.twitch;
      case 'spotify': return FontAwesomeIcons.spotify;
      default: return null;
    }
  }

  Color _socialColor(String category, Color fallback) {
    switch (category.toLowerCase()) {
      case 'facebook': return const Color(0xFF1877F2);
      case 'instagram': return const Color(0xFFC13584);
      case 'x / twitter': case 'twitter': case 'x': return const Color(0xFF171717);
      case 'tiktok': return const Color(0xFF111111);
      case 'linkedin': return const Color(0xFF0A66C2);
      case 'snapchat': return const Color(0xFFFFC800);
      case 'reddit': return const Color(0xFFFF4500);
      case 'pinterest': return const Color(0xFFE60023);
      case 'youtube': return const Color(0xFFFF0033);
      case 'whatsapp': return const Color(0xFF25D366);
      case 'discord': return const Color(0xFF5865F2);
      case 'github': return const Color(0xFF24292F);
      case 'twitch': return const Color(0xFF9146FF);
      case 'spotify': return const Color(0xFF1DB954);
      default: return fallback;
    }
  }

  HeroIcons _iconFor(String category) {
    switch (category.toLowerCase()) {
      case 'social': return HeroIcons.chatBubbleLeftRight;
      case 'banking': return HeroIcons.banknotes;
      case 'email': return HeroIcons.envelope;
      case 'shopping': return HeroIcons.shoppingBag;
      case 'work': return HeroIcons.briefcase;
      case 'wi-fi': return HeroIcons.wifi;
      case 'secure note': return HeroIcons.documentText;
      default: return HeroIcons.key;
    }
  }
}
