import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../profile/my_profile_bday_page.dart';

class MyProfileNameInputPage extends StatefulWidget {
  const MyProfileNameInputPage({super.key});

  @override
  State<MyProfileNameInputPage> createState() => _MyProfileNameInputPageState();
}

class _MyProfileNameInputPageState extends State<MyProfileNameInputPage> {
  final nameC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    super.dispose();
  }

  void _saveName() {
    if (nameC.text.trim().isEmpty) return;

    // Get the SignupDataProvider and update the name
    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateName(nameC.text.trim());

    // Navigate to next page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MyProfileBdayPage()));
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = nameC.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true, // biar layar naik kalau keyboard muncul
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0x11000000)),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Pertanyaan
              Text(
                "What’s your name?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),

              // Input (placeholder tengah + underline pendek)
              CenteredUnderlineField(
                controller: nameC,
                onChanged: (_) => setState(() {}),
                // optional: maxWidth: 250,  // atur biar mirip figma
                focusedLineColor: Colors.black, // garis saat fokus
              ),
            ],
          ),
        ),
      ),

      // tombol Next dipindah ke bottomNavigationBar supaya bisa naik
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child:
              isFilled
                  ? GradientButton(
                    text: 'Next',
                    onTap: () {
                      _saveName();
                    },
                  )
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black.withOpacity(0.4),
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0x33000000),
                    ),
                    onPressed: null,
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
