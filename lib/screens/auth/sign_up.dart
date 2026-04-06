// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in.dart';
import '../../config.dart';

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

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\[\]\-_]'));
  bool get _passwordValid => _hasMinLength && _hasUppercase && _hasLowercase && _hasDigit && _hasSpecial;

  bool get _emailValid => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(_emailController.text.trim());
  bool get _phoneValid => RegExp(r'^\d{7,15}$').hasMatch(_phoneController.text.trim());
  bool get _nationalIdValid => _nationalIdController.text.trim().isNotEmpty;
  bool get _ageValid {
    final age = int.tryParse(_ageController.text.trim());
    return age != null && age >= 18;
  }
  bool get _firstNameValid => RegExp(r'^[a-zA-Z]+$').hasMatch(_firstNameController.text.trim()) && _firstNameController.text.trim().isNotEmpty;
  bool get _lastNameValid => RegExp(r'^[a-zA-Z]+$').hasMatch(_lastNameController.text.trim()) && _lastNameController.text.trim().isNotEmpty;

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
    setState(() => _submitted = true);

    if (!_firstNameValid || !_lastNameValid || !_ageValid ||
        !_emailValid || !_passwordValid || !_phoneValid ||
        !_nationalIdValid || _selectedGender == null) return;

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

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please sign in.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignIn()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Sign up failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connection error, is the server running?')),
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

              Text(l.signUpTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black, height: 1.1)),
              SizedBox(height: 8),
              Text(l.signUpSubtitle,
                  style: TextStyle(fontSize: 15, color: Colors.grey[500])),

              SizedBox(height: 40),

              // First & Last name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _inputField(_firstNameController, l.firstName,
                      errorText: _submitted && !_firstNameValid ? l.errorLettersOnly : null)),
                  SizedBox(width: 12),
                  Expanded(child: _inputField(_lastNameController, l.lastName,
                      errorText: _submitted && !_lastNameValid ? l.errorLettersOnly : null)),
                ],
              ),
              SizedBox(height: 16),

              // Age & Gender
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _inputField(_ageController, l.age,
                      keyboard: TextInputType.number,
                      errorText: _submitted && !_ageValid ? l.errorMustBe18 : null)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _submitted && _selectedGender == null
                                  ? Colors.red.shade300
                                  : Colors.grey[200]!),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              hint: Text(l.gender, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(value: 'Male', child: Text(l.male)),
                                DropdownMenuItem(value: 'Female', child: Text(l.female)),
                              ],
                              onChanged: (val) => setState(() => _selectedGender = val),
                            ),
                          ),
                        ),
                        if (_submitted && _selectedGender == null)
                          Padding(
                            padding: EdgeInsets.only(left: 4, top: 4),
                            child: Text(l.errorRequired,
                                style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              _inputField(_emailController, l.email,
                  keyboard: TextInputType.emailAddress,
                  errorText: _submitted && !_emailValid ? l.errorValidEmail : null),
              SizedBox(height: 16),

              // Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: _passwordHidden,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: l.password,
                      labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey[50],
                      suffixIcon: IconButton(
                        icon: Icon(_passwordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.grey[400], size: 20),
                        onPressed: () => setState(() => _passwordHidden = !_passwordHidden),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _submitted && !_passwordValid
                              ? Colors.red.shade300 : Colors.grey[200]!)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF1f93a0), width: 1.5)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  _passwordRule(l.errorPasswordMinLength, _hasMinLength),
                  _passwordRule(l.errorPasswordUppercase, _hasUppercase),
                  _passwordRule(l.errorPasswordLowercase, _hasLowercase),
                  _passwordRule(l.errorPasswordNumber, _hasDigit),
                  _passwordRule(l.errorPasswordSpecial, _hasSpecial),
                ],
              ),
              SizedBox(height: 16),

              _inputField(_phoneController, l.phone,
                  keyboard: TextInputType.phone,
                  errorText: _submitted && !_phoneValid ? l.errorValidPhone : null),
              SizedBox(height: 16),

              _inputField(_nationalIdController, l.nationalId,
                  keyboard: TextInputType.number,
                  errorText: _submitted && !_nationalIdValid ? l.errorRequired : null),
              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(l.signUp,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),

              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l.haveAccount, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignIn()),
                    ),
                    child: Text(l.signIn,
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

  Widget _inputField(TextEditingController ctrl, String label, {
    TextInputType keyboard = TextInputType.text,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 15, color: Colors.black87),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: errorText != null ? Colors.red.shade300 : Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF1f93a0), width: 1.5)),
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

  Widget _passwordRule(String label, bool passing) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(passing ? Icons.check_circle : Icons.cancel,
              size: 13, color: passing ? Colors.green : Colors.red.shade300),
          SizedBox(width: 6),
          Text(label,
              style: TextStyle(fontSize: 12,
                  color: passing ? Colors.green : Colors.red.shade300)),
        ],
      ),
    );
  }
}