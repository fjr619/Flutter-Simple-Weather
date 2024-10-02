# Weather App

A simple Flutter application that fetches weather data from the [OpenWeather API](https://openweathermap.org/) using Clean Architecture principles and Cubit for state management.

## ✨ Features
- Fetches current weather data based on location using OpenWeather API.
- State management with Cubit (part of Flutter Bloc package).
- Uses Dio for API requests.
- Geolocation to fetch the user's current location.
- Simple animations using Lottie.
- Custom fonts from Google Fonts.

## 🧩 Tech Stack
- flutter_bloc: State management using Cubit.
- dio: For making API requests.
- geolocator: To fetch the current location.
- get_it: Dependency injection management.
- injectable: Code generation for dependency injection.
- lottie: For adding animations.
- google_fonts: Custom fonts from Google Fonts.

## 🛠️ Installation
- Clone the Repository
- Setup Flutter and Dart SDK
- 0pen the project in Android Studio/ Vs Code with Flutter and Dart Extension
- Install Dependencies: After navigating to the project folder, install the necessary packages:
  ```
  flutter pub get
  ```
- Generate dependency injection files
  ```
  dart run build_runner build
  ```
- Create a .env file in the root of the project and add your API key and base URL.
  ```
  BASE_URL=https://api.openweathermap.org/data/2.5/
  API_KEY=YOUR_API_KEY
  ```
- Run the App

## 📧 Contact
If you have any questions, feel free to reach out!
- Email: frank.jr.619@gmail.com
- GitHub: [@fjr619](https://github.com/fjr619)
- LinkedIn [franky-wijanarko](https://id.linkedin.com/in/franky-wijanarko)