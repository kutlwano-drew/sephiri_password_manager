import 'dart:math';

class PasswordGeneratorService {
  final Random _random = Random.secure();

  String password({int length = 20, bool upper = true, bool lower = true, bool numbers = true, bool symbols = true}) {
    var alphabet = '';
    if (upper) alphabet += 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    if (lower) alphabet += 'abcdefghijkmnopqrstuvwxyz';
    if (numbers) alphabet += '23456789';
    if (symbols) alphabet += '!@#%^&*()-_=+[]{}?';
    if (alphabet.isEmpty) throw StateError('Select at least one character set.');
    return List.generate(length, (_) => alphabet[_random.nextInt(alphabet.length)]).join();
  }

  String passphrase({int words = 4}) {
    const list = ['amber','anchor','apple','atlas','beacon','breeze','canyon','cedar','cloud','comet','crystal','delta','ember','falcon','forest','harbor','island','jungle','lantern','maple','meadow','mercury','moon','ocean','orchid','planet','river','rocket','silver','summit','thunder','valley','violet','willow','winter'];
    return List.generate(words, (_) => list[_random.nextInt(list.length)]).join('-');
  }
}
