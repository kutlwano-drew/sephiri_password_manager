
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../core/services/app_container.dart';
import '../../widgets/layout/app_scaffold.dart';
import 'widgets/settings_panel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.container});
  final AppContainer container;

  @override
  Widget build(BuildContext context) => AppScaffold(
        title: 'Settings',
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: HeroIcon(HeroIcons.cog6Tooth))],
        body: SettingsPanel(container: container),
      );
}
