# Lunaria Assets

This folder contains all assets (images, icons, fonts) extracted from the Figma design file for the Lunaria fitness app.

## 📁 Folder Structure

```
assets/
├── images/           # PNG/JPG images
│   ├── pet_illustration.png
│   ├── trainer_image_1.png
│   ├── trainer_image_2.png
│   ├── trainer_image_3.png
│   ├── trainer_image_4.png
│   ├── trainer_image_5.png
│   ├── trainer_image_6.png
│   └── trainer_image_7.png
└── icons/           # SVG icons
    ├── arrow_up.svg
    ├── barbell.svg
    ├── calendar.svg
    ├── calendar_outline.svg
    ├── check.svg
    ├── check_rounded.svg
    ├── fullscreen.svg
    ├── message_add.svg
    ├── message_filled.svg
    ├── next.svg
    ├── paw.svg
    ├── people_outline.svg
    ├── person.svg
    ├── person_sharp.svg
    ├── play_fill.svg
    ├── plus.svg
    └── setting_outlined.svg
```

## 🎨 Design System

All assets follow the Lunaria design system:

### Color Palette
- **Primary**: #913F9E (Purple)
- **Secondary**: #C774B2 (Pink)
- **Accent**: #7B347E (Dark Purple)
- **Background**: #F4D5E0 (Light Pink)
- **Text**: #210535 (Dark Purple)

### Icons
- **Format**: SVG (vector, scalable)
- **Style**: Outline and filled variants
- **Size**: Optimized for 24x24px base size
- **Color**: Monochrome (can be tinted programmatically)

### Images
- **Format**: PNG with transparency support
- **Trainer Images**: 500x500px high quality
- **Pet Illustration**: 256x256px optimized
- **Optimization**: Compressed for mobile usage

## 📱 Usage in Flutter

### Import Assets
```dart
import 'package:lunaria/constants/app_constants.dart';
```

### Using Icons
```dart
// SVG Icon
SvgPicture.asset(
  AppAssets.iconCalendar,
  width: 24,
  height: 24,
  color: AppColors.primary,
)

// Navigation Icon
Icon(Icons.calendar_today) // Fallback for system icons
```

### Using Images
```dart
// Network/Asset Image
Image.asset(
  AppAssets.imageTrainer1,
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)

// Circular Avatar
CircleAvatar(
  radius: 30,
  backgroundImage: AssetImage(AppAssets.imageTrainer2),
)
```

### Using Colors
```dart
// Background Color
Container(
  color: AppColors.background,
  child: ...,
)

// Gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
  child: ...,
)
```

### Using Text Styles
```dart
// Heading
Text(
  'Welcome Back!',
  style: AppTextStyles.h2,
)

// Body Text
Text(
  'Your fitness journey continues...',
  style: AppTextStyles.bodyMedium,
)

// Button Text
Text(
  'Get Started',
  style: AppTextStyles.buttonLarge,
)
```

## 🔧 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_svg: ^2.0.9  # For SVG icons

assets:
  - assets/images/
  - assets/icons/

fonts:
  - family: Poppins
    fonts:
      - asset: fonts/Poppins-Regular.ttf
      - asset: fonts/Poppins-Medium.ttf
        weight: 500
      - asset: fonts/Poppins-SemiBold.ttf
        weight: 600
      - asset: fonts/Poppins-Bold.ttf
        weight: 700
```

## 📋 Asset Guidelines

### Icons
1. **Naming**: Use snake_case (e.g., `arrow_up.svg`)
2. **Size**: Base size 24x24px, scalable
3. **Format**: SVG preferred for scalability
4. **Color**: Single color, use Flutter tinting

### Images
1. **Naming**: Descriptive names (e.g., `trainer_image_1.png`)
2. **Format**: PNG with transparency, JPG for photos
3. **Size**: Optimize for mobile (compress when possible)
4. **Quality**: Balance between quality and file size

### Best Practices
- Use `AppAssets` constants instead of hardcoded paths
- Implement proper error handling for missing assets
- Consider device pixel ratio for high-DPI displays
- Cache images appropriately for performance

## 🎯 Figma Source

These assets were extracted from the official Lunaria Figma design file:
- **File**: SAMSUNG Design System
- **URL**: [Figma Link](https://www.figma.com/design/ea1YY0zs0lWgnrLT8qeBm4/SAMSUNG)
- **Last Updated**: August 21, 2025

## 📝 Notes

- All assets maintain the original design intent from Figma
- Colors and typography follow the established design system
- Assets are optimized for mobile performance
- SVG icons can be tinted to match theme colors
- Trainer images represent diverse fitness professionals

For any questions about assets or design system, refer to the Figma source file or the app's design documentation.
