import 'package:flutter/material.dart';

import '../../../shared/widgets/notify.dart';
import '../../../shared/widgets/text_fields.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String? initialEmail;

  /// Se true, tenta /auth/account-exists antes de pedir o reset
  final bool enableExistenceCheck;

  const ForgotPasswordDialog({
    super.key,
    this.initialEmail,
    this.enableExistenceCheck = true,
  });

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _auth = AuthController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailC.text = widget.initialEmail?.trim() ?? '';
  }

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final email = _emailC.text.trim();

    if (widget.enableExistenceCheck) {
      final ex = await _auth.accountExists(email);
      if (!mounted) return;
      final exists = ex.when(success: (v) => v, failure: (_) => false);
      if (!exists) {
        setState(() => _loading = false);
        Notify.show(
          context,
          'Não existe nenhuma conta com esse e-mail.',
          title: 'Conta não encontrada',
          type: NotifyType.error,
        );
        return;
      }
    }

    // 2) pedir reset (202)
    final res = await _auth.requestPasswordReset(email);
    if (!mounted) return;
    setState(() => _loading = false);

    res.when(
      success: (_) {
        Navigator.of(context).pop(); // fecha popup
        Notify.show(
          context,
          'Se existir uma conta associada, vais receber um e-mail com instruções.',
          title: 'Pedido enviado',
          type: NotifyType.success,
        );
      },
      failure: (msg) {
        Notify.show(context, msg, title: 'Erro', type: NotifyType.error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Recuperar password'),
      content: Form(
        key: _form,
        child: SizedBox(
          width: 380,
          child: CustomTextField(
            controller: _emailC,
            label: 'E-mail',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            validator: (v) {
              final s = (v ?? '').trim();
              if (s.isEmpty) return 'Indica o teu e-mail';
              if (!s.contains('@')) return 'E-mail inválido';
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.mail_outline),
          onPressed: _loading ? null : _submit,
          label: const Text('Recuperar'),
        ),
      ],
    );
  }
}
