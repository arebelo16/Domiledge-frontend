import 'package:flutter/material.dart';

import '../../../shared/widgets/notify.dart';
import '../../../shared/widgets/text_fields.dart' show CustomTextField;
import '../controllers/auth_controller.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String rid;
  final String token;

  const ResetPasswordDialog({
    super.key,
    required this.rid,
    required this.token,
  });

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _pwdC = TextEditingController();
  final _pwd2C = TextEditingController();
  final _auth = const AuthController();

  bool _loading = true; // validar link
  bool _valid = false;
  bool _submitting = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _validate();
  }

  @override
  void dispose() {
    _pwdC.dispose();
    _pwd2C.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    final res = await _auth.validateReset(widget.rid, widget.token);
    if (!mounted) return;
    res.when(success: (_) => _valid = true, failure: (_) => _valid = false);
    setState(() => _loading = false);
    if (!_valid) {
      Notify.show(
        context,
        'Link inválido ou expirado.',
        title: 'Recuperar password',
        type: NotifyType.error,
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    final res = await _auth.resetPassword(
      rid: widget.rid,
      token: widget.token,
      newPassword: _pwdC.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    res.when(
      success: (_) {
        Navigator.of(context).pop(); // fecha popup
        Notify.show(
          context,
          'Password alterada com sucesso!',
          title: 'Sucesso',
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
      content: _loading
          ? const SizedBox(
              width: 380,
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _form,
              child: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: _pwdC,
                      label: 'Nova password',
                      obscureText: _obscure,
                      textInputAction: TextInputAction.next,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.length < 8) return 'Mínimo 8 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _pwd2C,
                      label: 'Confirmar nova password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => ((v ?? '').trim() != _pwdC.text.trim())
                          ? 'As passwords não coincidem'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
      actions: _loading
          ? null
          : [
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Alterar password'),
              ),
            ],
    );
  }
}
