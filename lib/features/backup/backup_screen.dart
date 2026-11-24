import 'package:flutter/material.dart';
import '../../core/services/app_container.dart';
import '../../widgets/layout/app_scaffold.dart';
import 'widgets/backup_panel.dart';

class BackupScreen extends StatelessWidget { const BackupScreen({super.key,required this.container}); final AppContainer container; @override Widget build(BuildContext context)=>AppScaffold(title:'Backup & restore',body:Padding(padding:const EdgeInsets.all(16),child:BackupPanel(container:container))); }
