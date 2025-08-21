# Bottom Navigation Component

## Overview
Bottom navigation component yang dibuat berdasarkan desain Figma dengan 5 tab navigasi dan floating center button.

## Features
- ✅ 5 tab navigation: Calendar, Train, Center (Paw), Community, Profile
- ✅ Active state dengan gradient color (#420D4A → #7B347E)
- ✅ Inactive state dengan gray color (#484C52)
- ✅ Floating center button dengan paw icon
- ✅ Home indicator untuk iPhone
- ✅ Responsive design
- ✅ Smooth transitions

## Usage

### Basic Implementation
```dart
import 'package:flutter/material.dart';
import '../components/bottom_nav.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(), // Your page content
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation to different pages
          _navigateToPage(index);
        },
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // Navigate to Calendar
        break;
      case 1:
        // Navigate to Train
        break;
      case 2:
        // Navigate to Paw Center
        break;
      case 3:
        // Navigate to Community
        break;
      case 4:
        // Navigate to Profile
        break;
    }
  }
}
```

### With PageView Navigation
```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  final List<Widget> _pages = [
    CalendarPage(),
    TrainPage(),
    PawCenterPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
```

## Properties

### BottomNav
| Property | Type | Description | Required |
|----------|------|-------------|----------|
| `currentIndex` | `int` | Index of currently active tab (0-4) | ✅ |
| `onTap` | `Function(int)` | Callback when tab is tapped | ✅ |

## Tab Indexes
- **0**: Calendar - Calendar icon with "Calendar" label
- **1**: Train - Fitness center icon with "Train" label  
- **2**: Paw Center - Special floating button with paw icon
- **3**: Community - People outline icon with "Community" label
- **4**: Profile - Person outline icon with "Profile" label

## Design Specifications

### Colors
- **Active State**: Gradient from #420D4A to #7B347E
- **Inactive State**: #484C52
- **Background**: #F5F6F7
- **Container**: #FFFFFF
- **Center Button**: Gradient background with white border

### Typography
- **Font Family**: Poppins
- **Active Text**: FontWeight.w500, 12px
- **Inactive Text**: FontWeight.w400, 12px
- **Line Height**: 1.33

### Dimensions
- **Total Height**: 99px
- **Center Button**: 63px diameter
- **Icon Size**: 24px
- **Border Radius**: 24px (top corners)
- **Home Indicator**: 134px × 5px

## Customization

### Custom Icons
To use custom icons, modify the icon properties in the `_buildNavItem` method:

```dart
// Replace Icons.calendar_month with your custom icon
icon: CustomIcons.calendar,
```

### Custom Colors
Update the colors in `/lib/constants/app_colors.dart`:

```dart
static const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
);
```

### Custom Labels
Modify the label strings in the component instantiation or create a constants file for labels.

## Dependencies
- `flutter/material.dart`
- `../constants/app_colors.dart`

## Files Structure
```
lib/
├── components/
│   └── bottom_nav.dart
├── constants/
│   └── app_colors.dart
└── screens/
    └── bottom_nav_demo.dart
```

## Demo
Run the demo with:
```bash
flutter run
```

The demo shows all 5 tabs with proper state management and visual feedback.
