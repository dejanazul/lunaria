import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/route_names.dart';

class BuyCookiesScreen extends StatelessWidget {
  BuyCookiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        title: const Text(
          'Store',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 23,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Current Cookie Display
                    _buildCurrentCookieCounter(context),
                    const SizedBox(height: 20),

                    // Cookies Section
                    _buildSectionContainer(
                      context: context,
                      title: 'Cookies',
                      titleColor: const Color(0xFF553F35),
                      backgroundColor: const Color(0xFFF2D6BA),
                      borderColor: const Color(0xFF553F35),
                      items: _cookiePackages,
                    ),

                    const SizedBox(height: 20),

                    // Luna Skins Section (disabled for now)
                    _buildSectionContainer(
                      context: context,
                      title: 'Luna Skins',
                      titleColor: Colors.white,
                      backgroundColor: const Color(0xFFB1B1F1),
                      borderColor: const Color(0xFF6868E9),
                      items: _skinPackages,
                      isEnabled: false,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNav(
                currentIndex: 2, // Home index
                onTap: (index) {
                  if (index != 2) {
                    // Navigate to other screens
                    Navigator.pushReplacementNamed(
                      context,
                      index == 0
                          ? RouteNames.calendar
                          : index == 1
                          ? RouteNames.train
                          : index == 3
                          ? RouteNames.community
                          : RouteNames.profile,
                    );
                  } else {
                    // Already on pet home, just pop back
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCookieCounter(BuildContext context) {
    return Consumer<CookieProvider>(
      builder: (context, cookieProvider, _) {
        return SizedBox(
          width: 85,
          height: 33,
          child: Stack(
            children: [
              // Cookie counter background
              Positioned(
                left: 3,
                top: 4,
                child: Container(
                  width: 82,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2D6BA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF553F35)),
                  ),
                ),
              ),
              // Cookie count text
              Positioned(
                left: 46,
                top: 9,
                child: Text(
                  cookieProvider.cookies.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF553F35),
                  ),
                ),
              ),
              // Cookie icon
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  width: 33,
                  height: 33,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/cookie_icon_new.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionContainer({
    required BuildContext context,
    required String title,
    required Color titleColor,
    required Color backgroundColor,
    required Color borderColor,
    required List<Map<String, dynamic>> items,
    bool isEnabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: Column(
        children: [
          // Section Title
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF553F35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items Grid
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildItemCard(
                  context,
                  items[index],
                  isEnabled: isEnabled,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    Map<String, dynamic> item, {
    bool isEnabled = true,
  }) {
    // Check if this is a skin item or a cookie item
    final bool isSkin = item.containsKey('name');

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap:
            isEnabled
                ? () => _showPurchaseDialog(context, item)
                : () => _showComingSoonDialog(context),
        child: Column(
          children: [
            // Item Container (Cookie Count or Skin)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child:
                  isSkin
                      ? _buildSkinPreview(item['name'])
                      : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Cookie Images
                          _buildCookieImages(item['count']),

                          // Cookie Count Text
                          Text(
                            item['count'].toString(),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF553F35),
                            ),
                          ),
                        ],
                      ),
            ),

            const SizedBox(height: 4),

            // Price Button
            Container(
              width: 100,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF553F35),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                item['price'],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookieImages(int count) {
    // Determine cookie image positions based on count
    List<Widget> cookieImages = [];

    // Position cookies in a pattern based on count from Figma design
    if (count >= 1000) {
      // 6 cookies for 1000+
      cookieImages = [
        Positioned(top: 0, left: 23, child: _cookieImage()),
        Positioned(top: 10, left: 40, child: _cookieImage()),
        Positioned(top: 27, left: 35, child: _cookieImage()),
        Positioned(top: 21, left: 15, child: _cookieImage()),
        Positioned(top: 0, left: 0, child: _cookieImage()),
        Positioned(top: 17, left: 0, child: _cookieImage()),
      ];
    } else if (count >= 500) {
      // 5 cookies for 500+
      cookieImages = [
        Positioned(top: 0, left: 15, child: _cookieImage()),
        Positioned(top: 10, left: 32, child: _cookieImage()),
        Positioned(top: 27, left: 27, child: _cookieImage()),
        Positioned(top: 21, left: 11, child: _cookieImage()),
        Positioned(top: 0, left: 0, child: _cookieImage()),
      ];
    } else if (count >= 200) {
      // 4 cookies for 200+
      cookieImages = [
        Positioned(top: 0, left: 15, child: _cookieImage()),
        Positioned(top: 10, left: 32, child: _cookieImage()),
        Positioned(top: 21, left: 11, child: _cookieImage()),
        Positioned(top: 0, left: 0, child: _cookieImage()),
      ];
    } else if (count >= 100) {
      // 4 cookies for 100+
      cookieImages = [
        Positioned(top: 0, left: 15, child: _cookieImage()),
        Positioned(top: 10, left: 32, child: _cookieImage()),
        Positioned(top: 21, left: 11, child: _cookieImage()),
        Positioned(top: 0, left: 0, child: _cookieImage()),
      ];
    } else if (count >= 40) {
      // 3 cookies for 40+
      cookieImages = [
        Positioned(top: 0, left: 4, child: _cookieImage()),
        Positioned(top: 10, left: 21, child: _cookieImage()),
        Positioned(top: 21, left: 0, child: _cookieImage()),
      ];
    } else if (count >= 20) {
      // 2 cookies for 20+
      cookieImages = [
        Positioned(top: 0, left: 0, child: _cookieImage()),
        Positioned(top: 10, left: 17, child: _cookieImage()),
      ];
    } else {
      // 2 cookies for less than 20
      cookieImages = [
        Positioned(top: 0, left: 0, child: _cookieImage()),
        Positioned(top: 10, left: 17, child: _cookieImage()),
      ];
    }

    return Stack(children: cookieImages);
  }

  Widget _cookieImage() {
    return SizedBox(
      width: 43,
      height: 43,
      child: Image.asset(
        'assets/images/cookie_icon_new.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSkinPreview(String skinName) {
    // Customize skin preview based on skin name
    IconData iconData = Icons.pets;
    Color skinColor = Colors.purple;

    if (skinName.contains('Christmas')) {
      iconData = Icons.ac_unit;
      skinColor = Colors.red;
    } else if (skinName.contains('Summer')) {
      iconData = Icons.wb_sunny;
      skinColor = Colors.orange;
    } else if (skinName.contains('Spooky')) {
      iconData = Icons.nights_stay;
      skinColor = Colors.deepPurple;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 36, color: skinColor),
          const SizedBox(height: 5),
          Text(
            skinName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: skinColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, Map<String, dynamic> item) {
    // Check if this is a skin item or a cookie item
    final bool isSkin = item.containsKey('name');

    final String title =
        isSkin ? 'Buy ${item['name']}' : 'Buy ${item['count']} Cookies';

    final String content =
        isSkin
            ? 'Are you sure you want to purchase ${item['name']} for ${item['price']}?'
            : 'Are you sure you want to purchase ${item['count']} cookies for ${item['price']}?';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (isSkin) {
                    // Process skin purchase (placeholder for now)
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Successfully purchased ${item['name']}!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Process cookie purchase
                    final cookieProvider = Provider.of<CookieProvider>(
                      context,
                      listen: false,
                    );
                    cookieProvider.addCookies(item['count']);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Successfully purchased ${item['count']} cookies!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Buy'),
              ),
            ],
          ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Coming Soon'),
            content: const Text('This feature is coming soon. Stay tuned!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Cookie packages data
  final List<Map<String, dynamic>> _cookiePackages = [
    {'count': 1000, 'price': 'Rp1.699.999'},
    {'count': 500, 'price': 'Rp799.999'},
    {'count': 200, 'price': 'Rp349.999'},
    {'count': 100, 'price': 'Rp169.999'},
    {'count': 50, 'price': 'Rp89.999'},
    {'count': 40, 'price': 'Rp69.999'},
    {'count': 30, 'price': 'Rp49.999'},
    {'count': 20, 'price': 'Rp29.999'},
    {'count': 10, 'price': 'Rp19.999'},
  ];

  // Luna skins packages data (placeholder)
  final List<Map<String, dynamic>> _skinPackages = [
    {'name': 'Christmas Luna', 'price': 'Rp1.699.999', 'count': 0},
    {'name': 'Summer Luna', 'price': 'Rp799.999', 'count': 0},
    {'name': 'Spooky Luna', 'price': 'Rp349.999', 'count': 0},
  ];
}
