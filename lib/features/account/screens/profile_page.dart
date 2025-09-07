import 'package:flutter/material.dart';
import '../../account/controllers/account_controller.dart';
import '../../account/model/user_profile.dart';
import '../../../wrappers/main_scaffold.dart';

import '../widgets/header_card.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/security_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/billing_card.dart';
import '../widgets/sessions_card.dart';
import '../widgets/data_privacy_card.dart';
import '../widgets/properties_overview_card.dart';

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
    final p = await _c.fetchProfile();
    if (!mounted) return;
    setState(() => _p = p);
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

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
                          final saved = await _c.updateProfile(np);
                          setState(() => _p = saved);
                          _snack('Perfil atualizado.');
                        },
                      ),
                      const SizedBox(height: gutter),
                      PreferencesCard(
                        themeMode: _p!.themeMode,
                        email: _p!.notifyEmail,
                        push: _p!.notifyPush,
                        onSave: (t, e, p) async {
                          final saved = await _c.updateProfile(
                            _p!.copyWith(
                              themeMode: t,
                              notifyEmail: e,
                              notifyPush: p,
                            ),
                          );
                          setState(() => _p = saved);
                          _snack('Preferências guardadas.');
                        },
                      ),
                      const SizedBox(height: gutter),
                      SecurityCard(
                        is2FAEnabled: _p!.twoFactorEnabled,
                        onToggle2FA: (v) async {
                          await _c.toggle2FA(v);
                          setState(
                            () => _p = _p!.copyWith(twoFactorEnabled: v),
                          );
                        },
                        onChangePassword: (curr, next) async {
                          await _c.changePassword(current: curr, next: next);
                          _snack('Password alterada.');
                        },
                      ),
                    ],
                  );

                  Widget rightColumn() => Column(
                    children: [
                      PropertiesOverviewCard(limit: 5, dense: true),
                      const SizedBox(height: gutter),
                      SessionsCard(
                        loader: _c.fetchSessions,
                        revoke: _c.revokeSession,
                        dense: true,
                      ),
                      const SizedBox(height: gutter),
                      BillingCard(
                        plan: _p!.plan,
                        vat: _p!.vatNumber,
                        company: _p!.companyName,
                        onSave: (vat, comp) async {
                          final saved = await _c.updateProfile(
                            _p!.copyWith(vatNumber: vat, companyName: comp),
                          );
                          setState(() => _p = saved);
                          _snack('Faturação atualizada.');
                        },
                        dense: true,
                      ),
                      const SizedBox(height: gutter),
                      DataPrivacyCard(
                        onExport: _c.exportData,
                        onDelete: _c.deleteAccount,
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
