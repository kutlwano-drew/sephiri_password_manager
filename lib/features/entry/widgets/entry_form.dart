import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import '../../../models/vault_entry.dart';
import '../../../widgets/common/secure_text_field.dart';
import '../../../core/services/app_container.dart';
import '../../../core/services/vault_service.dart';
import 'category_support.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({
    super.key,
    required this.container,
    required this.vault,
    this.entry,
  });
  final AppContainer container;
  final VaultService vault;
  final VaultEntryModel? entry;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final title = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final url = TextEditingController();
  final notes = TextEditingController();
  final tagInput = TextEditingController();
  final Map<String, TextEditingController> dynamicControllers = {};
  final Map<String, bool> customFieldVisibility = {};
  final List<String> entryTags = [];
  final formKey = GlobalKey<FormState>();

  String category = 'Login';
  String platform = 'Website';
  bool favorite = false;
  bool busy = false;

  List<String> get _fields {
    final custom = widget.container.settings.customCategory(category);
    if (custom != null)
      return List<String>.from(custom['fields'] as List? ?? const []);
    return List<String>.from(
      builtInCategoryInfo[category]?['fields'] as List? ??
          const ['username', 'password', 'url', 'notes', 'tags'],
    );
  }

  List<Map<String, dynamic>> get _customFieldDefinitions {
    final custom = widget.container.settings.customCategory(category);
    return (custom?['customFields'] as List? ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  List<String> get _platforms {
    final custom = widget.container.settings.customCategory(category);
    return List<String>.from(
      custom?['platforms'] as List? ??
          const ['Website', 'Mobile app', 'Desktop app'],
    );
  }

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    if (entry != null) {
      title.text = entry.title;
      username.text = entry.username;
      password.text = entry.password;
      url.text = entry.url;
      notes.text = entry.notes;
      entryTags.addAll(entry.tags);
      category = entry.category;
      favorite = entry.favorite;
      for (final item in entry.customFields.entries) {
        dynamicControllers[item.key] = TextEditingController(text: item.value);
      }
      platform = entry.customFields['_platform'] ?? 'Website';
    }
  }

  @override
  void dispose() {
    title.dispose();
    username.dispose();
    password.dispose();
    url.dispose();
    notes.dispose();
    tagInput.dispose();
    for (final controller in dynamicControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isEmpty) return;
    if (!entryTags.any((e) => e.toLowerCase() == tag.toLowerCase())) {
      entryTags.add(tag);
    }
  }

  void handleTagInput(String value) {
    if (!value.contains(',')) return;
    final parts = value.split(',');
    for (final part in parts.take(parts.length - 1)) {
      _addTag(part);
    }
    final remaining = parts.last;
    tagInput.value = TextEditingValue(
      text: remaining,
      selection: TextSelection.collapsed(offset: remaining.length),
    );
    setState(() {});
  }

  Future<void> _createCategory() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => CategoryEditorDialog(settings: widget.container.settings),
    );
    if (result != null && mounted)
      setState(() {
        category = result;
        platform = _platforms.isNotEmpty ? _platforms.first : '';
      });
  }

  TextEditingController _controllerFor(String key) =>
      dynamicControllers.putIfAbsent(key, () => TextEditingController());

  String _fieldLabel(String key) {
    const labels = {
      'username': 'Username',
      'email': 'Email address',
      'phone': 'Phone number',
      'account_number': 'Account number',
      'recovery_email': 'Recovery email',
      'address': 'Address',
      'date': 'Date',
      'security_code': 'Security code',
      'license_number': 'License number',
      'expiry_date': 'Expiry date',
    };
    return labels[key] ??
        key
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}',
            )
            .join(' ');
  }

  InputDecoration _decoration(String label, HeroIcons icon) => InputDecoration(
    labelText: label,
    prefixIcon: Padding(
      padding: const EdgeInsets.all(14),
      child: HeroIcon(icon),
    ),
  );

  Widget _standardField(String key) {
    switch (key) {
      case 'username':
        return TextFormField(
          controller: username,
          decoration: _decoration('Username', HeroIcons.user),
        );
      case 'email':
        final controller = dynamicControllers.putIfAbsent(
          'email',
          () => TextEditingController(
            text:
                widget.entry?.customFields['email'] ??
                (widget.entry?.category == 'Email'
                    ? widget.entry?.username
                    : null) ??
                '',
          ),
        );
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration('Email address', HeroIcons.envelope),
          validator: (v) =>
              v != null &&
                  v.isNotEmpty &&
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
              ? 'Enter a valid email address'
              : null,
        );
      case 'password':
        return SecureTextField(
          controller: password,
          showStrength: true,
          onCopy: () async {
            if (password.text.isEmpty) return;
            await widget.container.clipboard.copySensitive(password.text);
            if (mounted)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password copied. Clipboard clears after 30 seconds.',
                  ),
                ),
              );
          },
        );
      case 'url':
        return TextFormField(
          controller: url,
          keyboardType: TextInputType.url,
          decoration: _decoration('Website URL', HeroIcons.globeAlt),
        );
      case 'phone':
        return TextFormField(
          controller: _controllerFor('phone'),
          keyboardType: TextInputType.phone,
          decoration: _decoration('Phone number', HeroIcons.phone),
        );
      case 'notes':
        return TextFormField(
          controller: notes,
          minLines: 5,
          maxLines: 8,
          decoration: _decoration('Private notes', HeroIcons.documentText),
        );
      case 'tags':
        return _buildTagsField();
      case 'account_number':
      case 'recovery_email':
      case 'address':
      case 'date':
      case 'security_code':
      case 'license_number':
      case 'expiry_date':
        final type = key == 'recovery_email'
            ? TextInputType.emailAddress
            : (key == 'account_number' || key == 'security_code')
            ? TextInputType.number
            : TextInputType.text;
        final icon = key == 'recovery_email'
            ? HeroIcons.envelope
            : key == 'address'
            ? HeroIcons.mapPin
            : key == 'date' || key == 'expiry_date'
            ? HeroIcons.calendar
            : HeroIcons.identification;
        return TextFormField(
          controller: _controllerFor(key),
          keyboardType: type,
          decoration: _decoration(_fieldLabel(key), icon),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _customLeadingIcon(String key, Color color) {
    if (key.startsWith('social:'))
      return FaIcon(
        socialBrandIcon(key.substring(7)) ?? FontAwesomeIcons.globe,
        color: color,
      );
    if (key.startsWith('material:')) {
      final code = int.tryParse(key.substring(9));
      final data = materialIconChoices.values.where((e) => e.codePoint == code);
      return Icon(data.isEmpty ? Icons.tune : data.first, color: color);
    }
    final name = key.startsWith('hero:') ? key.substring(5) : key;
    final icons = HeroIcons.values.where((e) => e.name == name);
    return HeroIcon(
      icons.isEmpty ? HeroIcons.adjustmentsHorizontal : icons.first,
      color: color,
    );
  }

  Widget _customField(Map<String, dynamic> definition) {
    final label = definition['label'] as String? ?? 'Custom field';
    final hint = definition['hint'] as String? ?? '';
    final type = definition['type'] as String? ?? 'text';
    final validation = definition['validation'] as String? ?? 'none';
    final obscure = definition['obscure'] as bool? ?? false;
    final trailing = definition['trailing'] as String? ?? 'none';
    final behaviours = Set<String>.from(
      definition['behaviours'] as List? ?? const [],
    );
    if (trailing != 'none') behaviours.add(trailing);
    if (obscure) behaviours.add('reveal');
    final iconName =
        definition['icon'] as String? ?? 'hero:adjustmentsHorizontal';
    final colorValue = definition['iconColor'] as int? ?? 0xFF64748B;
    final key =
        'custom_${definition['id'] ?? label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}';
    final controller = _controllerFor(key);
    final hidden = customFieldVisibility[key] ?? obscure;
    final keyboard = type == 'email'
        ? TextInputType.emailAddress
        : type == 'phone'
        ? TextInputType.phone
        : type == 'number'
        ? TextInputType.number
        : type == 'url'
        ? TextInputType.url
        : type == 'multiline'
        ? TextInputType.multiline
        : TextInputType.text;
    String? validator(String? value) {
      final text = value ?? '';
      if (validation == 'required' && text.trim().isEmpty)
        return '$label is required';
      if (text.isEmpty || validation == 'none' || validation == 'required')
        return null;
      if (validation == 'email' &&
          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text))
        return 'Enter a valid email';
      if (validation == 'phone' &&
          !RegExp(r'^\+?[0-9 ()-]{6,}$').hasMatch(text))
        return 'Enter a valid phone number';
      if (validation == 'url' && !text.contains('.'))
        return 'Enter a valid website address';
      if (validation == 'numeric' && num.tryParse(text) == null)
        return 'Enter numbers only';
      if (validation == 'min6' && text.length < 6)
        return 'Enter at least 6 characters';
      return null;
    }

    final actions = <Widget>[];
    if (behaviours.contains('reveal')) {
      actions.add(
        IconButton(
          tooltip: hidden ? 'Show value' : 'Hide value',
          onPressed: () => setState(() => customFieldVisibility[key] = !hidden),
          icon: HeroIcon(hidden ? HeroIcons.eye : HeroIcons.eyeSlash),
        ),
      );
    }
    if (behaviours.contains('copy')) {
      actions.add(
        IconButton(
          tooltip: 'Copy value',
          onPressed: controller.text.isEmpty
              ? null
              : () => widget.container.clipboard.copySensitive(controller.text),
          icon: const HeroIcon(HeroIcons.clipboard),
        ),
      );
    }
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      minLines:
          type == 'multiline' && !(obscure || behaviours.contains('reveal'))
          ? 3
          : 1,
      maxLines:
          type == 'multiline' && !(obscure || behaviours.contains('reveal'))
          ? 5
          : 1,
      obscureText: (obscure || behaviours.contains('reveal')) && hidden,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: _customLeadingIcon(iconName, Color(colorValue)),
        ),
        suffixIcon: actions.isEmpty
            ? null
            : Row(mainAxisSize: MainAxisSize.min, children: actions),
      ),
    );
  }

  Widget _buildTagsField() {
    final theme = Theme.of(context);
    return InputDecorator(
      decoration: _decoration('Tags', HeroIcons.tag),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entryTags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: entryTags
                  .map(
                    (tag) => InputChip(
                      label: Text(tag),
                      onDeleted: () => setState(() => entryTags.remove(tag)),
                      visualDensity: VisualDensity.compact,
                      deleteIcon: const HeroIcon(HeroIcons.xMark, size: 16),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: tagInput,
            onChanged: handleTagInput,
            onSubmitted: (v) {
              _addTag(v);
              tagInput.clear();
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: entryTags.isEmpty
                  ? 'Type a tag and enter comma'
                  : 'Add another tag...',
              border: InputBorder.none,
              isDense: true,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pairOrSingle(List<Widget> items, double width) {
    if (items.isEmpty) return const SizedBox.shrink();
    if (items.length == 1) return items.first;
    return _fieldPair(width: width, first: items[0], second: items[1]);
  }

  Widget _fieldPair({
    required double width,
    required Widget first,
    required Widget second,
  }) {
    if (width < 620) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [first, const SizedBox(height: 20), second],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  Future<void> save() async {
    if (busy) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    _addTag(tagInput.text);
    setState(() => busy = true);
    try {
      final availablePlatforms = _platforms;
      if (availablePlatforms.isEmpty) {
        platform = '';
      } else if (!availablePlatforms.contains(platform)) {
        platform = availablePlatforms.first;
      }
      final customValues = <String, String>{};
      for (final item in dynamicControllers.entries) {
        customValues[item.key] = item.value.text;
      }
      customValues['_platform'] = platform;
      await widget.vault.save(
        VaultEntryModel(
          id: widget.entry?.id,
          title: title.text.trim(),
          username: username.text.trim(),
          password: password.text,
          url: url.text.trim(),
          notes: notes.text,
          category: category,
          tags: List<String>.from(entryTags),
          favorite: favorite,
          customFields: customValues,
          locked: widget.entry?.locked ?? false,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save entry: $error')));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.container.settings;
    final selected = _fields;

    // Keep the original form's paired rows: title + account identifier,
    // password + URL, then category + tags. Category-specific fields follow
    // in the same two-column row pattern rather than changing the form design.
    final primaryKey = selected.contains('username')
        ? 'username'
        : selected.contains('email')
        ? 'email'
        : selected.contains('phone')
        ? 'phone'
        : null;
    final primaryField = primaryKey == null ? null : _standardField(primaryKey);

    final coreFields = <Widget>[
      if (selected.contains('password')) _standardField('password'),
      if (selected.contains('url')) _standardField('url'),
    ];

    final extraFields = <Widget>[];
    for (final key in [
      'username',
      'email',
      'phone',
      'account_number',
      'recovery_email',
      'address',
      'date',
      'security_code',
      'license_number',
      'expiry_date',
    ]) {
      if (selected.contains(key) && key != primaryKey)
        extraFields.add(_standardField(key));
    }
    extraFields.addAll(_customFieldDefinitions.map(_customField));

    // If only one of password/URL is selected, pair it with the first extra
    // field where possible, keeping the same side-by-side visual rhythm.
    if (coreFields.length == 1 && extraFields.isNotEmpty) {
      coreFields.add(extraFields.removeAt(0));
    }

    final tagField = selected.contains('tags')
        ? _buildTagsField()
        : const SizedBox.shrink();
    final categoryDropdown = DropdownButtonFormField<String>(
      initialValue: category,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Category / social'),
      items: [
        ...builtInCategoryInfo.keys.map(
          (value) => DropdownMenuItem(
            value: value,
            child: Row(
              children: [
                categoryIcon(value, settings, size: 19),
                const SizedBox(width: 10),
                Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
        ...settings.customCategories.map((item) {
          final value = item['name'] as String;

          return DropdownMenuItem(
            value: value,
            child: Row(
              children: [
                categoryIcon(value, settings, size: 19),
                const SizedBox(width: 10),
                Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
              ],
            ),
          );
        }),
        const DropdownMenuItem(
          value: '__create_category__',
          child: Row(
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(width: 10),
              Text('Create new category...'),
            ],
          ),
        ),
      ],
      onChanged: (value) async {
        if (value == null) return;

        if (value == '__create_category__') {
          await _createCategory();
        } else {
          setState(() {
            category = value;
            platform = _platforms.isNotEmpty ? _platforms.first : '';
          });
        }
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) => Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (primaryField != null)
              _fieldPair(
                width: constraints.maxWidth,
                first: TextFormField(
                  controller: title,
                  decoration: _decoration('Title', HeroIcons.identification),
                ),
                second: primaryField,
              )
            else
              TextFormField(
                controller: title,
                decoration: _decoration('Title', HeroIcons.identification),
              ),
            if (coreFields.isNotEmpty) ...[
              const SizedBox(height: 22),
              _pairOrSingle(coreFields, constraints.maxWidth),
            ],
            const SizedBox(height: 22),
            if (selected.contains('tags'))
              _fieldPair(
                width: constraints.maxWidth,
                first: categoryDropdown,
                second: tagField,
              )
            else
              categoryDropdown,

            if (extraFields.isNotEmpty) ...[
              const SizedBox(height: 22),
              for (var i = 0; i < extraFields.length; i += 2) ...[
                _pairOrSingle(
                  extraFields.skip(i).take(2).toList(),
                  constraints.maxWidth,
                ),
                if (i + 2 < extraFields.length) const SizedBox(height: 22),
              ],
            ],
            if (_platforms.isNotEmpty) ...[
              const SizedBox(height: 22),
              DropdownButtonFormField<String>(
                initialValue: _platforms.contains(platform)
                    ? platform
                    : _platforms.first,
                decoration: _decoration(
                  'Entry type',
                  HeroIcons.devicePhoneMobile,
                ),
                items: _platforms
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => platform = v);
                },
              ),
            ],
            if (selected.contains('notes')) ...[
              const SizedBox(height: 24),
              Text(
                'Secure notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _standardField('notes'),
            ],
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const HeroIcon(HeroIcons.star),
              title: const Text('Favorite'),
              value: favorite,
              onChanged: (value) => setState(() => favorite = value),
            ),
            const SizedBox(height: 14),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.45,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 46),
                  ),
                  onPressed: busy ? null : save,
                  icon: const HeroIcon(HeroIcons.check, color: Colors.white),
                  label: Text(
                    busy ? 'Saving…' : 'Save entry',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
