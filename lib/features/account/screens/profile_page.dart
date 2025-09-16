import 'package:flutter/material.dart';

import '../../../shared/widgets/notify.dart';
import '../../../wrappers/main_scaffold.dart';
import '../../account/controllers/account_controller.dart';
import '../../account/model/active_session.dart';
import '../../account/model/user_profile.dart';
import '../widgets/billing_card.dart';
import '../widgets/data_privacy_card.dart';
import '../widgets/header_card.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/properties_overview_card.dart';
import '../widgets/security_card.dart';
import '../widgets/sessions_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AccountController _c;
  UserProfile? _p;

  @override
  void initState() {
    super.initState();
    _c = AccountController();
    _load();
  }

  Future<void> _load() async {
    final res = await _c.fetchProfileResult();
    if (!mounted) return;
    res.when(
      success: (p) => setState(() => _p = p),
      failure: (msg) {
        _notifyError(msg);
        if (_isUnauthenticated(msg)) _goToLogin();
      },
    );
  }

  bool _isUnauthenticated(String msg) =>
      msg == 'Não autenticado' || msg.toLowerCase().contains('não autenticado');

  void _goToLogin() =>
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);

  void _notifySuccess(String m, {String? title}) => Notify.show(
    context,
    m,
    title: title ?? 'Sucesso',
    type: NotifyType.success,
  );

  void _notifyError(String m, {String? title}) =>
      Notify.show(context, m, title: title ?? 'Erro', type: NotifyType.error);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Perfil',
      selectedIndex: 2,
      body: _p == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: LayoutBuilder(
                builder: (context, c) {
                  final isDesktop = c.maxWidth >= 992;
                  const gutter = 24.0;

                  Widget leftColumn() => Column(
                    children: [
                      PersonalInfoCard(
                        profile: _p!,
                        onSaved: (np) async {
                          final res = await _c.updateProfileResult(np);
                          if (!mounted) return;
                          res.when(
                            success: (saved) {
                              setState(() => _p = saved);
                              _notifySuccess(
                                'Perfil atualizado com sucesso!',
                                title: 'Perfil atualizado.',
                              );
                            },
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha ao atualizar perfil.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: gutter),
                      PreferencesCard(
                        themeMode: _p!.themeMode,
                        email: _p!.notifyEmail,
                        push: _p!.notifyPush,
                        onSave: (t, e, p) async {
                          if (!mounted) return;
                          final res = await _c.updateProfileResult(
                            _p!.copyWith(
                              themeMode: t,
                              notifyEmail: e,
                              notifyPush: p,
                            ),
                          );
                          if (!mounted) return;
                          res.when(
                            success: (saved) {
                              setState(() => _p = saved);
                              _notifySuccess(
                                'Preferências guardadas com sucesso!',
                                title: 'Preferências guardadas.',
                              );
                            },
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha ao guardar preferências.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                      ),
                      const SizedBox(height: gutter),
                      SecurityCard(
                        is2FAEnabled: _p!.twoFactorEnabled,
                        onToggle2FA: (v) async {
                          final res = await _c.toggle2FAResult(v);
                          if (!mounted) return;
                          res.when(
                            success: (_) {
                              setState(
                                () => _p = _p!.copyWith(twoFactorEnabled: v),
                              );
                              _notifySuccess(
                                v ? '2FA ativado.' : '2FA desativado.',
                                title: 'Segurança',
                              );
                            },
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha ao alternar 2FA.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                        onChangePassword: (curr, next) async {
                          if (!mounted) return;
                          final res = await _c.changePasswordResult(
                            current: curr,
                            next: next,
                          );
                          if (!mounted) return;
                          res.when(
                            success: (_) => _notifySuccess(
                              'Password alterada com sucesso!',
                              title: 'Password alterada.',
                            ),
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a alterar password.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                      ),
                    ],
                  );

                  Widget rightColumn() => Column(
                    children: [
                      PropertiesOverviewCard(limit: 5, dense: true),
                      const SizedBox(height: gutter),
                      SessionsCard(
                        // Mantemos a API antiga do widget e tratamos Result aqui
                        loader: () async {
                          final res = await _c.fetchSessionsResult();
                          if (!mounted) return const <ActiveSession>[];
                          return res.when(
                            success: (list) => list,
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a obter sessões.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                              return const <ActiveSession>[];
                            },
                          );
                        },
                        revoke: (s) async {
                          final res = await _c.revokeSessionResult(s);
                          if (!mounted) return;
                          res.when(
                            success: (_) {
                              // Nota: se for a própria sessão, o SessionsCard chama onSelfRevoked
                              _notifySuccess(
                                'Sessão revogada.',
                                title: 'Sessão',
                              );
                            },
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a revogar sessão.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                        onSelfRevoked: () {
                          if (!mounted) return;
                          _notifySuccess(
                            'Sessão atual revogada. Inicia sessão novamente.',
                            title: 'Sessão revogada.',
                          );
                          _goToLogin();
                        },
                        onUnauthenticated: () {
                          if (!mounted) return;
                          _goToLogin();
                        },
                        dense: true,
                      ),
                      const SizedBox(height: gutter),
                      BillingCard(
                        plan: _p!.plan,
                        vat: _p!.vatNumber,
                        company: _p!.companyName,
                        onSave: (vat, comp) async {
                          if (!mounted) return;
                          final res = await _c.updateProfileResult(
                            _p!.copyWith(vatNumber: vat, companyName: comp),
                          );
                          if (!mounted) return;
                          res.when(
                            success: (saved) {
                              setState(() => _p = saved);
                              _notifySuccess(
                                'Faturação atualizada com sucesso!',
                                title: 'Faturação atualizada.',
                              );
                            },
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a atualizar faturação.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                        dense: true,
                      ),
                      const SizedBox(height: gutter),
                      DataPrivacyCard(
                        onExport: () async {
                          final res = await _c.exportDataResult();
                          if (!mounted) return;
                          res.when(
                            success: (_) => _notifySuccess(
                              'Exportação iniciada.',
                              title: 'Privacidade',
                            ),
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a exportar dados.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                        onDelete: () async {
                          final res = await _c.deleteAccountResult();
                          if (!mounted) return;
                          res.when(
                            success: (_) => _notifySuccess(
                              'Pedido de eliminação enviado.',
                              title: 'Conta',
                            ),
                            failure: (msg) {
                              _notifyError(
                                msg,
                                title: 'Falha a eliminar conta.',
                              );
                              if (_isUnauthenticated(msg)) _goToLogin();
                            },
                          );
                        },
                      ),
                    ],
                  );

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1400),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            gutter,
                            20,
                            gutter,
                            32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              HeaderCard(profile: _p!),
                              const SizedBox(height: gutter),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: leftColumn()),
                                    const SizedBox(width: gutter),
                                    Expanded(child: rightColumn()),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    leftColumn(),
                                    const SizedBox(height: gutter),
                                    rightColumn(),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
