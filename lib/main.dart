import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/services/app_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await AppContainer.create();
  runApp(SephiriPasswordManager(container: container));
}
