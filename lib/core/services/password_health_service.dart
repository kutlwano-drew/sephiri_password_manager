import '../../models/vault_entry.dart';

class PasswordHealthReport {
  const PasswordHealthReport({required this.total, required this.weak, required this.reused, required this.score});
  final int total;
  final int weak;
  final int reused;
  final int score;
}

class PasswordHealthService {
  PasswordHealthReport analyze(List<VaultEntryModel> entries) {
    final seen = <String>{};
    var weak = 0;
    var reused = 0;
    for (final e in entries) {
      final p = e.password;
      if (p.length < 12 || _classes(p) < 3) weak++;
      if (!seen.add(p) && p.isNotEmpty) reused++;
    }
    final deductions = weak * 5 + reused * 8;
    return PasswordHealthReport(total: entries.length, weak: weak, reused: reused, score: (100 - deductions).clamp(0, 100));
  }
  int _classes(String value) => (RegExp(r'[a-z]').hasMatch(value) ? 1 : 0) + (RegExp(r'[A-Z]').hasMatch(value) ? 1 : 0) + (RegExp(r'[0-9]').hasMatch(value) ? 1 : 0) + (RegExp(r'[^A-Za-z0-9]').hasMatch(value) ? 1 : 0);
}
