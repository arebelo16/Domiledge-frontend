import 'package:flutter/material.dart';

import '../../account/controllers/account_controller.dart';
import '../../account/model/user_profile.dart';
import '../../account/model/active_session.dart';
import '../../../wrappers/main_scaffold.dart';

import '../widgets/header.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/security_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/billing_card.dart';
import '../widgets/sessions_card.dart';
import '../widgets/data_privacy_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _c = AccountController();
  UserProfile? _p;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _error = null; _p = null; });
    try {
      final p = await _c.fetchProfile();
      if (!mounted) return;
      setState(() => _p = p);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Perfil',
      selectedIndex: 2,
      body: RefreshIndicator(
        onRefresh: _load,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text('Falha ao carregar o perfil.\n$_error', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_p == null) return const Center(child: CircularProgressIndicator());

    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 1000;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            ProfileHeader(p: _p!),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20, runSpacing: 20,
              children: [
                _box(isWide, c.maxWidth, PersonalInfoCard(
                  profile: _p!, saving: _busy,
                  onSave: (np) async {
                    setState(() => _busy = true);
                    try {
                      final saved = await _c.updateProfile(np);
                      if (!mounted) return;
                      setState(() => _p = saved);
                      _snack('Perfil atualizado.');
                    } catch (e) {
                      _snack('Erro: $e');
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                )),
                _box(isWide, c.maxWidth, SecurityCard(
                  twoFA: _p!.twoFactorEnabled,
                  onToggle2FA: (v) async {
                    setState(() => _busy = true);
                    try {
                      await _c.toggle2FA(v);
                      if (!mounted) return;
                      setState(() => _p = _p!.copyWith(twoFactorEnabled: v));
                      _snack(v ? '2FA ativado' : '2FA desativado');
                    } catch (e) {
                      _snack('Erro: $e');
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                  onChangePassword: (curr, next) async {
                    setState(() => _busy = true);
                    try {
                      await _c.changePassword(current: curr, next: next);
                      _snack('Password alterada.');
                    } catch (e) {
                      _snack('Erro: $e');
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                )),
                _box(isWide, c.maxWidth, PreferencesCard(
                  themeMode: _p!.themeMode,
                  email: _p!.notifyEmail,
                  push: _p!.notifyPush,
                  saving: _busy,
                  onSave: (theme, em, ps) async {
                    setState(() => _busy = true);
                    try {
                      final saved = await _c.updateProfile(
                        _p!.copyWith(themeMode: theme, notifyEmail: em, notifyPush: ps),
                      );
                      if (!mounted) return;
                      setState(() => _p = saved);
                      _snack('Preferências guardadas.');
                    } catch (e) {
                      _snack('Erro: $e');
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                )),
                _box(isWide, c.maxWidth, BillingCard(
                  plan: _p!.plan, vat: _p!.vatNumber, company: _p!.companyName,
                  saving: _busy,
                  onSave: (vat, company) async {
                    setState(() => _busy = true);
                    try {
                      final saved = await _c.updateProfile(
                        _p!.copyWith(vatNumber: vat, companyName: company),
                      );
                      if (!mounted) return;
                      setState(() => _p = saved);
                      _snack('Faturação atualizada.');
                    } catch (e) {
                      _snack('Erro: $e');
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
                )),
                _box(isWide, c.maxWidth, SessionsCard(
                  loader: _c.fetchSessions,
                  onRevoke: (ActiveSession s) async {
                    try {
                      await _c.revokeSession(s);
                      _snack('Sessão revogada.');
                    } catch (e) {
                      _snack('Erro: $e');
                    }
                  },
                )),
                _box(isWide, c.maxWidth, DataPrivacyCard(
                  onExport: () async {
                    try { await _c.exportData(); _snack('Enviámos o export por email.'); }
                    catch (e) { _snack('Erro: $e'); }
                  },
                  onDelete: () async {
                    try { await _c.deleteAccount(); _snack('Conta marcada para eliminação.'); }
                    catch (e) { _snack('Erro: $e'); }
                  },
                )),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _box(bool isWide, double maxW, Widget child) =>
      SizedBox(width: isWide ? (maxW - 20) * .48 : maxW, child: child);
}
