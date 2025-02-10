lib/
├── main.dart                # Entry point
├── app.dart                 # Handles routing & global providers
│
├── core/                    # Core utilities shared across features
│   ├── services/            # Firebase, API calls, local storage
│   │   ├── firebase_service.dart
│   │   ├── stripe_service.dart
│   ├── theme/               # Theme & styles
│   │   ├── app_theme.dart
│   ├── utils/               # Helper functions, formatters, validators
│   │   ├── validators.dart
│   │   ├── app_constants.dart
│   ├── config/              # App configurations
│   │   ├── firebase_options.dart
│   │   ├── app_config.dart
│
├── data/                    # Data layer (models, repositories, sources)
│   ├── models/              # Data models (User, Hotel, Booking, etc.)
│   │   ├── user_model.dart
│   │   ├── hotel_model.dart
│   ├── repositories/        # Handles business logic and data fetching
│   │   ├── user_repository.dart
│   │   ├── hotel_repository.dart
│   ├── sources/             # API sources (Firestore, REST APIs, Local DB)
│   │   ├── firestore_source.dart
│   │   ├── local_db_source.dart
│
├── domain/                  # Business logic layer (UseCases & Entities)
│   ├── entities/            # Core business objects
│   │   ├── user.dart
│   │   ├── hotel.dart
│   ├── usecases/            # Handles complex business logic
│   │   ├── get_hotels.dart
│   │   ├── book_hotel.dart
│
├── presentation/            # UI Layer (Screens, Widgets, State Management)
│   ├── features/            # Feature-based separation
│   │   ├── authentication/  # Login, Signup
│   │   │   ├── screens/     # UI Screens
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   ├── state/       # Bloc, Provider, or Riverpod state management
│   │   │   │   ├── auth_bloc.dart
│   │   │   ├── widgets/     # Feature-specific widgets
│   │   │   │   ├── login_form.dart
│   │   ├── home/            # Home module
│   │   │   ├── screens/
│   │   │   ├── state/
│   │   │   ├── widgets/
│   │   ├── bookings/        # Hotel & Taxi Booking module
│   │   │   ├── screens/
│   │   │   ├── state/
│   │   │   ├── widgets/
│
├── widgets/                 # Global reusable UI components
│   ├── buttons/             # Reusable buttons
│   │   ├── primary_button.dart
│   ├── textfields/          # Custom input fields
│   │   ├── custom_textfield.dart
│   ├── dialogs/             # Custom dialogs & alerts
│   │   ├── confirmation_dialog.dart
│   ├── cards/               # Custom reusable cards
│   │   ├── hotel_card.dart
│   ├── loaders/             # Loading animations
│   │   ├── custom_loader.dart
│
├── routing/                 # Navigation & route management
│   ├── app_routes.dart
│
├── localisation/            # Multi-language support (JSON files)
│   ├── en.json
│   ├── es.json
│
└── pubspec.yaml             # Dependencies & configurations
