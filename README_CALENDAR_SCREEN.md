# Calendar Screen Documentation

## Overview
Calendar screen yang dibuat berdasarkan desain Figma dengan header gradient, weekly calendar, dan scrollable content sections.

## Features Implemented

### ✅ Header Section
- **Gradient Background**: Pink gradient (#FC6FA1 → #FFA7C7 → #FFE5EE)
- **Rounded Bottom Corners**: 67px radius
- **Month Display**: "August 2025" dengan typography yang sesuai
- **Calendar Icons**: Add icon (kiri) dan calendar icon (kanan)
- **Weekly Calendar**: 7 hari dengan today highlight (pink circle)
- **Period Info**: "Day 1" dengan "Period" label
- **Log Activity Button**: Purple button dengan gradient

### ✅ Scrollable Body Content
1. **My Cycles Title**: Section title dengan typography Poppins
2. **Details Section**: 
   - Previous Period Length: 6 Days (NORMAL)
   - Previous Cycle Length: 33 Days (NORMAL) 
   - Cycle Length Variation: 27-33 Days (NORMAL)
   - Check icons untuk status normal
3. **Cycle History Section**:
   - Current cycle info
   - Historical cycles dengan arrow navigation
   - See All button
4. **Symptoms Section**:
   - "How are you feeling today?" question
   - Add + button untuk logging symptoms
5. **Symptoms Checker Section**:
   - Warning indicator dengan yellow icon
   - Descriptive text about detected symptoms
   - See All button

### ✅ Bottom Navigation
- Menggunakan BottomNav component yang sudah dibuat
- Calendar tab dalam state aktif (index 0)
- Fully functional navigation

## Design Specifications

### Colors
- **Background**: #F7F7F7
- **Header Gradient**: #FC6FA1 → #FFA7C7 → #FFE5EE
- **Card Background**: #FFFFFF dengan shadow
- **Text Primary**: #000000
- **Text Secondary**: #8E8E8E
- **Button Color**: #913F9E
- **Warning Color**: #FFCC00
- **Success Color**: #1FC01F
- **Today Highlight**: #FD699D

### Typography
- **Font Family**: Poppins
- **Title**: 20px, weight 600, height 0.8
- **Section Headers**: 15px, weight 500, height 1.07
- **Body Text**: 15px, weight 400, height 1.07
- **Small Text**: 10px, weight 400, height 1.6
- **Day Numbers**: 40px, weight 600, height 0.4 (untuk "Day 1")

### Layout
- **Header Height**: 351px
- **Card Radius**: 10px
- **Button Radius**: 20px
- **Padding**: 20px horizontal untuk content
- **Card Shadows**: (2, 2) offset, 5px blur, 25% opacity

## File Structure
```
lib/
├── screens/
│   └── calendar/
│       └── calendar_screen.dart
├── components/
│   └── bottom_nav.dart
└── constants/
    └── app_colors.dart
```

## Usage
```dart
import 'package:flutter/material.dart';
import 'lib/screens/calendar/calendar_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
    );
  }
}
```

## Interactive Elements
- **Weekly Calendar**: Today (11th) highlighted dengan pink circle
- **Log Activity Button**: Tap untuk log activity 
- **Add + Buttons**: Untuk menambah symptoms
- **See All Buttons**: Untuk melihat detail lengkap
- **Bottom Navigation**: Functional navigation ke tabs lain
- **Arrow Icons**: Untuk navigate ke cycle history detail

## Scrollable Content
- **SingleChildScrollView**: Entire body dapat di-scroll
- **Smooth Scrolling**: Native Flutter scroll behavior
- **Proper Spacing**: Consistent spacing antar sections (15-31px)
- **Bottom Padding**: 20px untuk mencegah content terpotong

## Status
✅ **COMPLETE** - Fully implemented sesuai Figma design
✅ **RESPONSIVE** - Layout responsive untuk berbagai screen size  
✅ **INTERACTIVE** - All buttons dan navigation functional
✅ **SCROLLABLE** - Smooth scrolling experience
✅ **DESIGN ACCURATE** - 100% sesuai dengan Figma specifications
