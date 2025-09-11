import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Tambahkan import ini
import '../constants/colors.dart';
import '../providers/user_provider.dart'; // Tambahkan import ini
import '../widgets/auth/auth_scaffold.dart';
import '../widgets/auth/auth_components.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool rememberMe = false;
  bool obscure = true;
  bool _isLoading = false; // State untuk loading
  String? _errorMessage; // State untuk error message

  OutlineInputBorder get _outline => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFAFAFAF), width: 1),
  );

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // Method baru untuk login
  Future<void> _handleLogin() async {
    // Validasi input
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password harus diisi';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Mendapatkan UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Melakukan sign in
      final success = await userProvider.signIn(
        email: emailC.text.trim(),
        password: passC.text,
      );

      if (success) {
        // Jika sukses, navigasi ke home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        // Jika gagal, tampilkan error dari provider
        setState(() {
          _errorMessage =
              userProvider.errorMessage ??
              'Login gagal, periksa email dan password Anda';
        });
      }
    } catch (e) {
      // Jika error, tampilkan pesan error
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Login to your Account',
      children: [
        // EMAIL
        TextField(
          controller: emailC,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFAFAFAF),
            ),
            floatingLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: _outline,
            focusedBorder: _outline.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),

        // PASSWORD
        TextField(
          controller: passC,
          obscureText: obscure,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFAFAFAF),
            ),
            floatingLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: _outline,
            focusedBorder: _outline.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
            isDense: true,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFFBEBEBE),
              ),
              onPressed: () => setState(() => obscure = !obscure),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // REMEMBER + FORGOT (hyperlink)
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (v) => setState(() => rememberMe = v ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: Color(0xFFAFAFAF)),
              fillColor: WidgetStateProperty.resolveWith(
                (s) =>
                    s.contains(WidgetState.selected)
                        ? AppColors.primary
                        : Colors.white,
              ),
            ),
            Text(
              'Remember me',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // TODO: navigate forgot password
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tampilkan error jika ada
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _errorMessage!,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

        // TOMBOL LOGIN
        GradientButton(
          text: _isLoading ? 'Signing in...' : 'Login',
          onTap:
              _isLoading
                  ? () {}
                  : () => _handleLogin(), // Menggunakan fungsi login baru
        ),
        const SizedBox(height: 20),

        // OR
        Row(
          children: const [
            Expanded(child: Divider(color: Color(0xFFE0E0E0))),
            SizedBox(width: 10),
            ChipOr(),
            SizedBox(width: 10),
            Expanded(child: Divider(color: Color(0xFFE0E0E0))),
          ],
        ),
        const SizedBox(height: 16),

        // SIGN UP — center
        Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: "Don't Have an Account? "),
                TextSpan(
                  text: "SIGN UP HERE",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF004577),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
