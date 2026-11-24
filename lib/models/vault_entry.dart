class VaultEntryModel {
  const VaultEntryModel({
    this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url = '',
    this.notes = '',
    this.category = 'Login',
    this.tags = const [],
    this.favorite = false,
    this.customFields = const {},
    this.locked = false,
  });

  final String? id;
  final String title;
  final String username;
  final String password;
  final String url;
  final String notes;
  final String category;
  final List<String> tags;
  final bool favorite;
  final Map<String, String> customFields;
  final bool locked;

  VaultEntryModel copyWith({bool? locked}) => VaultEntryModel(
    id: id,
    title: title,
    username: username,
    password: password,
    url: url,
    notes: notes,
    category: category,
    tags: tags,
    favorite: favorite,
    customFields: customFields,
    locked: locked ?? this.locked,
  );
}
