import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String selectedLanguage = 'Indonesia';
  String selectedCountryCode = '+62';
  String _passwordStrength = '';
  String? _errorMessage;
  bool _isLoading = false;

  final Map<String, String> countryCodes = {
    'Indonesia': '+62',
    'Malaysia': '+60',
    'Singapore': '+65',
    'USA': '+1',
    'UK': '+44',
    'India': '+91',
  };

  final List<String> languages = ['Indonesia', 'English'];

  String _checkPasswordStrength(String password) {
    final hasLower = RegExp(r'[a-z]');
    final hasUpper = RegExp(r'[A-Z]');
    final hasSymbol = RegExp(r'[^A-Za-z0-9]');

    if (hasLower.hasMatch(password) &&
        !hasUpper.hasMatch(password) &&
        !hasSymbol.hasMatch(password)) {
      return 'Lemah';
    }

    if (hasLower.hasMatch(password) &&
        hasUpper.hasMatch(password) &&
        !hasSymbol.hasMatch(password)) {
      return 'Sedang';
    }

    if (hasLower.hasMatch(password) &&
        hasUpper.hasMatch(password) &&
        hasSymbol.hasMatch(password)) {
      return 'Kuat';
    }

    return 'Lemah';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final phone = _phoneController.text.trim();

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Konfirmasi password tidak cocok.');
      return;
    }

    if (phone.startsWith('0')) {
      setState(() => _errorMessage = 'Nomor telepon tidak boleh diawali angka 0.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final phoneFull = "$selectedCountryCode$phone";

      final dbRef = FirebaseDatabase.instance.ref().child('users').child(uid);
      await dbRef.set({
        'name': username,
        'email': email,
        'phone': phoneFull,
        'password': password, // <- hanya untuk testing!
        'role': {'buyer': true, 'seller': false},
        'isSellerApproved': false,
        'credit': 0,
        'points': 0,
        'wishlist': [],
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', uid);
      await prefs.setString('email', email);
      await prefs.setString('username', username);
      await prefs.setString('phone', phoneFull);
      await prefs.setString('password', password);
      await prefs.setString('language', selectedLanguage);
      await prefs.setString('countryCode', selectedCountryCode);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/signin');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan, silakan coba lagi.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Harap isi $hint';
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1A1A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1C1A1A),
                  underline: const SizedBox(),
                  items: languages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBECE5),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bergabung dengan\nOpulenza,',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5C4F43),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Temukan, beli, dan jual barang mewah\n'
                                  'dengan cara paling elegan dan aman.',
                              style: TextStyle(fontSize: 14, color: Color(0xFF5C4F43)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(controller: _usernameController, hint: 'Username'),
                          const SizedBox(height: 12),
                          _buildTextField(controller: _emailController, hint: 'Email', inputType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedCountryCode,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: countryCodes.values.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCountryCode = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 6,
                                child: _buildTextField(
                                  controller: _phoneController,
                                  hint: 'No Telepon',
                                  inputType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _passwordStrength = _checkPasswordStrength(value);
                              });
                            },
                          ),
                          if (_passwordStrength.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 12),
                              child: Text(
                                'Kekuatan: $_passwordStrength',
                                style: TextStyle(
                                  color: _passwordStrength == 'Kuat'
                                      ? Colors.green
                                      : _passwordStrength == 'Sedang'
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hint: 'Konfirmasi Password',
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB19174),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Daftar',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah punya akun?", style: TextStyle(color: Colors.black)),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
                                child: const Text('Masuk', style: TextStyle(color: Color(0xFF5C4F43))),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
