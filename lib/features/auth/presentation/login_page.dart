import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_colors.dart';
import '../../navigation/presentation/bottom_nav_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isObscure = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void switchTab(bool login) {
    if (isLoading) return;
    setState(() {
      isLogin = login;
      nameError = null;
      emailError = null;
      passwordError = null;
    });
  }

  Future<void> validateAndSubmit() async {
    if (isLoading) return;

    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    bool isValid = true;

    // VALIDATION
    if (!isLogin && name.isEmpty) {
      nameError = 'Nama lengkap wajib diisi';
      isValid = false;
    }

    if (email.isEmpty) {
      emailError = 'Email wajib diisi';
      isValid = false;
    } else if (!email.contains('@') || !email.contains('.')) {
      emailError = 'Format email tidak valid';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError = 'Password wajib diisi';
      isValid = false;
    } else if (password.length < 6) {
      passwordError = 'Password minimal 6 karakter';
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // LOGIN
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      // REGISTER
      else {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (credential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .set({
                'uid': credential.user!.uid,
                'name': name,
                'email': email,
                'isSeller': false,
                'createdAt': Timestamp.now(),
              });
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan autentikasi.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'Akun belum terdaftar. Silakan daftar akun baru di tab "Daftar".';
          break;
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-login-credentials':
          errorMessage =
              'Email atau password yang Anda masukkan salah. Periksa kembali.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'Email sudah digunakan. Silakan langsung masuk di tab "Masuk".';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        case 'weak-password':
          errorMessage = 'Password terlalu lemah (minimal 6 karakter).';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Metode Email/Password belum diaktifkan di Firebase Console.';
          break;
        case 'network-request-failed':
          errorMessage = 'Koneksi internet bermasalah. Periksa jaringan Anda.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Terlalu banyak percobaan gagal. Silakan coba lagi beberapa saat.';
          break;
        default:
          errorMessage = e.message ?? 'Autentikasi gagal (${e.code})';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 64,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // MAIN CONTENT
                    Column(
                      children: [
                        // LOGO
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGreen.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_florist,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // TITLE
                        const Text(
                          'Florapp',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Rajanya Jual Flora',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // TOGGLE LOGIN REGISTER
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // LOGIN TAB
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => switchTab(true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLogin
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isLogin
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      'Masuk',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isLogin
                                            ? AppColors.accentGreen
                                            : Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // REGISTER TAB
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => switchTab(false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !isLogin
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: !isLogin
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      'Daftar',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isLogin
                                            ? AppColors.accentGreen
                                            : Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // NAME
                        if (!isLogin) ...[
                          buildInputField(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person_outline,
                            controller: nameController,
                            errorText: nameError,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // EMAIL
                        buildInputField(
                          label: 'Email',
                          hint: 'Masukkan alamat email',
                          icon: Icons.mail_outline,
                          controller: emailController,
                          errorText: emailError,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        // PASSWORD
                        buildInputField(
                          label: 'Password',
                          hint: 'Masukkan password (min. 6 karakter)',
                          icon: Icons.lock_outline,
                          controller: passwordController,
                          errorText: passwordError,
                          isPassword: true,
                        ),

                        const SizedBox(height: 32),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : validateAndSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              disabledBackgroundColor:
                                  AppColors.accentGreen.withValues(alpha: 0.6),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Memproses...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isLogin
                                            ? 'Masuk ke Akun'
                                            : 'Buat Akun',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),

                    // FOOTER
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Dengan melanjutkan, Anda menyetujui\n',
                            ),
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: TextStyle(
                                color: AppColors.accentGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' serta '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: TextStyle(
                                color: AppColors.accentGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? errorText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && isObscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: errorText != null ? Colors.red : Colors.grey,
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : AppColors.accentGreen,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
