import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:opulenza/home.dart';
import 'package:opulenza/register.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailOrUsernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('users');

  bool isLoading = false;
  String selectedLanguage = 'Indonesia';
  final List<String> languages = ['Indonesia', 'English'];

  Future<void> signIn() async {
    setState(() => isLoading = true);

    final input = emailOrUsernameController.text.trim();
    final password = passwordController.text.trim();

    if (input.isEmpty || password.isEmpty) {
      showError('Username/Email dan Password harus diisi.');
      setState(() => isLoading = false);
      return;
    }

    try {
      String? email = input;
      String? userId;
      Map? userData;

      // Jika bukan email, cari dari Firebase Realtime Database berdasarkan username
      if (!input.contains('@')) {
        final snapshot = await _userRef.get();
        for (var child in snapshot.children) {
          final data = Map<String, dynamic>.from(child.value as Map);
          if (data['name'] == input) {
            email = data['email'];
            userId = child.key;
            userData = data;
            break;
          }
        }

        if (email == input) {
          showError('Username tidak ditemukan.');
          setState(() => isLoading = false);
          return;
        }
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password,
      );

      // Ambil data user dari Firebase
      final uid = userCredential.user!.uid;
      final userSnapshot = await _userRef.child(uid).get();
      if (!userSnapshot.exists) {
        showError('Data pengguna tidak ditemukan di database.');
        setState(() => isLoading = false);
        return;
      }

      userData = Map<String, dynamic>.from(userSnapshot.value as Map);

      // Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', uid);
      await prefs.setString('username', userData['name'] ?? '');
      await prefs.setString('email', userData['email'] ?? '');
      await prefs.setString('phone', userData['phone'] ?? '');
      await prefs.setString('password', userData['password'] ?? '');

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showError('Pengguna tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        showError('Password salah.');
      } else {
        showError('Gagal masuk: ${e.message}');
      }
    } catch (e) {
      showError('Terjadi kesalahan.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await saveUserToDatabase(userCredential.user!);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      showError('Login Google gagal.');
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await saveUserToDatabase(userCredential.user!);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      showError('Login Apple gagal.');
    }
  }

  Future<void> saveUserToDatabase(User user) async {
    final userRef = _userRef.child(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        'email': user.email,
        'name': user.displayName ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  void showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: 'Masukkan email anda'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await _auth.sendPasswordResetEmail(email: emailController.text.trim());
                Navigator.pop(context);
                showError('Link reset password telah dikirim.');
              } catch (e) {
                showError('Gagal mengirim email.');
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1A1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1C1A1A),
                  underline: const SizedBox(),
                  items: languages.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => selectedLanguage = newValue!),
                ),
              ),
            ),
            const Center(
              child: Image(
                image: AssetImage('Assets/Background/logogambar.png'),
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selamat Datang,', style: TextStyle(color: Color(0xFFB19174), fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Akses dunia kemewahan di ujung jarimu.\nMasuk untuk melanjutkan.', style: TextStyle(color: Color(0xFFB19174), fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFEBECE5),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(controller: emailOrUsernameController, hint: 'Username atau Email'),
                      const SizedBox(height: 10),
                      _buildTextField(controller: passwordController, hint: 'Password', obscureText: true),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: showForgotPasswordDialog,
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB19174),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Masuk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('atau masuk dengan', style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIcon(icon: Icons.g_mobiledata, onTap: signInWithGoogle),
                          const SizedBox(width: 16),
                          _SocialIcon(icon: Icons.apple, onTap: signInWithApple),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
                        },
                        child: const Text('Belum punya akun?', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        child: Icon(icon, size: 30, color: Colors.black),
      ),
    );
  }
}
