import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:provider/provider.dart';
import '../authentication/profile/myprofile_name_page.dart';
import '../constants/colors.dart';
import '../widgets/auth/auth_scaffold.dart';
import '../widgets/auth/auth_components.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final userC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool obscure = true;
  bool isLoading = false;
  String? errorMessage;

  OutlineInputBorder get _outline => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFAFAFAF), width: 1),
  );

  @override
  void dispose() {
    userC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validasi sederhana
    if (userC.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill all fields";
      });
      return;
    }

    if (!emailC.text.contains('@')) {
      setState(() {
        errorMessage = "Please enter a valid email";
      });
      return;
    }

    if (passC.text.length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Store the data in the SignupDataProvider
      final signupProvider = Provider.of<SignupDataProvider>(
        context,
        listen: false,
      );

      // Update the signup info in the provider
      signupProvider.updateSignupInfo(
        username: userC.text.trim(),
        email: emailC.text.trim(),
        password: passC.text,
      );

      // Navigate to next screen in the signup flow
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyProfileNamePage()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
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
    return AuthScaffold(
      title: 'Create an Account',
      children: [
        // USERNAME
        TextField(
          controller: userC,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFAFAFAF),
            ),
            floatingLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
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
        const SizedBox(height: 16),

        // Error message
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              errorMessage!,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

        // BUTTON
        GradientButton(
          text: isLoading ? 'Creating Account...' : 'Get Started!',
          onTap:
              isLoading
                  ? () {}
                  : () => _handleSignUp(), // Convert to proper VoidCallback
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

        // // SOCIAL
        // SocialButton(
        //   asset: 'assets/icons/google.png',
        //   text: 'Sign Up with Google',
        //   onTap: () {},
        // ),
        // const SizedBox(height: 12),
        // SocialButton(
        //   asset: 'assets/icons/facebook.png',
        //   text: 'Sign Up with Facebook',
        //   onTap: () {},
        // ),
        // const SizedBox(height: 12),
        // SocialButton(
        //   asset: 'assets/icons/apple.png',
        //   text: 'Sign Up with Apple',
        //   onTap: () {},
        // ),
        // const SizedBox(height: 50),

        // Already have account → back to login
        Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(text: "Already Have an Account? "),
                TextSpan(
                  text: "LOGIN HERE",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF004577),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
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
