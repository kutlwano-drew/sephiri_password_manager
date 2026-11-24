
import 'package:flutter/material.dart';
import '../../core/services/app_container.dart';
import 'widgets/setup_form.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key, required this.container});
  final AppContainer container;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width < 700 ? size.width * .92 : size.width * .50;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: width.clamp(320.0, 620.0),
            height: (size.height * .50).clamp(420.0, 700.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 28),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: (size.height * .50).clamp(420.0, 700.0) - 56),
                    child: SetupForm(container: container),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
