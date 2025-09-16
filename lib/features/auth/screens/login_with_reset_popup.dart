import 'package:flutter/material.dart';

import '../widgets/reset_password_dialog.dart';
import 'login_page.dart';

class LoginWithResetPopup extends StatefulWidget {
  final String? rid;
  final String? token;

  const LoginWithResetPopup({super.key, this.rid, this.token});

  @override
  State<LoginWithResetPopup> createState() => _LoginWithResetPopupState();
}

class _LoginWithResetPopupState extends State<LoginWithResetPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rid = widget.rid?.trim();
      final token = widget.token?.trim();
      if (rid != null && token != null && rid.isNotEmpty && token.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ResetPasswordDialog(rid: rid, token: token),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => const LoginPage();
}
