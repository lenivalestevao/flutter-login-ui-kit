import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_widgets.dart';
import 'reset_password_screen.dart';

/// Six-digit verification code screen.
/// One invisible text field receives the input (so paste and autofill work)
/// while six boxes display the digits.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  static const route = '/verify-code';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 6;
  static const _resendSeconds = 30;

  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _seconds = _resendSeconds;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _beginTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Starts the resend countdown from the current value of [_seconds].
  void _beginTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _seconds = _seconds > 0 ? _seconds - 1 : 0);
      if (_seconds == 0) timer.cancel();
    });
  }

  void _resend() {
    // TODO: ask your backend to send a new code.
    _code.clear();
    setState(() => _seconds = _resendSeconds);
    _beginTimer();
    showAuthSnack(context, 'A new code has been sent');
  }

  Future<void> _verify() async {
    if (_code.text.length != _length || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    // TODO: verify the code with your backend. This demo accepts any 6 digits.
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushNamed(context, ResetPasswordScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final email = (ModalRoute.of(context)?.settings.arguments as String?) ??
        'your email';
    final code = _code.text;
    final activeIndex = code.length < _length ? code.length : _length - 1;

    return AuthScaffold(
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeader(
            icon: Icons.mark_email_read_outlined,
            title: 'Check your email',
            subtitle: 'We sent a 6-digit code to $email. Enter it below.',
          ),
          Stack(
            children: [
              Row(
                children: List.generate(_length, (i) {
                  return _OtpBox(
                    char: i < code.length ? code[i] : '',
                    active: _focus.hasFocus && i == activeIndex,
                  );
                }),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _code,
                    focusNode: _focus,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_length),
                    ],
                    onChanged: (value) {
                      setState(() {});
                      if (value.length == _length) _verify();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Verify code',
            loading: _loading,
            onPressed: code.length == _length ? _verify : null,
          ),
          const SizedBox(height: 16),
          Center(
            child: _seconds > 0
                ? Text(
                    'Resend code in 0:${_seconds.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                  )
                : TextButton(
                    onPressed: _resend,
                    child: const Text('Resend code'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.char, required this.active});

  final String char;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = theme.inputDecorationTheme.fillColor ?? Colors.grey.shade200;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          char,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
