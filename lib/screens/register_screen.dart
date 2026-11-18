import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const route = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _accepted = false;
  bool _termsError = false;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
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
    setState(() => _termsError = !_accepted);
    final valid = _formKey.currentState!.validate();
    if (!valid || !_accepted) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    // TODO: replace this fake delay with your real sign-up request.
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _loading = false);
    showAuthSnack(context, 'Account created! You can sign in now.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return AuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Create account',
              subtitle: 'Join us in a few seconds. No credit card needed.',
            ),
            AuthTextField(
              controller: _name,
              label: 'Full name',
              hint: 'Jane Doe',
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
              autofillHints: const [AutofillHints.name],
              enabled: !_loading,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _email,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              autofillHints: const [AutofillHints.email],
              enabled: !_loading,
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _password,
              label: 'Password',
              hint: 'Create a password',
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
              hint: 'Repeat your password',
              icon: Icons.lock_reset_rounded,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: _confirmValidator,
              onSubmitted: (_) => _submit(),
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() {
                _accepted = !_accepted;
                _termsError = false;
              }),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _accepted,
                    onChanged: (v) => setState(() {
                      _accepted = v ?? false;
                      _termsError = false;
                    }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: muted),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_termsError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 2),
                child: Text(
                  'Please accept the terms to continue',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Create account',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Already have an account?',
                    style: theme.textTheme.bodyMedium?.copyWith(color: muted)),
                TextButton(
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
