# Sistem Routing Modular Lunaria

## Struktur Folder Routes

```
lib/routes/
├── route_names.dart        # Konstanta nama routes
├── route_generator.dart    # Generator route berdasarkan nama
├── navigation_service.dart # Service untuk navigasi
├── app_router.dart        # Konfigurasi utama routing
└── routes.dart            # Export file untuk kemudahan import
```

## Penggunaan

### 1. Navigasi Bottom Navigation
```dart
// Di dalam screen yang menggunakan BottomNav
import '../../routes/routes.dart';

// Dalam onTap BottomNav
onTap: (index) {
  NavigationService.navigateToBottomNavScreen(context, index, _currentIndex);
}
```

### 2. Navigasi dengan Route Names
```dart
// Import routes
import 'package:lunaria/routes/routes.dart';

// Navigasi ke screen tertentu
NavigationService.navigateToCalendar();
NavigationService.navigateToTrain();
NavigationService.navigateToHome();
NavigationService.navigateToCommunity();
NavigationService.navigateToProfile();
NavigationService.navigateToLogin();
NavigationService.navigateToSignup();

// Atau dengan route name langsung
NavigationService.navigateToRoute(RouteNames.calendar);
NavigationService.navigateAndReplace(RouteNames.login);
NavigationService.navigateAndClearStack(RouteNames.home);
```

### 3. Navigasi dengan Arguments
```dart
NavigationService.navigateToRoute(
  RouteNames.profile, 
  arguments: {'userId': 123}
);
```

### 4. Navigation Control
```dart
// Kembali ke halaman sebelumnya
NavigationService.goBack();

// Kembali dengan result
NavigationService.goBack(result: {'status': 'success'});

// Check apakah bisa kembali
if (NavigationService.canPop()) {
  NavigationService.goBack();
}
```

## Keuntungan Sistem Routing Modular

### 1. **Centralized Navigation**
- Semua logika navigasi terpusat di folder `routes/`
- Mudah untuk maintenance dan debugging
- Konsistensi dalam naming dan structure

### 2. **Type Safety**
- Route names didefinisikan sebagai konstanta
- Mengurangi error karena typo nama route
- Intellisense support untuk navigation

### 3. **Flexible Transitions**
- Dapat mengatur animasi transisi untuk setiap jenis navigasi
- Bottom nav menggunakan transisi tanpa animasi
- Route navigation menggunakan fade transition

### 4. **Easy Testing**
- NavigationService dapat di-mock untuk testing
- Route generator mudah untuk di-unit test
- Clear separation of concerns

### 5. **Scalability**
- Mudah menambah route baru
- Support untuk nested routing
- Support untuk route arguments dan parameters

## Contoh Implementasi di Screen

```dart
import 'package:flutter/material.dart';
import '../../components/bottom_nav.dart';
import '../../routes/routes.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final int _currentIndex = NavigationIndex.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => NavigationService.navigateToProfile(),
            child: Text('Go to Profile'),
          ),
          ElevatedButton(
            onPressed: () => NavigationService.navigateAndReplace(RouteNames.login),
            child: Text('Login'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          NavigationService.navigateToBottomNavScreen(context, index, _currentIndex);
        },
      ),
    );
  }
}
```

## Best Practices

1. **Gunakan NavigationService** untuk semua navigasi
2. **Gunakan RouteNames** konstanta instead of hardcoded strings
3. **Gunakan NavigationIndex** untuk bottom navigation indices
4. **Hindari Navigator.push** langsung, gunakan NavigationService
5. **Gunakan navigateAndClearStack** untuk logout scenarios
6. **Test navigation flows** dengan unit tests
