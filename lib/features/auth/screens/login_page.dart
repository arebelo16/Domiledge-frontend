import 'dart:async';

import 'package:domiledge_frontend/core/validators/auth_validators.dart';
import 'package:domiledge_frontend/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Web modern interop (substitui dart:html)
import 'package:web/web.dart' as web;

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/notify.dart';
import '../../../shared/widgets/text_fields.dart';
import '../controllers/auth_controller.dart';
import '../widgets/forgot_password_dialog.dart';

class LoginPage extends StatefulWidget {
  final Map<String, String>? queryParams;

  const LoginPage({super.key, this.queryParams});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _ctrl = const AuthController();

  bool _loading = false;
  bool _obscure = true;

  // evita processar a query mais que uma vez
  bool _handledQuery = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _handleQueryParamsOnce(),
    );
  }

  @override
  void dispose() {
    _email
      ..clear()
      ..dispose();
    _password
      ..clear()
      ..dispose();
    super.dispose();
  }

  // ====== Confirm / ConfirmError (suporta confirmed ou confirm) ======
  void _handleQueryParamsOnce() {
    if (_handledQuery) return;
    _handledQuery = true;

    final qp = widget.queryParams ?? {};
    final confirm = qp['confirmed'] ?? qp['confirm'];
    final confirmError = qp['confirmError'];

    if (confirm == '1') {
      Notify.show(
        context,
        'Conta confirmada!',
        title: 'Sucesso',
        type: NotifyType.success,
      );
    } else if (confirmError != null) {
      Notify.show(
        context,
        'Link inválido/expirado!',
        title: 'Erro',
        type: NotifyType.error,
      );
    }
  }

  void _stripQueryFromUrl() {
    if (!kIsWeb) return;
    final uri = Uri.base;
    final clean = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: uri.path,
    ).toString();
    // package:web
    web.window.history.replaceState(null, '', clean);
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final result = await _ctrl.login(_email.text.trim(), _password.text);

    setState(() => _loading = false);

    if (!mounted) return;

    if (result.isSuccess && result.data == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Notify.show(
        context,
        result.error ?? 'Confirma o username/email e password!',
        title: 'Credenciais inválidas!',
        type: NotifyType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/login_bg.webp', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.48)),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.dividerColor.withOpacity(.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 26,
                  ),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Column(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: theme.colorScheme.primary.withOpacity(
                                    .08,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.key_rounded,
                                  size: 26,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Domiledge',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Entra na tua conta',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(.7),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Email / Username
                          CustomTextField(
                            controller: _email,
                            label: 'Username ou Email',
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            validator: AuthValidators.usernameOrEmail,
                          ),
                          const SizedBox(height: 14),

                          // Password
                          CustomTextField(
                            controller: _password,
                            label: 'Password',
                            obscureText: _obscure,
                            autofillHints: const [AutofillHints.password],
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            validator: AuthValidators.password,
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                final u = _email.text.trim();
                                final p = _password.text.trim();
                                final init = u.contains('@')
                                    ? u
                                    : (p.contains('@') ? p : null);

                                showDialog(
                                  context: context,
                                  builder: (_) => ForgotPasswordDialog(
                                    initialEmail: init,
                                    enableExistenceCheck: true,
                                  ),
                                );
                              },
                              child: const Text('Esqueceste-te da password?'),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Botão de login
                          CustomButton(
                            onPressed: _loading ? null : _doLogin,
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Entrar'),
                          ),

                          const SizedBox(height: 12),

                          // Registo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Ainda não tens conta?'),
                              TextButton(
                                // onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                                onPressed: () {
                                  Notify.show(
                                    context,
                                    'Registro não está disponível de momento.',
                                    title: 'Registro Indisponivel!',
                                    type: NotifyType.error,
                                  );
                                },
                                child: const Text('Criar conta'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
