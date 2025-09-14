# 🌙 Lunaria - AI-Powered Menstrual Health & Wellness Companion

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![AI](https://img.shields.io/badge/AI-Powered-purple?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

*Your personalized menstrual health companion powered by AI*

</div>

## ✨ About Lunaria

Lunaria is an innovative Flutter application that combines artificial intelligence with menstrual health tracking to provide personalized wellness experiences. Meet Luna 🐇, your virtual companion who understands your cycle and provides tailored recommendations for exercise, nutrition, and overall well-being.

### 🎯 Key Features

- **🤖 AI-Powered Analysis**: Advanced menstrual cycle prediction and health insights
- **🐰 Luna Virtual Assistant**: Interactive chat companion powered by Gemini AI
- **📅 Smart Calendar**: Intelligent cycle tracking with phase-based recommendations
- **🏃‍♀️ Personalized Workouts**: Exercise recommendations based on your cycle phase
- **💪 Fitness Tracking**: Comprehensive health monitoring and goal setting
- **👥 Community Support**: Connect with others on similar wellness journeys
- **📊 Health Analytics**: Detailed insights into your menstrual patterns and symptoms

## 🏗️ Architecture & Tech Stack

### Frontend
- **Flutter 3.x** - Cross-platform mobile development
- **Provider** - State management
- **Material Design 3** - Modern UI components

### Backend & Services
- **Supabase** - Authentication and database
- **Google Gemini AI** - Conversational AI for Luna
- **GitHub AI Service** - Additional AI capabilities
- **News API** - Health and wellness articles
- **YouTube API** - Fitness video content

### Key Dependencies
```yaml
flutter: 3.x
provider: ^6.1.2
supabase_flutter: ^2.5.6
google_generative_ai: ^0.4.3
http: ^1.2.1
shared_preferences: ^2.2.3
intl: ^0.19.0
```

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### 1. Clone the Repository
```bash
git clone https://github.com/dejanazul/lunaria.git
cd lunaria
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Configuration
Create a `.env` file in the root directory with the following variables:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_api_key
HF_INFERENCE_KEY=your_huggingface_key
HF_INFERENCE_URL=your_huggingface_inference_url
NEWS_API_KEY=your_news_api_key
NEWS_BASE_URL=your_news_base_url
YOUTUBE_API_KEY=your_youtube_api_key
GITHUB_API_KEY=your_github_api_key
```

### 4. VS Code Configuration (Recommended)
If using VS Code, create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "toolArgs": [
        "--dart-define=GEMINI_API_KEY=your_key",
        "--dart-define=SUPABASE_URL=your_url",
        "--dart-define=SUPABASE_ANON_KEY=your_key"
      ]
    }
  ]
}
```

### 5. Run the Application

#### Development Mode
```bash
flutter run --dart-define-from-file=env.json
```

#### Release Mode
```bash
flutter run --release --dart-define-from-file=env.json
```

#### Using Scripts (Recommended)
```bash
# Make scripts executable
chmod +x scripts/generate-env-dev.sh
chmod +x scripts/run-dev.sh

# Run development
./scripts/run-dev.sh
```

## 🎨 App Features Overview

### 🏠 Home Dashboard
- Welcome screen with Luna, your AI companion
- Quick access to cycle tracking and health metrics
- Personalized daily recommendations
- Cookie-based gamification system

### 📅 Smart Calendar
- Visual cycle tracking with color-coded phases
- Symptom logging and pattern recognition
- Predictive insights for upcoming cycles
- AI-powered menstrual cycle analysis

### 🤖 Luna AI Chat
- Natural language conversations about health
- Personalized advice based on your cycle data
- 24/7 support and encouragement
- Context-aware responses

### 🏃‍♀️ Fitness & Wellness
- Cycle-specific workout recommendations
- Video tutorials and exercise guides
- Progress tracking and achievements
- Personalized training programs

### 👥 Community & Profile
- Safe space for sharing experiences
- Customizable user profiles
- Typical day tracking
- Personal wellness journey

## 🔧 Development Setup

### Project Structure
```
lib/
├── authentication/     # Auth screens and profile management
├── providers/         # State management (Provider pattern)
├── screens/          # Main app screens
│   ├── calendar/     # Calendar and cycle tracking
│   ├── chat/         # Luna AI chat interface
│   └── train/        # Fitness and training screens
├── services/         # API and backend services
├── widgets/          # Reusable UI components
├── helpers/          # Utility functions
├── models/           # Data models
├── constants/        # App constants and themes
└── routes/           # Navigation configuration
```

### Key Providers
- **CalendarAiProvider**: Manages menstrual cycle analysis and AI insights
- **ChatHistoryProvider**: Handles Luna AI conversations and context
- **UserProvider**: Authentication and user data management
- **CookieProvider**: Gamification and reward system
- **LevelProvider**: User progression and achievements

### Services Architecture
- **GeminiService**: Google Gemini AI integration for Luna
- **GitHubAIService**: Additional AI capabilities
- **CalendarAIService**: Supabase integration for cycle data
- **AuthService**: User authentication and registration

## 🚀 Deployment

### Web Deployment (Vercel)
1. Build for web:
```bash
flutter build web --release --dart-define-from-file=env.json
```

2. Deploy using Vercel CLI:
```bash
vercel --prod
```

### Mobile App Deployment
```bash
# Android
flutter build apk --release --dart-define-from-file=env.json

# iOS
flutter build ios --release --dart-define-from-file=env.json
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/unit_tests/
flutter test test/widget_tests/
```

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Follow the existing code style and patterns
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
6. Push to the branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

### Code Style
- Follow Dart/Flutter best practices
- Use meaningful variable and function names
- Comment complex logic
- Maintain consistent formatting

## 📦 Build Scripts

The project includes helpful build scripts in the `scripts/` directory:

- `generate-env.sh`: Generate environment configuration
- `build.sh`: Production build script
- `run-dev.sh`: Development run script

## 🐛 Troubleshooting

### Common Issues

1. **Environment Variables Not Loading**
   - Ensure `.env` file exists in root directory
   - Check that all required variables are set
   - Verify `env.json` is generated correctly

2. **Supabase Connection Issues**
   - Verify SUPABASE_URL and SUPABASE_ANON_KEY
   - Check network connectivity
   - Ensure Supabase project is active

3. **AI Services Not Working**
   - Verify API keys are valid and have proper permissions
   - Check rate limits and quotas
   - Ensure network allows API calls

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Google Gemini** - For powering Luna's AI capabilities
- **Supabase** - For backend infrastructure and authentication
- **Samsung AI Program** - For inspiration and development support
- **Open Source Community** - For the incredible packages and tools

## 📞 Support & Contact

- **Issues**: Report bugs on [GitHub Issues](https://github.com/dejanazul/lunaria/issues)
- **Discussions**: Join our [GitHub Discussions](https://github.com/dejanazul/lunaria/discussions)
- **Developer**: [@dejanazul](https://github.com/dejanazul)

---

<div align="center">

**Made with ❤️ for women's health and wellness**

*Empowering women through AI-driven menstrual health insights*

**🌙 Lunaria - Where Technology Meets Feminine Wellness 🌙**

</div>
