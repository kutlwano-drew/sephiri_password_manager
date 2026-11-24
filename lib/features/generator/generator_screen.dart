import 'package:flutter/material.dart';
import '../../core/services/app_container.dart';
import '../../widgets/layout/app_scaffold.dart';
import 'widgets/generator_panel.dart';

class GeneratorScreen extends StatelessWidget { const GeneratorScreen({super.key, required this.container}); final AppContainer container; @override Widget build(BuildContext context)=>AppScaffold(title:'Password generator',body:Padding(padding:const EdgeInsets.all(16),child:GeneratorPanel(container:container))); }
