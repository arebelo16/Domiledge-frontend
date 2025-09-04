// lib/features/auth/screens/register_page.dart
import 'package:domiledge_frontend/core/validators/auth_validators.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/text_fields.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await _authController.register(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
      _emailController.text.trim(),
    );
    if (result.isSuccess && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm your email')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.error ?? 'Unknown error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _emailController,
                  validator: AuthValidators.validateEmail,
                  label: 'Email',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  validator: AuthValidators.validatePassword,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                CustomButton(text: 'Register', onPressed: _register),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
