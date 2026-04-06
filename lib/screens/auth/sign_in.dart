import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/temp_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';
import 'forgot_password.dart';
import '../../config.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _submitted = false;

  bool get _emailValid =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(_emailController.text.trim());
  bool get _passwordEmpty => _passwordController.text.isEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _submitted = true);
    if (!_emailValid || _passwordEmpty) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('firstName', data['user']['firstName']);
        await prefs.setString('lastName', data['user']['lastName']);
        await prefs.setString('email', data['user']['email']);
        await prefs.setString('phone', data['user']['phone']);
        await prefs.setString('userId', data['user']['id']);
        await prefs.setString('gender', data['user']['gender'] ?? '');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 40),

              // Title
              Text(l.signInTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black, height: 1.1)),
              SizedBox(height: 8),
              Text(l.signInSubtitle,
                  style: TextStyle(fontSize: 15, color: Colors.grey[500])),

              SizedBox(height: 48),

              // Email
              _inputField(
                controller: _emailController,
                label: l.email,
                keyboardType: TextInputType.emailAddress,
                errorText: _submitted && !_emailValid ? l.errorValidEmail : null,
              ),
              SizedBox(height: 16),

              // Password
              _inputField(
                controller: _passwordController,
                label: l.password,
                obscure: _obscurePassword,
                errorText: _submitted && _passwordEmpty ? l.errorRequired : null,
                suffix: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey[400], size: 20),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),

              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPassword()),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(l.forgotPassword,
                      style: TextStyle(color: Color(0xFF1f93a0), fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),

              SizedBox(height: 32),

              // Sign in button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(l.signIn,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),

              SizedBox(height: 28),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l.noAccount, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignUp()),
                    ),
                    child: Text(l.signUp,
                        style: TextStyle(color: Color(0xFF1f93a0), fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? errorText,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 15, color: Colors.black87),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: errorText != null ? Colors.red.shade300 : Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF1f93a0), width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 4),
            child: Text(errorText, style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
          ),
      ],
    );
  }
}