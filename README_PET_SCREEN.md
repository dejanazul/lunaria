# Pet Home Screen (VPHome)

## Overview
This is the Virtual Pet home screen for the Lunaria app, built based on the Figma design specifications. The screen features a virtual pet character with interactive elements and a modern UI design.

## Features

### Visual Elements
- **Gradient Background**: Purple gradient from `#420D4A` to `#7B347E`
- **Pet Character**: Main character image with background scene
- **Status Bar**: iPhone-style status bar showing time (9:41), signal, WiFi, and battery
- **Level Indicator**: Shows current pet level (Level 2) with progress bar
- **Cookie Counter**: Displays collected cookies count (10)
- **Settings Button**: Three-dot menu button in top right
- **Mood Button**: Plus icon for adding moods
- **Message Bubble**: Pet's speech bubble with "Hop hop! 🐇 I'm so glad you're here!"
- **Bottom Navigation**: Five-tab navigation with Pet tab highlighted

### Assets Used
- `pet_background-4faf77.png` - Background scene (cropped from Figma)
- `pet_main_image.png` - Main pet character (1563x1563)
- `level_icon-13139c.png` - Level indicator icon (cropped from Figma)
- `cookie_icon.png` - Cookie icon (500x500)

### Design Specifications
- **Screen Size**: 390x844 (iPhone 13 style)
- **Font Family**: Poppins
- **Primary Color**: `#913F9E`
- **Secondary Color**: `#7B347E`
- **Background Colors**: Various shades for UI elements

### Key Components
1. **Status Bar**: Shows time and system icons
2. **Level System**: Progress bar with level 2 indicator
3. **Cookie System**: Cookie counter with icon
4. **Settings**: Accessible via three-dot menu
5. **Mood Tracker**: Plus button for mood interactions
6. **Pet Communication**: Speech bubble for pet messages
7. **Navigation**: Bottom tab navigation

### Implementation Details
- Built with Flutter using Stack layout for precise positioning
- Custom painter for message bubble tail
- Responsive design following Figma specifications
- Integration with existing app navigation system

### File Structure
```
lib/screens/home_pet/
└── vp_home.dart        # Main VPHome screen implementation

assets/images/
├── pet_background-4faf77.png
├── pet_main_image.png
├── level_icon-13139c.png
└── cookie_icon.png
```

### Usage
```dart
import 'package:lunaria/screens/home_pet/vp_home.dart';

// Navigate to pet home screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const VPHomeScreen()),
);
```

### Demo
Run `flutter run lib/pet_demo.dart` to see the screen in action.

## Notes
- All measurements and colors match the original Figma design
- Images were extracted directly from Figma using the mcp_figma tools
- The screen is fully responsive and ready for production use
- Bottom navigation integrates with the existing app structure
