import 'package:flutter/material.dart';
import 'package:lunaria/providers/cookie_provider.dart';
import 'package:provider/provider.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/providers/level_provider.dart';
import 'package:lunaria/providers/user_provider.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../widgets/home_pet/index.dart';

class VPHomeScreen extends StatefulWidget {
  const VPHomeScreen({super.key});

  @override
  State<VPHomeScreen> createState() => _VPHomeScreenState();
}

class _VPHomeScreenState extends State<VPHomeScreen> {
  final int _currentIndex = 2;
  final TextEditingController _chatController = TextEditingController();
  final FocusNode _chatFocusNode = FocusNode();

  // Helper method untuk mengecek apakah layar berukuran medium (375px)
  bool isMediumPhone(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 360 && width <= 375;
  }

  @override
  void initState() {
    super.initState();
    // Sync level data from database when home screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final cookieProvider = Provider.of<CookieProvider>(
        context,
        listen: false,
      );

      // Initialize level provider with user data
      levelProvider.initialize(userProvider);
      cookieProvider.initialize(userProvider);

      // Sync latest data from database
      levelProvider.syncFromDatabase();
      cookieProvider.syncFromDatabase();
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content stack
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
              ),
            ),

            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  // Background pet illustration
                  Positioned(
                    top: isMediumPhone(context) ? -25 : -31,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: ResponsiveHelper.getScreenHeight(context) * 0.9,
                      width: ResponsiveHelper.getScreenWidth(context),
                      child: Image.asset(
                        'assets/images/pet_background-4faf77.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Main pet character
                  Positioned(
                    top:
                        isMediumPhone(context)
                            ? ResponsiveHelper.getScreenHeight(context) * 0.36
                            : ResponsiveHelper.getScreenHeight(context) * 0.39,
                    left:
                        isMediumPhone(context)
                            ? ResponsiveHelper.getScreenWidth(context) * 0.0
                            : ResponsiveHelper.getScreenWidth(context) * 0.01,
                    child: SizedBox(
                      height:
                          isMediumPhone(context)
                              ? ResponsiveHelper.getScreenHeight(context) * 0.42
                              : ResponsiveHelper.getScreenHeight(context) *
                                  0.43,
                      width:
                          isMediumPhone(context)
                              ? ResponsiveHelper.getScreenWidth(context) * 1.0
                              : ResponsiveHelper.getScreenWidth(context) * 0.98,
                      child: Image.asset(
                        'assets/images/pet_main_image.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Level indicator
                  Positioned(
                    top:
                        ResponsiveHelper.getSafeAreaTop(context) +
                        ResponsiveHelper.getMediumSpacing(context),
                    left: ResponsiveHelper.getMediumSpacing(context),
                    child: _buildLevelIndicator(),
                  ),

                  // Cookie counter
                  Positioned(
                    top:
                        ResponsiveHelper.getSafeAreaTop(context) +
                        ResponsiveHelper.getMediumSpacing(context),
                    left:
                        isMediumPhone(context)
                            ? ResponsiveHelper.getScreenWidth(context) * 0.40
                            : ResponsiveHelper.getScreenWidth(context) * 0.42,
                    child: Row(
                      children: [
                        _buildCookieCounter(),
                        const SizedBox(width: 5),
                        _buildAddCookieButton(),
                      ],
                    ),
                  ),

                  // Mood button
                  Positioned(
                    top:
                        isMediumPhone(context)
                            ? ResponsiveHelper.getScreenHeight(context) * 0.68
                            : ResponsiveHelper.getScreenHeight(context) * 0.70,
                    right: ResponsiveHelper.getMediumSpacing(context),
                    child: _buildMoodButton(),
                  ),

                  // Message bubble (tap to open card)
                  Positioned(
                    top:
                        isMediumPhone(context)
                            ? ResponsiveHelper.getScreenHeight(context) * 0.22
                            : ResponsiveHelper.getScreenHeight(context) * 0.23,
                    right: ResponsiveHelper.getMediumSpacing(context),
                    child: _buildMessageBubble(),
                  ),

                  // Bottom navigation
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BottomNav(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        NavigationService.navigateToBottomNavScreen(
                          context,
                          index,
                          _currentIndex,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TAP BARRIER: tap di luar card untuk dismiss (letakkan SEBELUM card)
          Consumer<ChatHistoryProvider>(
            builder: (context, chatProvider, _) {
              if (!chatProvider.isHistoryVisible) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: GestureDetector(
                  behavior:
                      HitTestBehavior.opaque, // tangkap tap di area kosong
                  onTap: () {
                    FocusScope.of(context).unfocus(); // tutup keyboard
                    chatProvider.toggleCardVisibility(); // dismiss card
                  },
                  child: const SizedBox.shrink(),
                ),
              );
            },
          ),

          // Chat history card overlays everything, including bottom nav
          _buildChatHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator() {
    return const LevelIndicator();
  }

  Widget _buildCookieCounter() {
    return const CookieCounter();
  }

  Widget _buildAddCookieButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.buyCookies);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: const Color(0xFFF2D6BA),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF553F35), width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 12, color: Color(0xFF553F35)),
        ),
      ),
    );
  }

  Widget _buildMoodButton() {
    return const MoodButton();
  }

  // Bubble sekarang bisa di-tap untuk membuka card
  Widget _buildMessageBubble() {
    return GestureDetector(
      onTap: () {
        final chat = Provider.of<ChatHistoryProvider>(context, listen: false);
        if (!chat.isHistoryVisible) {
          chat.toggleCardVisibility(); // show card
        }
      },
      child: const MessageBubble(),
    );
  }

  Widget _buildChatHistoryCard() {
    return ChatHistoryCard(
      chatController: _chatController,
      sendMessage: _sendMessage,
    );
  }

  Future<void> _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final provider = Provider.of<ChatHistoryProvider>(context, listen: false);
    _chatController.clear();

    await provider.sendMessageToGemini(text);
  }
}
