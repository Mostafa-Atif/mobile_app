import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/auth/forgot_password.dart';
import 'package:mobile_app/screens/auth/sign_up.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = false;
  bool _submitted       = false;

  bool get _emailValid => RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
  ).hasMatch(_emailController.text.trim());
  bool get _passwordEmpty => _passwordController.text.isEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _submitted = true);
    if (!_emailValid || _passwordEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email':    _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final data = json.decode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token',     data['token']);
        await prefs.setString('firstName', data['user']['firstName']);
        await prefs.setString('lastName',  data['user']['lastName']);
        await prefs.setString('email',     data['user']['email']);
        await prefs.setString('phone',     data['user']['phone']);
        await prefs.setString('userId',    data['user']['id']);
        await prefs.setString('gender',    data['user']['gender'] ?? '');
        await prefs.setString('role',      data['user']['role'] ?? '');
        await prefs.setString('userType',  data['user']['userType'] ?? '');
        await prefs.setBool('isAdmin',     data['user']['isAdmin'] == true);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            (data['message'] as String?)?.trim().isNotEmpty == true
                ? data['message'] as String
                : l.unableToConnect,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(content: Text(l.checkConnectionRetry)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l     = AppLocalizations.of(context)!;
    final t     = Theme.of(context).extension<AppThemeExtension>()!;
    final isAr  = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: t.bg,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ──────────────────────────────────────────────
                _BackButton(t: t, isAr: isAr),
                const SizedBox(height: 32),

                // ── Header ───────────────────────────────────────────────────
                _AuthHeader(
                  title:    l.signInTitle,
                  subtitle: l.signInSubtitle,
                  isAr:     isAr,
                  t:        t,
                ),
                const SizedBox(height: 28),

                // ── Card ─────────────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
                  decoration: BoxDecoration(
                    color:        t.card,
                    borderRadius: BorderRadius.circular(24),
                    border:       Border.all(color: t.cardBorder.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color:      t.cardBorder.withOpacity(0.12),
                        blurRadius: 20,
                        offset:     const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      _LabeledField(
                        label:        l.email,
                        controller:   _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon:   Icons.mail_outline_rounded,
                        errorText:    _submitted && !_emailValid ? l.errorValidEmail : null,
                        onChanged:    () => setState(() {}),
                        t:            t,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      _LabeledField(
                        label:       l.password,
                        controller:  _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon:  Icons.lock_outline_rounded,
                        errorText:   _submitted && _passwordEmpty ? l.errorRequired : null,
                        onChanged:   () => setState(() {}),
                        t:           t,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: t.label,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment:
                            isAr ? Alignment.centerLeft : Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPassword()),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: t.accent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                          ),
                          child: Text(
                            l.forgotPassword,
                            style: const TextStyle(
                              fontSize:   13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sign-in button
                      SizedBox(
                        width:  double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:  Alignment.topLeft,
                              end:    Alignment.bottomRight,
                              colors: t.btnGradient,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:         Colors.transparent,
                              shadowColor:             Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width:  20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color:       Colors.white,
                                      strokeWidth: 2.2,
                                    ),
                                  )
                                : Text(
                                    l.signIn,
                                    style: const TextStyle(
                                      color:      Colors.white,
                                      fontSize:   15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Divider ──────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: t.divider, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color:      t.label,
                          fontSize:   12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: t.divider, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Sign-up row ──────────────────────────────────────────────
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        l.noAccount,
                        style: TextStyle(
                          color:      t.sub,
                          fontSize:   13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUp()),
                        ),
                        child: Text(
                          l.signUp,
                          style: TextStyle(
                            color:      t.accent,
                            fontSize:   14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.t, required this.isAr});

  final AppThemeExtension t;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width:  42,
        height: 42,
        decoration: BoxDecoration(
          color:        t.backBg,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: t.cardBorder.withOpacity(0.5)),
        ),
        child: Icon(
          isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
          color: t.accent,
          size:  20,
        ),
      ),
    );
  }
}

// ── Auth Header ───────────────────────────────────────────────────────────────

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.title,
    required this.subtitle,
    required this.isAr,
    required this.t,
  });

  final String title;
  final String subtitle;
  final bool   isAr;
  final AppThemeExtension t;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: isAr ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color:      t.title,
            fontSize:   30,
            fontWeight: FontWeight.w900,
            height:     1.08,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: isAr ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color:      t.sub,
            fontSize:   14,
            fontWeight: FontWeight.w600,
            height:     1.5,
          ),
        ),
      ],
    );
  }
}

// ── Labeled Field ─────────────────────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.prefixIcon,
    required this.onChanged,
    required this.t,
    this.keyboardType = TextInputType.text,
    this.obscureText  = false,
    this.errorText,
    this.suffixIcon,
  });

  final String                label;
  final TextEditingController controller;
  final IconData              prefixIcon;
  final VoidCallback          onChanged;
  final AppThemeExtension     t;
  final TextInputType         keyboardType;
  final bool                  obscureText;
  final String?               errorText;
  final Widget?               suffixIcon;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Static label above the field
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color:         t.label,
            fontSize:      11,
            fontWeight:    FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 6),

        // Field
        TextField(
          controller:   controller,
          keyboardType: keyboardType,
          obscureText:  obscureText,
          onChanged:    (_) => onChanged(),
          style: TextStyle(
            color:      t.title,
            fontSize:   14.5,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText:  '${label.toLowerCase()}...',
            hintStyle: TextStyle(
              color:      t.label,
              fontSize:   14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(prefixIcon, size: 18, color: t.label),
            suffixIcon: suffixIcon,
            filled:     true,
            fillColor:  t.field,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical:   15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:   BorderSide(color: t.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? t.danger : t.fieldBorder,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:   BorderSide(color: t.accent, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:   BorderSide(color: t.danger, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:   BorderSide(color: t.danger, width: 1.8),
            ),
          ),
        ),

        // Error text
        if (hasError) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                color:      t.danger,
                fontSize:   12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
