import 'package:flutter/material.dart';

import '../utils/validators.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const route = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    // TODO: replace this fake delay with your real sign-in request.
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _loading = false);
    showAuthSnack(context, 'Signed in as ${_email.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              icon: Icons.lock_outline_rounded,
              title: 'Welcome back',
              subtitle: 'Sign in to continue to your account.',
            ),
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
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              onSubmitted: (_) => _submit(),
              autofillHints: const [AutofillHints.password],
              enabled: !_loading,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _remember = !_remember),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          onChanged: (v) =>
                              setState(() => _remember = v ?? false),
                        ),
                        Flexible(
                          child: Text('Remember me',
                              style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.pushNamed(
                          context, ForgotPasswordScreen.route),
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Sign in',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 28),
            const OrDivider(text: 'or continue with'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SocialButton(
                    label: 'Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () =>
                        showAuthSnack(context, 'Connect Google sign-in here'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SocialButton(
                    label: 'Apple',
                    icon: Icons.apple,
                    onPressed: () =>
                        showAuthSnack(context, 'Connect Apple sign-in here'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Don't have an account?",
                    style: theme.textTheme.bodyMedium?.copyWith(color: muted)),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.pushNamed(context, RegisterScreen.route),
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
