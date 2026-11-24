
import 'package:flutter/material.dart';
import '../../core/services/app_container.dart';
import 'widgets/unlock_form.dart';

class UnlockScreen extends StatelessWidget {
  const UnlockScreen({super.key, required this.container});
  final AppContainer container;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardWidth = size.width < 700 ? size.width * .92 : size.width * .50;
    final cardHeight = size.height * .50;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: cardWidth.clamp(320.0, 620.0),
            height: cardHeight,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 28),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: (cardHeight - 56).clamp(120.0, double.infinity)),
                    child: UnlockForm(container: container),
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
