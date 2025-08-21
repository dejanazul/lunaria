import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

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
                  'Login to your Account',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 40),

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

                const SizedBox(height: 16),

                // Remember me & Forgot password row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me checkbox
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            fillColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return const Color(0xFFE0E0E0);
                            }),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember me',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.textPrimary,
                            height: 2.25,
                          ),
                        ),
                      ],
                    ),

                    // Forgot password
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to forgot password
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Login Button
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
                    onPressed: _isLoading ? null : _handleLogin,
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
                              'Login',
                              style: AppTextStyles.h5.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 24),

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
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Social Login Buttons
                Column(
                  children: [
                    _buildSocialButton(
                      text: 'Login with Google',
                      icon: Icons.g_mobiledata,
                      iconColor: AppColors.google,
                      onPressed:
                          () => _handleSocialLogin(AppConstants.googleProvider),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialButton(
                      text: 'Login with Facebook',
                      icon: Icons.facebook,
                      iconColor: AppColors.facebook,
                      onPressed:
                          () =>
                              _handleSocialLogin(AppConstants.facebookProvider),
                    ),

                    const SizedBox(height: 16),

                    _buildSocialButton(
                      text: 'Login with Apple',
                      icon: Icons.apple,
                      iconColor: AppColors.apple,
                      onPressed:
                          () => _handleSocialLogin(AppConstants.appleProvider),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Sign Up Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't Have an Account? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to sign up page
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'SIGN UP HERE',
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

  void _handleLogin() async {
    // Validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
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

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // TODO: Implement actual login logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login with $provider'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
