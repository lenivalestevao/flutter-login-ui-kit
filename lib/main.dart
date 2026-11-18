import 'package:flutter/material.dart';

import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const LoginUiKitApp());

class LoginUiKitApp extends StatelessWidget {
  const LoginUiKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI Kit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (_) => const LoginScreen(),
        RegisterScreen.route: (_) => const RegisterScreen(),
        ForgotPasswordScreen.route: (_) => const ForgotPasswordScreen(),
        OtpScreen.route: (_) => const OtpScreen(),
        ResetPasswordScreen.route: (_) => const ResetPasswordScreen(),
      },
    );
  }
}
