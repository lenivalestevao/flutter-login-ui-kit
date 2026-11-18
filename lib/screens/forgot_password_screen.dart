import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../widgets/auth_widgets.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const route = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    // TODO: ask your backend to email a 6-digit reset code to this address.
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushNamed(context, OtpScreen.route, arguments: _email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              icon: Icons.lock_reset_rounded,
              title: 'Forgot password?',
              subtitle:
                  "No worries. Enter your email and we'll send you a code to reset it.",
            ),
            AuthTextField(
              controller: _email,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              onSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.email],
              enabled: !_loading,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Send reset code',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _loading ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back to sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
