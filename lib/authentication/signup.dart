import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Logo/Illustration Section
                Center(
                  child: Container(
                    width: 180,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF420D4A), // Dark purple from Figma
                          const Color(0xFF7B347E), // Secondary purple
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'LUNARIA',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'Create an Account',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 40),

                // Username Field
                _buildInputField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Enter your username',
                ),

                const SizedBox(height: 20),

                // Email Field
                _buildInputField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),

                const SizedBox(height: 40),

                // Get Started Button
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF420D4A), // Dark purple
                        Color(0xFF7B347E), // Secondary purple
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : Text(
                              'Get Started!',
                              style: AppTextStyles.h5.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 30),

                // Or Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.surface,
                      child: Text(
                        'Or',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF212121),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Social Login Buttons
                Column(
                  children: [
                    _buildSocialButton(
                      text: 'Sign Up with Google',
                      icon: Icons.g_mobiledata,
                      iconColor: AppColors.google,
                      onPressed:
                          () =>
                              _handleSocialSignUp(AppConstants.googleProvider),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialButton(
                      text: 'Sign Up with Facebook',
                      icon: Icons.facebook,
                      iconColor: AppColors.facebook,
                      onPressed:
                          () => _handleSocialSignUp(
                            AppConstants.facebookProvider,
                          ),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialButton(
                      text: 'Sign Up with Apple',
                      icon: Icons.apple,
                      iconColor: AppColors.apple,
                      onPressed:
                          () => _handleSocialSignUp(AppConstants.appleProvider),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Login Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already Have an Account? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to login page
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'LOGIN HERE',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Stack(
      children: [
        // Input field
        Container(
          height: 55,
          margin: const EdgeInsets.only(top: 9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: const Color(0xFFAFAFAF), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.inputHint.copyWith(
                color: const Color(0xFFAFAFAF),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        // Floating label
        Positioned(
          left: 14,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            color: AppColors.surface,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFAFAFAF),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Stack(
      children: [
        // Input field
        Container(
          height: 55,
          margin: const EdgeInsets.only(top: 9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: const Color(0xFFAFAFAF), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: AppTextStyles.inputHint.copyWith(
                color: const Color(0xFFAFAFAF),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFBEBEBE),
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),

        // Floating label
        Positioned(
          left: 14,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            color: AppColors.surface,
            child: Text(
              'Password',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFAFAFAF),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: const Color(0xFFB4B4B4), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF616161),
                fontSize: 12.8,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp() async {
    // Validation
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppConstants.errorRequiredField),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!RegExp(AppConstants.emailPattern).hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppConstants.errorInvalidEmail),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text.length < AppConstants.minPasswordLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppConstants.errorPasswordTooShort),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // TODO: Implement actual sign up logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppConstants.successAccountCreated),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleSocialSignUp(String provider) {
    // TODO: Implement social sign up
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up with $provider'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
