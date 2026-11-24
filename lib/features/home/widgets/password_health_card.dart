import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/services/password_health_service.dart';

class PasswordHealthCard extends StatelessWidget {
  const PasswordHealthCard({super.key, required this.report});
  final PasswordHealthReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeroIcon(HeroIcons.shieldCheck),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Vault health',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                //Text('${report.score}/100', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: report.score / 100,
                minHeight: 9,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                _Metric(icon: HeroIcons.key, label: 'Total ${report.total}'),
                _Metric(
                  icon: HeroIcons.exclamationTriangle,
                  label: 'Weak ${report.weak}',
                ),
                _Metric(
                  icon: HeroIcons.arrowPath,
                  label: 'Reused ${report.reused}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});
  final HeroIcons icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      HeroIcon(
        icon,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}
