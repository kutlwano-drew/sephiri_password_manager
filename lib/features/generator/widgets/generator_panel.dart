
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../../core/services/app_container.dart';

class GeneratorPanel extends StatefulWidget {
  const GeneratorPanel({super.key, required this.container});
  final AppContainer container;

  @override
  State<GeneratorPanel> createState() => _GeneratorPanelState();
}

class _GeneratorPanelState extends State<GeneratorPanel> {
  int length = 20;
  String generated = '';
  bool passphrase = false;
  bool upper = true;
  bool lower = true;
  bool numbers = true;
  bool symbols = true;

  void generate() {
    try {
      setState(() {
        generated = passphrase
            ? widget.container.generator.passphrase()
            : widget.container.generator.password(
                length: length,
                upper: upper,
                lower: lower,
                numbers: numbers,
                symbols: symbols,
              );
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  Future<void> copy() async {
    if (generated.isEmpty) return;
    await widget.container.clipboard.copySensitive(generated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied. Clipboard clears after 30 seconds.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Password'), icon: HeroIcon(HeroIcons.key)),
              ButtonSegment(value: true, label: Text('Passphrase'), icon: HeroIcon(HeroIcons.chatBubbleLeftRight)),
            ],
            selected: {passphrase},
            onSelectionChanged: (values) => setState(() => passphrase = values.first),
          ),
          if (!passphrase) ...[
            const SizedBox(height: 18),
            Text('Length: $length'),
            Slider(
              min: 8,
              max: 64,
              divisions: 56,
              value: length.toDouble(),
              onChanged: (value) => setState(() => length = value.round()),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilterChip(label: const Text('Uppercase'), selected: upper, onSelected: (value) => setState(() => upper = value)),
                FilterChip(label: const Text('Lowercase'), selected: lower, onSelected: (value) => setState(() => lower = value)),
                FilterChip(label: const Text('Numbers'), selected: numbers, onSelected: (value) => setState(() => numbers = value)),
                FilterChip(label: const Text('Symbols'), selected: symbols, onSelected: (value) => setState(() => symbols = value)),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SelectableText(
                generated.isEmpty ? 'Your secure password will appear here.' : generated,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: FractionallySizedBox(
              widthFactor: .45,
              child: FilledButton.icon(
                onPressed: generate,
                icon: const HeroIcon(HeroIcons.sparkles),
                label: const Text('Generate'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: FractionallySizedBox(
              widthFactor: .45,
              child: OutlinedButton.icon(
                onPressed: generated.isEmpty ? null : copy,
                icon: const HeroIcon(HeroIcons.clipboardDocument),
                label: const Text('Copy password'),
              ),
            ),
          ),
        ],
      );
}
