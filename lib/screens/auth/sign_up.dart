import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/theme.dart';

import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  String? _selectedGender;
  bool _passwordHidden = true;
  bool _isLoading = false;
  bool _submitted = false;

  static final RegExp _namePattern = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'-]+$");

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\[\]\-_]'));
  bool get _passwordValid =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecial;

  bool get _emailValid =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(_emailController.text.trim());
  bool get _phoneValid =>
      RegExp(r'^\d{7,15}$').hasMatch(_phoneController.text.trim());
  bool get _nationalIdValid => _nationalIdController.text.trim().isNotEmpty;

  bool get _ageValid {
    final age = int.tryParse(_ageController.text.trim());
    return age != null && age >= 18;
  }

  bool get _firstNameValid {
    final value = _firstNameController.text.trim();
    return value.isNotEmpty && _namePattern.hasMatch(value);
  }

  bool get _lastNameValid {
    final value = _lastNameController.text.trim();
    return value.isNotEmpty && _namePattern.hasMatch(value);
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final l = AppLocalizations.of(context)!;

    setState(() => _submitted = true);

    if (!_firstNameValid ||
        !_lastNameValid ||
        !_ageValid ||
        !_emailValid ||
        !_passwordValid ||
        !_phoneValid ||
        !_nationalIdValid ||
        _selectedGender == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': int.parse(_ageController.text.trim()),
          'gender': _selectedGender,
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'phone': _phoneController.text.trim(),
          'nationalId': _nationalIdController.text.trim(),
        }),
      );

      final data = json.decode(response.body);

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignIn()),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((data['message'] as String?)?.trim().isNotEmpty == true
                ? data['message'] as String
                : l.unableToConnect),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.checkConnectionRetry)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context).extension<AppThemeExtension>()!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: t.bg,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDark
                    ? t.accent.withOpacity(0.10)
                    : t.accentLight.withOpacity(0.75),
                t.bg,
                t.bg,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthTopBar(isAr: isAr),
                  const SizedBox(height: 22),
                  _AuthHeader(
                    title: l.signUpTitle,
                    subtitle: l.signUpSubtitle,
                    isAr: isAr,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: t.cardBorder.withOpacity(0.45)),
                      boxShadow: [
                        BoxShadow(
                          color: t.cardBorder.withOpacity(0.14),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _AuthTextField(
                                controller: _firstNameController,
                                label: l.firstName,
                                errorText: _submitted && !_firstNameValid
                                    ? l.errorLettersOnly
                                    : null,
                                onChanged: () => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _AuthTextField(
                                controller: _lastNameController,
                                label: l.lastName,
                                errorText: _submitted && !_lastNameValid
                                    ? l.errorLettersOnly
                                    : null,
                                onChanged: () => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _AuthTextField(
                                controller: _ageController,
                                label: l.age,
                                keyboardType: TextInputType.number,
                                errorText:
                                    _submitted && !_ageValid ? l.errorMustBe18 : null,
                                onChanged: () => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _AuthDropdownField(
                                label: l.gender,
                                value: _selectedGender,
                                selectedLabels: {
                                  'Male': l.male,
                                  'Female': l.female,
                                },
                                errorText: _submitted && _selectedGender == null
                                    ? l.errorRequired
                                    : null,
                                items: [
                                  DropdownMenuItem(
                                    value: 'Male',
                                    child: _GenderMenuItem(
                                      label: l.male,
                                      icon: Icons.male_rounded,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Female',
                                    child: _GenderMenuItem(
                                      label: l.female,
                                      icon: Icons.female_rounded,
                                    ),
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => _selectedGender = value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _emailController,
                          label: l.email,
                          keyboardType: TextInputType.emailAddress,
                          errorText:
                              _submitted && !_emailValid ? l.errorValidEmail : null,
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _passwordController,
                          label: l.password,
                          obscureText: _passwordHidden,
                          errorText: _submitted && !_passwordValid
                              ? l.errorPasswordLength
                              : null,
                          onChanged: () => setState(() {}),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _passwordHidden = !_passwordHidden,
                            ),
                            icon: Icon(
                              _passwordHidden
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _passwordRule(l.errorPasswordMinLength, _hasMinLength),
                        _passwordRule(l.errorPasswordUppercase, _hasUppercase),
                        _passwordRule(l.errorPasswordLowercase, _hasLowercase),
                        _passwordRule(l.errorPasswordNumber, _hasDigit),
                        _passwordRule(l.errorPasswordSpecial, _hasSpecial),
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _phoneController,
                          label: l.phone,
                          keyboardType: TextInputType.phone,
                          errorText:
                              _submitted && !_phoneValid ? l.errorValidPhone : null,
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        _AuthTextField(
                          controller: _nationalIdController,
                          label: l.nationalId,
                          keyboardType: TextInputType.number,
                          errorText: _submitted && !_nationalIdValid
                              ? l.errorRequired
                              : null,
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: t.btnGradient),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.4,
                                      ),
                                    )
                                  : Text(
                                      l.signUp,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          l.haveAccount,
                          style: TextStyle(
                            color: t.sub,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const SignIn()),
                          ),
                          child: Text(
                            l.signIn,
                            style: TextStyle(
                              color: t.accent,
                              fontSize: 14.5,
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
      ),
    );
  }

  Widget _inputField(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? errorText,
  }) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          onChanged: (_) => setState(() {}),
          style: TextStyle(
            fontSize: 15,
            color: t.title,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: t.label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: t.field,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.fieldBorder.withOpacity(0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: errorText != null ? t.danger : t.fieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.accent, width: 1.6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.danger, width: 1.6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
            child: Text(
              errorText,
              style: TextStyle(
                color: t.danger,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _passwordRule(String label, bool passing) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            passing ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: passing ? t.success : t.danger,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: passing ? t.success : t.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTopBar extends StatelessWidget {
  const _AuthTopBar({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: t.cardBorder.withOpacity(0.45)),
            ),
            child: Icon(
              isAr ? Icons.arrow_forward : Icons.arrow_back,
              color: t.title,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({
    required this.title,
    required this.subtitle,
    required this.isAr,
  });

  final String title;
  final String subtitle;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment:
          isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: isAr ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: t.title,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            fontFamily: 'DM Serif Display',
            height: 1.08,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            subtitle,
            textAlign: isAr ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              color: t.sub,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: (_) => onChanged(),
          style: TextStyle(
            color: t.title,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: t.label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: suffixIcon,
            suffixIconColor: t.sub,
            filled: true,
            fillColor: t.field,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.fieldBorder.withOpacity(0.6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: errorText != null ? t.danger : t.fieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.accent, width: 1.6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: t.danger, width: 1.6),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
            child: Text(
              errorText!,
              style: TextStyle(
                color: t.danger,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _AuthDropdownField extends StatelessWidget {
  const _AuthDropdownField({
    required this.label,
    required this.value,
    required this.selectedLabels,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final String? value;
  final Map<String, String> selectedLabels;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: t.field,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: errorText != null ? t.danger : t.fieldBorder,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              borderRadius: BorderRadius.circular(18),
              hint: Text(
                label,
                style: TextStyle(
                  color: t.label,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selectedItemBuilder: (context) => items
                  .map(
                    (item) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        selectedLabels[item.value] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: t.title,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              dropdownColor: t.card,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: t.sub,
                size: 20,
              ),
              iconEnabledColor: t.sub,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, top: 6),
            child: Text(
              errorText!,
              style: TextStyle(
                color: t.danger,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _GenderMenuItem extends StatelessWidget {
  const _GenderMenuItem({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: t.accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color: t.accent,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: t.title,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
