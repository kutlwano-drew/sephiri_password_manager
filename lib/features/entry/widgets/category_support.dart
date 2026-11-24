import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../core/services/app_settings.dart';

T? _firstOrNull<T>(Iterable<T> values) { for (final value in values) { return value; } return null; }

const Map<String, Map<String, dynamic>> builtInCategoryInfo = {
  'Login': {'icon': 'hero:key', 'color': 0xFF536DFE, 'fields': ['username', 'password', 'url', 'notes', 'tags']},
  'Email': {'icon': 'hero:envelope', 'color': 0xFF2563EB, 'fields': ['email', 'password', 'phone', 'url', 'notes', 'tags']},
  'Banking': {'icon': 'hero:banknotes', 'color': 0xFF16845B, 'fields': ['username', 'account_number', 'phone', 'security_code', 'password', 'url', 'notes', 'tags']},
  'Social': {'icon': 'hero:chatBubbleLeftRight', 'color': 0xFF7C3AED, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Facebook': {'icon': 'social:facebook', 'color': 0xFF1877F2, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Instagram': {'icon': 'social:instagram', 'color': 0xFFC13584, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'X / Twitter': {'icon': 'social:x', 'color': 0xFF171717, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'TikTok': {'icon': 'social:tiktok', 'color': 0xFF111111, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'LinkedIn': {'icon': 'social:linkedin', 'color': 0xFF0A66C2, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Snapchat': {'icon': 'social:snapchat', 'color': 0xFFFFC800, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Reddit': {'icon': 'social:reddit', 'color': 0xFFFF4500, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'Pinterest': {'icon': 'social:pinterest', 'color': 0xFFE60023, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'YouTube': {'icon': 'social:youtube', 'color': 0xFFFF0033, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'WhatsApp': {'icon': 'social:whatsapp', 'color': 0xFF25D366, 'fields': ['username', 'phone', 'email', 'password', 'url', 'notes', 'tags']},
  'Discord': {'icon': 'social:discord', 'color': 0xFF5865F2, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'GitHub': {'icon': 'social:github', 'color': 0xFF24292F, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'Twitch': {'icon': 'social:twitch', 'color': 0xFF9146FF, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'Spotify': {'icon': 'social:spotify', 'color': 0xFF1DB954, 'fields': ['username', 'email', 'password', 'url', 'notes', 'tags']},
  'Shopping': {'icon': 'hero:shoppingBag', 'color': 0xFFEA580C, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Work': {'icon': 'hero:briefcase', 'color': 0xFF475569, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
  'Wi-Fi': {'icon': 'hero:wifi', 'color': 0xFF0891B2, 'fields': ['username', 'password', 'notes', 'tags']},
  'License': {'icon': 'hero:identification', 'color': 0xFF64748B, 'fields': ['license_number', 'expiry_date', 'notes', 'tags']},
  'Secure note': {'icon': 'hero:documentText', 'color': 0xFF7C3AED, 'fields': ['notes', 'tags']},
  'Other': {'icon': 'hero:squares2x2', 'color': 0xFF64748B, 'fields': ['username', 'email', 'phone', 'password', 'url', 'notes', 'tags']},
};

const Map<String, IconData> materialIconChoices = {
  'folder': Icons.folder,
  'key': Icons.key,
  'work': Icons.work,
  'home': Icons.home,
  'phone': Icons.phone,
  'email': Icons.email,
  'language': Icons.language,
  'computer': Icons.computer,
  'laptop': Icons.laptop,
  'smartphone': Icons.smartphone,
  'tablet': Icons.tablet,
  'credit card': Icons.credit_card,
  'account balance': Icons.account_balance,
  'shopping cart': Icons.shopping_cart,
  'shopping bag': Icons.shopping_bag,
  'school': Icons.school,
  'medical': Icons.medical_services,
  'cloud': Icons.cloud,
  'wifi': Icons.wifi,
  'lock': Icons.lock,
  'security': Icons.security,
  'vpn': Icons.vpn_key,
  'notes': Icons.notes,
  'description': Icons.description,
  'calendar': Icons.calendar_month,
  'camera': Icons.camera_alt,
  'music': Icons.music_note,
  'video': Icons.video_library,
  'game': Icons.sports_esports,
  'travel': Icons.flight,
  'car': Icons.directions_car,
  'database': Icons.storage,
  'server': Icons.dns,
  'code': Icons.code,
  'terminal': Icons.terminal,
  'settings': Icons.settings,
  'person': Icons.person,
  'group': Icons.groups,
  'star': Icons.star,
  'favorite': Icons.favorite,
  'bookmark': Icons.bookmark,
  'wallet': Icons.account_balance_wallet,
  'receipt': Icons.receipt_long,
  'store': Icons.store,
  'pets': Icons.pets,
  'fitness': Icons.fitness_center,
  'restaurant': Icons.restaurant,
  'gift': Icons.card_giftcard,
};

IconData? socialBrandIcon(String name) {
  switch (name.toLowerCase()) {
    case 'facebook': return FontAwesomeIcons.facebook;
    case 'instagram': return FontAwesomeIcons.instagram;
    case 'x': case 'x / twitter': case 'twitter': return FontAwesomeIcons.xTwitter;
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

Color categoryColor(String name, AppSettings settings, {Color fallback = const Color(0xFF536DFE)}) {
  final custom = settings.customCategory(name);
  final value = custom?['color'] ?? builtInCategoryInfo[name]?['color'];
  if (value is int) return Color(value);
  return fallback;
}

String categoryIconKey(String name, AppSettings settings) {
  return (settings.customCategory(name)?['icon'] ?? builtInCategoryInfo[name]?['icon'] ?? 'hero:folder').toString();
}

Widget categoryIcon(String name, AppSettings settings, {double size = 22, Color? color}) {
  final key = categoryIconKey(name, settings);
  final tint = color ?? categoryColor(name, settings);
  if (key.startsWith('social:')) {
    return FaIcon(socialBrandIcon(key.substring(7)) ?? FontAwesomeIcons.globe, size: size, color: tint);
  }
  if (key.startsWith('material:')) {
    final code = int.tryParse(key.substring(9));
    final data = _firstOrNull(materialIconChoices.values.where((e) => e.codePoint == code));
    return Icon(data ?? Icons.folder, size: size, color: tint);
  }
  final nameKey = key.startsWith('hero:') ? key.substring(5) : 'folder';
  final icon = _firstOrNull(HeroIcons.values.where((e) => e.name == nameKey)) ?? HeroIcons.folder;
  return HeroIcon(icon, size: size, color: tint);
}

class CategoryEditorDialog extends StatefulWidget {
  const CategoryEditorDialog({super.key, required this.settings});
  final AppSettings settings;

  @override
  State<CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<CategoryEditorDialog> {
  final nameController = TextEditingController();
  String iconKey = 'hero:folder';
  Color color = const Color(0xFF536DFE);
  final Set<String> selectedFields = {'username', 'password', 'url', 'notes', 'tags'};
  final Set<String> platforms = {'Website', 'Mobile app', 'Desktop app'};
  final List<Map<String, dynamic>> customFields = [];

  static const fieldLabels = {
    'username': 'Username', 'email': 'Email address', 'phone': 'Phone number',
    'password': 'Password', 'url': 'Website URL', 'notes': 'Secure notes',
    'tags': 'Tags', 'account_number': 'Account number', 'recovery_email': 'Recovery email',
    'address': 'Address', 'date': 'Date', 'security_code': 'Security code',
    'license_number': 'License number', 'expiry_date': 'Expiry date',
  };

  @override
  void dispose() { nameController.dispose(); super.dispose(); }

  Future<void> chooseIcon() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _IconPickerDialog(selected: iconKey),
    );
    if (result != null) setState(() => iconKey = result);
  }

  Future<void> chooseColor() async {
    var red = color.red.toDouble();
    var green = color.green.toDouble();
    var blue = color.blue.toDouble();
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) {
          final preview = Color.fromARGB(255, red.round(), green.round(), blue.round());
          return AlertDialog(
            title: const Text('Choose icon colour'),
            content: SizedBox(width: 340, child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(height: 54, width: double.infinity, decoration: BoxDecoration(color: preview, borderRadius: BorderRadius.circular(12))),
              const SizedBox(height: 14),
              _colorSlider('Red', red, (v) => setDialog(() => red = v), Colors.red),
              _colorSlider('Green', green, (v) => setDialog(() => green = v), Colors.green),
              _colorSlider('Blue', blue, (v) => setDialog(() => blue = v), Colors.blue),
            ])),
            actions: [
              TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () => Navigator.pop(context, preview), child: const Text('Select')),
            ],
          );
        },
      ),
    );
    if (picked != null) setState(() => color = picked);
  }

  Widget _colorSlider(String label, double value, ValueChanged<double> onChanged, Color accent) => Row(children: [
    SizedBox(width: 48, child: Text(label)),
    Expanded(child: Slider(value: value, min: 0, max: 255, activeColor: accent, onChanged: onChanged)),
    SizedBox(width: 30, child: Text(value.round().toString())),
  ]);

  Future<void> addCustomField() async {
    final label = TextEditingController();
    final hint = TextEditingController();
    String inputType = 'text';
    String validation = 'none';
    String fieldIcon = 'hero:adjustmentsHorizontal';
    final Set<String> behaviours = {};
    bool obscure = false;
    final result = await showDialog<Map<String, dynamic>>(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialog) => AlertDialog(
      title: const Text('Create custom field'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: label, decoration: const InputDecoration(labelText: 'Field label')),
        const SizedBox(height: 10),
        TextField(controller: hint, decoration: const InputDecoration(labelText: 'Hint text')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: inputType, decoration: const InputDecoration(labelText: 'Input type', helperText: 'Choose the keyboard and layout that fit this value.'), items: const [
          DropdownMenuItem(value: 'text', child: Text('Text')), DropdownMenuItem(value: 'email', child: Text('Email')), DropdownMenuItem(value: 'phone', child: Text('Phone number')), DropdownMenuItem(value: 'number', child: Text('Number')), DropdownMenuItem(value: 'url', child: Text('Website URL')), DropdownMenuItem(value: 'multiline', child: Text('Long text')),
        ], onChanged: (v) => setDialog(() => inputType = v ?? 'text')),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(value: validation, decoration: const InputDecoration(labelText: 'Validation', helperText: 'Choose how the app checks the value before saving.'), items: const [
          DropdownMenuItem(value: 'none', child: Text('No validation')), DropdownMenuItem(value: 'required', child: Text('Must not be empty')), DropdownMenuItem(value: 'email', child: Text('Valid email address')), DropdownMenuItem(value: 'phone', child: Text('Phone number')), DropdownMenuItem(value: 'url', child: Text('Valid website address')), DropdownMenuItem(value: 'numeric', child: Text('Numbers only')), DropdownMenuItem(value: 'min6', child: Text('At least 6 characters')),
        ], onChanged: (v) => setDialog(() => validation = v ?? 'none')),
        const SizedBox(height: 10),
        Center(child: FractionallySizedBox(widthFactor: .45, child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.white),
          onPressed: () async {
            final picked = await showDialog<String>(context: context, builder: (_) => _IconPickerDialog(selected: fieldIcon));
            if (picked != null) setDialog(() => fieldIcon = picked);
          },
          icon: const Icon(Icons.apps),
          label: const Text('Choose leading icon'),
        ))),
        const SizedBox(height: 10),
        const Align(alignment: Alignment.centerLeft, child: Text('Field behaviours', style: TextStyle(fontWeight: FontWeight.w700))),
        CheckboxListTile(value: obscure, onChanged: (v) => setDialog(() { obscure = v ?? false; if (obscure) behaviours.add('reveal'); }), title: const Text('Hide value by default'), subtitle: const Text('Masks the value like a password. Add the reveal option to let the user show it.'), contentPadding: EdgeInsets.zero),
        CheckboxListTile(value: behaviours.contains('reveal'), onChanged: (v) => setDialog(() { if (v == true) { behaviours.add('reveal'); } else { behaviours.remove('reveal'); obscure = false; } }), title: const Text('Show / hide button'), subtitle: const Text('Adds an eye button at the end of the field.'), contentPadding: EdgeInsets.zero),
        CheckboxListTile(value: behaviours.contains('copy'), onChanged: (v) => setDialog(() { if (v == true) { behaviours.add('copy'); } else { behaviours.remove('copy'); } }), title: const Text('Copy button'), subtitle: const Text('Adds a copy button at the end of the field.'), contentPadding: EdgeInsets.zero),
      ])),
      actions: [TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () { if (label.text.trim().isEmpty) return; Navigator.pop(context, {'label': label.text.trim(), 'hint': hint.text.trim(), 'type': inputType, 'validation': validation, 'obscure': obscure, 'icon': fieldIcon, 'iconColor': color.value, 'behaviours': behaviours.toList()}); }, child: const Text('Add field'))],
    )));
    label.dispose(); hint.dispose();
    if (result != null) {
      final duplicate = customFields.any((field) =>
          (field['label'] as String).toLowerCase() ==
          (result['label'] as String).toLowerCase());
      if (duplicate) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A custom field with that label already exists.')),
        );
      } else {
        setState(() => customFields.add(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Create category'),
    content: SizedBox(width: 460, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        InkWell(onTap: chooseIcon, child: Container(width: 54, height: 54, decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(12)), child: Center(child: _previewIcon()))),
        const SizedBox(width: 12),
        Expanded(child: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category name', hintText: 'e.g. Streaming services'))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: FractionallySizedBox(widthFactor: .9, child: OutlinedButton.icon(style: OutlinedButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.white), onPressed: chooseIcon, icon: const Icon(Icons.apps), label: const Text('Choose icon')))),
        const SizedBox(width: 10),
        Expanded(child: FractionallySizedBox(widthFactor: .9, child: OutlinedButton.icon(style: OutlinedButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.white), onPressed: chooseColor, icon: const Icon(Icons.palette_outlined), label: const Text('Colour')))),
      ]),
      const SizedBox(height: 16),
      const Text('Where is this entry used?', style: TextStyle(fontWeight: FontWeight.w700)),
      ...['Website', 'Mobile app', 'Desktop app'].map((p) => CheckboxListTile(value: platforms.contains(p), onChanged: (v) => setState(() { if (v == true) { platforms.add(p); } else { platforms.remove(p); } }), title: Text(p), dense: true, contentPadding: EdgeInsets.zero)),
      const SizedBox(height: 8),
      const Text('Fields to show', style: TextStyle(fontWeight: FontWeight.w700)),
      ...fieldLabels.entries.map((e) => CheckboxListTile(value: selectedFields.contains(e.key), onChanged: (v) => setState(() { if (v == true) { selectedFields.add(e.key); } else { selectedFields.remove(e.key); } }), title: Text(e.value), dense: true, contentPadding: EdgeInsets.zero)),
      const SizedBox(height: 8),
      Row(children: [const Expanded(child: Text('Your custom fields', style: TextStyle(fontWeight: FontWeight.w700))), TextButton.icon(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.white), onPressed: addCustomField, icon: const Icon(Icons.add), label: const Text('Add field'))]),
      ...customFields.map((f) => ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: const Icon(Icons.text_fields), title: Text(f['label'] as String), subtitle: Text('${f['type']} • ${f['validation']}'), trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => customFields.remove(f))))),
    ]))),
    actions: [TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: () async {
      final name = nameController.text.trim();
      if (name.isEmpty) return;
      if (builtInCategoryInfo.keys.any((existing) => existing.toLowerCase() == name.toLowerCase()) ||
          widget.settings.customCategory(name) != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('That category already exists. Choose a different name.')));
        return;
      }
      await widget.settings.saveCustomCategory({'name': name, 'icon': iconKey, 'color': color.value, 'fields': selectedFields.toList(), 'platforms': platforms.toList(), 'customFields': customFields});
      if (context.mounted) Navigator.pop(context, name);
    }, child: const Text('Save'))],
  );

  Widget _previewIcon() {
    if (iconKey.startsWith('hero:')) {
      final n = iconKey.substring(5);
      final icon = _firstOrNull(HeroIcons.values.where((e) => e.name == n)) ?? HeroIcons.folder;
      return HeroIcon(icon, color: color, size: 27);
    }
    if (iconKey.startsWith('social:')) return FaIcon(socialBrandIcon(iconKey.substring(7)) ?? FontAwesomeIcons.globe, color: color, size: 25);
    final code = int.tryParse(iconKey.substring(9));
    final data = _firstOrNull(materialIconChoices.values.where((e) => e.codePoint == code));
    return Icon(data ?? Icons.folder, color: color, size: 27);
  }
}

class _IconPickerDialog extends StatefulWidget {
  const _IconPickerDialog({required this.selected});
  final String selected;
  @override
  State<_IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<_IconPickerDialog> {
  final search = TextEditingController();
  String selected = '';
  @override
  void initState() { super.initState(); selected = widget.selected; }
  @override
  void dispose() { search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final q = search.text.toLowerCase();
    final heroes = HeroIcons.values.where((e) => e.name.toLowerCase().contains(q)).toList();
    final materials = materialIconChoices.entries.where((e) => e.key.contains(q)).toList();
    final socials = ['facebook','instagram','x','tiktok','linkedin','snapchat','reddit','pinterest','youtube','whatsapp','discord','github','twitch','spotify'].where((e) => e.contains(q)).toList();
    return AlertDialog(
      title: const Text('Choose an icon'),
      content: SizedBox(width: 520, height: 520, child: Column(children: [
        TextField(controller: search, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search icons...')),
        const SizedBox(height: 12),
        Expanded(child: ListView(children: [
          _section('Heroicons', heroes.map((e) => _IconChoice(keyName: 'hero:${e.name}', selected: selected, icon: HeroIcon(e, color: Colors.white), onTap: (v) => setState(() => selected = v))).toList()),
          _section('Material icons', materials.map((e) => _IconChoice(keyName: 'material:${e.value.codePoint}', selected: selected, icon: Icon(e.value, color: Colors.white), onTap: (v) => setState(() => selected = v))).toList()),
          _section('Social brands', socials.map((e) => _IconChoice(keyName: 'social:$e', selected: selected, icon: FaIcon(socialBrandIcon(e) ?? FontAwesomeIcons.globe, color: Colors.white), onTap: (v) => setState(() => selected = v))).toList()),
        ])),
      ])),
      actions: [TextButton(style: TextButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.red), onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: .7), foregroundColor: Colors.green), onPressed: selected.isEmpty ? null : () => Navigator.pop(context, selected), child: const Text('Select'))],
    );
  }

  Widget _section(String title, List<Widget> choices) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Wrap(spacing: 6, runSpacing: 6, children: choices)]));
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({required this.keyName, required this.selected, required this.icon, required this.onTap});
  final String keyName; final String selected; final Widget icon; final ValueChanged<String> onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: () => onTap(keyName), child: Container(width: 43, height: 43, decoration: BoxDecoration(color: selected == keyName ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest, border: Border.all(color: selected == keyName ? Theme.of(context).colorScheme.primary : Colors.transparent), borderRadius: BorderRadius.circular(9)), child: Center(child: icon)));
}
