# Al-Quran App - Clean Architecture with GetX

A Flutter application for reading and listening to Quran surahs, built with Clean Architecture principles and GetX for state management.

### 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── routes/             # Route definitions
│   ├── theme/              # App themes
│   └── utils/              # Utility classes
├── data/                   # Data layer
│   ├── datasources/        # Data sources (API, Local)
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── features/
|   | 
|   ├── feature/
|   | ├── domain/                 # Domain layer
│   | ├── entities/           # Business entities
│   | ├── repositories/       # Repository interfaces
│   | ├── usecases/           # Business logic use cases
|     ├── presentation/           # Presentation layer
│   ├── bindings/           # GetX dependency bindings
│   ├── controllers/        # GetX controllers
│   ├── screens/            # UI screens
│   └── widgets/            # Reusable widgets
└── shared/                 # Shared components
    ├── models/             # Shared models
    └── widgets/            # Shared widgets
```

## 🎯 Clean Architecture Layers

### 1. **Presentation Layer** (`lib/presentation/`)
- **Controllers**: GetX controllers for state management
- **Screens**: UI screens and pages
- **Widgets**: Reusable UI components
- **Bindings**: Dependency injection setup

### 2. **Domain Layer** (`lib/domain/`)
- **Entities**: Core business objects
- **Use Cases**: Business logic and rules
- **Repository Interfaces**: Abstract data access contracts

### 3. **Data Layer** (`lib/data/`)
- **Data Sources**: API and local data access
- **Models**: Data transfer objects
- **Repository Implementations**: Concrete data access

### 4. **Core Layer** (`lib/core/`)
- **Constants**: App-wide constants
- **Utils**: Utility functions and helpers
- **Theme**: App theming configuration
- **Routes**: Navigation setup

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd transcosmos_test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### State Management
- **GetX**: For state management, dependency injection, and routing

### UI
- **Google Fonts**: Custom typography
- **Material Design**: UI components

### Network
- **HTTP**: API communication

## 🔧 Key Features

### GetX Integration
- **Reactive State Management**: Using `Rx` variables and `Obx` widgets
- **Dependency Injection**: Automatic dependency management with bindings
- **Route Management**: Declarative routing with GetX

### Clean Architecture Benefits
- **Separation of Concerns**: Clear layer boundaries
- **Testability**: Easy to unit test each layer
- **Maintainability**: Scalable and organized codebase
- **Independence**: Domain layer independent of external frameworks

## 📱 Features

- **User Management**: Display and manage user information
- **Reactive UI**: Real-time UI updates with GetX
- **Error Handling**: Comprehensive error handling and display
- **Loading States**: Loading indicators for better UX
- **Theme Support**: Light and dark theme support

## 🧪 Testing

The architecture is designed to be easily testable:

```dart
// Example: Testing a use case
void main() {
  group('GetUserUseCase', () {
    late MockUserRepository mockRepository;
    late GetUserUseCase useCase;

    setUp(() {
      mockRepository = MockUserRepository();
      useCase = GetUserUseCase(mockRepository);
    });

    test('should return user when repository call is successful', () async {
      // Test implementation
    });
  });
}
```

## 📋 API Configuration

Update the API configuration in `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  static const String baseUrl = 'https://your-api-url.com';
  // ... other constants
}
```

## 🎨 Customization

### Adding New Features

1. **Create Entity** in `lib/domain/entities/`
2. **Define Repository Interface** in `lib/domain/repositories/`
3. **Create Use Cases** in `lib/domain/usecases/`
4. **Implement Data Layer** in `lib/data/`
5. **Create Controller** in `lib/presentation/controllers/`
6. **Build UI** in `lib/presentation/screens/`
7. **Add Binding** in `lib/presentation/bindings/`

### Example: Adding a Product Feature

```dart
// 1. Entity
class Product {
  final String id;
  final String name;
  final double price;
  // ...
}

// 2. Repository Interface
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  // ...
}

// 3. Use Case
class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);
  
  Future<List<Product>> execute() => repository.getProducts();
}

// 4. Controller
class ProductController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final RxList<Product> products = <Product>[].obs;
  
  // Implementation...
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the clean architecture principles
4. Add tests for new features
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions, please open an issue in the repository.



