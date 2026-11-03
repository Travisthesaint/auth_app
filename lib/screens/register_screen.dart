import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/error_banner.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await AuthService.instance.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        fadeRoute(LoginScreen(prefillEmail: user.email, justRegistered: true)),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Create your account',
                subtitle: 'It only takes a minute to get started.',
              ),
              AppTextField(
                controller: _name,
                label: 'Full name',
                hint: 'Jane Doe',
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                enabled: !_loading,
                validator: Validators.fullName,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _email,
                focusNode: _emailFocus,
                label: 'Email address',
                hint: 'you@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !_loading,
                validator: Validators.email,
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _password,
                focusNode: _passwordFocus,
                label: 'Password',
                hint: 'At least 8 characters',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                enabled: !_loading,
                validator: Validators.newPassword,
                // Rebuild so the strength meter updates as the user types.
                onChanged: (_) => setState(() {}),
                onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
              ),
              PasswordStrengthMeter(password: _password.text),
              const SizedBox(height: 18),
              AppTextField(
                controller: _confirm,
                focusNode: _confirmFocus,
                label: 'Confirm password',
                icon: Icons.lock_reset_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                enabled: !_loading,
                validator: (v) => Validators.confirmPassword(v, _password.text),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              _TermsCheckbox(enabled: !_loading),
              if (_error != null) ...[
                const SizedBox(height: 8),
                ErrorBanner(message: _error!),
              ],
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Create account',
                isLoading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context)
                            .pushReplacement(fadeRoute(const LoginScreen())),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Checkbox that takes part in form validation, so "Create account" is
/// blocked (with a visible message) until the terms are accepted.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: false,
      validator: (v) =>
          (v ?? false) ? null : 'You must accept the terms to continue',
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: state.value ?? false,
                  onChanged: enabled ? (v) => state.didChange(v) : null,
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
