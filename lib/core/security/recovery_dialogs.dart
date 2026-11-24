import 'package:flutter/material.dart';
import 'session_manager.dart';

ButtonStyle _cancelStyle() => TextButton.styleFrom(
  backgroundColor: Colors.black.withValues(alpha: .7),
  foregroundColor: Colors.red,
);
ButtonStyle _acceptStyle() => FilledButton.styleFrom(
  backgroundColor: Colors.black.withValues(alpha: .7),
  foregroundColor: Colors.green,
);

Future<bool> showRecoveryQuestionSetupDialog(
  BuildContext context,
  SessionManager session, {
  bool allowCancel = true,
}) async {
  final question = TextEditingController();
  final answer = TextEditingController();
  final confirmAnswer = TextEditingController();
  var busy = false;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: allowCancel,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialog) => AlertDialog(
        title: const Text('Set your recovery question'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Write a question only you can answer. You will select this question and enter its answer if you need to reset your master password.'),
              const SizedBox(height: 14),
              TextField(controller: question, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(labelText: 'Your question', hintText: 'e.g. What was the name of my first teacher?')),
              const SizedBox(height: 12),
              TextField(controller: answer, obscureText: true, decoration: const InputDecoration(labelText: 'Your answer', helperText: 'Use an answer you can remember. It is stored encrypted.')),
              const SizedBox(height: 12),
              TextField(controller: confirmAnswer, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm answer')), 
            ],
          ),
        ),
        actions: [
          if (allowCancel) TextButton(style: _cancelStyle(), onPressed: busy ? null : () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            style: _acceptStyle(),
            onPressed: busy ? null : () async {
              if (question.text.trim().isEmpty || answer.text.trim().length < 3 || answer.text != confirmAnswer.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a question, an answer of at least 3 characters, and matching answers.')));
                return;
              }
              setDialog(() => busy = true);
              try {
                await session.configureRecoveryQuestion(question.text, answer.text);
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (dialogContext.mounted) {
                  setDialog(() => busy = false);
                  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Could not save recovery question: $error')));
                }
              }
            },
            child: Text(busy ? 'Saving…' : 'Save recovery question'),
          ),
        ],
      ),
    ),
  );
  question.dispose();
  answer.dispose();
  confirmAnswer.dispose();
  return result == true;
}

Future<bool> showMasterPasswordRecoveryDialog(
  BuildContext context,
  SessionManager session,
) async {
  final question = session.recoveryQuestion;
  if (question == null || question.isEmpty) {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recovery is not configured'),
        content: const Text('No recovery question has been saved for this vault. If you are still signed in on another session, configure one in Settings.'),
        actions: [TextButton(style: _cancelStyle(), onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
    return false;
  }

  final answer = TextEditingController();
  final newPassword = TextEditingController();
  final confirm = TextEditingController();
  var busy = false;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialog) => AlertDialog(
        title: const Text('Recover your vault'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Select your saved recovery question and enter the answer you created.'),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: question,
                decoration: const InputDecoration(labelText: 'Recovery question'),
                items: [DropdownMenuItem(value: question, child: Text(question, maxLines: 3, overflow: TextOverflow.ellipsis))],
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              TextField(controller: answer, autofocus: true, obscureText: true, decoration: const InputDecoration(labelText: 'Answer')),
              const SizedBox(height: 12),
              TextField(controller: newPassword, obscureText: true, decoration: const InputDecoration(labelText: 'New master password')),
              const SizedBox(height: 12),
              TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm new master password')),
            ]),
          ),
        ),
        actions: [
          TextButton(style: _cancelStyle(), onPressed: busy ? null : () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            style: _acceptStyle(),
            onPressed: busy ? null : () async {
              if (newPassword.text != confirm.text) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('The new passwords do not match.')));
                return;
              }
              setDialog(() => busy = true);
              try {
                await session.resetMasterPasswordWithRecovery(question: question, answer: answer.text, newPassword: newPassword.text);
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (dialogContext.mounted) {
                  setDialog(() => busy = false);
                  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))));
                }
              }
            },
            child: Text(busy ? 'Recovering…' : 'Reset password'),
          ),
        ],
      ),
    ),
  );
  answer.dispose();
  newPassword.dispose();
  confirm.dispose();
  return result == true;
}
