import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../widgets/auth_widgets.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const route = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _done = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    // TODO: send the new password (and the verified code/token) to your backend.
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() {
      _loading = false;
      _done = true;
    });
  }

  Widget _buildForm() {
    return KeyedSubtree(
      key: const ValueKey('form'),
      child: Form(
        key: _formKey,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            icon: Icons.password_rounded,
            title: 'Set a new password',
            subtitle: 'Your new password must be different from the previous one.',
          ),
          AuthTextField(
            controller: _password,
            label: 'New password',
            hint: 'Create a new password',
            icon: Icons.lock_outline_rounded,
            obscure: true,
            textInputAction: TextInputAction.next,
            validator: Validators.password,
            onChanged: (_) => setState(() {}),
            autofillHints: const [AutofillHints.newPassword],
            enabled: !_loading,
          ),
          const SizedBox(height: 10),
          PasswordStrengthMeter(password: _password.text),
          const SizedBox(height: 18),
          AuthTextField(
            controller: _confirm,
            label: 'Confirm password',
            hint: 'Repeat your new password',
            icon: Icons.lock_reset_rounded,
            obscure: true,
            textInputAction: TextInputAction.done,
            validator: _confirmValidator,
            onSubmitted: (_) => _submit(),
            enabled: !_loading,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Reset password',
            loading: _loading,
            onPressed: _submit,
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: const ValueKey('done'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tint(Colors.green, .15),
            ),
            child: const Icon(Icons.check_rounded, color: Colors.green, size: 48),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Password updated',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -.5),
        ),
        const SizedBox(height: 10),
        Text(
          'Your password has been reset. You can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Back to sign in',
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.route,
            (route) => false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: !_done,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _done ? _buildSuccess(context) : _buildForm(),
      ),
    );
  }
}
