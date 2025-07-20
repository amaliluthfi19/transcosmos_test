# Al-Quran App - Transcosmos Test

A Flutter application for reading and listening to Quran surahs

## Features
- **See all surah**
- **Read Details of Surah**
- **Listen Surah**

### 📁 Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── constants/          # App constants
│   ├── routes/             # Route definitions
│   ├── theme/              # App themes
│   └── utils/              # Utility classes
├── data/                   # Data layer
│   ├── rest_clients/       # Data sources (API, Local)
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
└──  presentations/         # Presentation layer
    | 
    ├── feature_name/
    |   ├── bindings/         # GetX dependency bindings
    │   ├── controllers/      # GetX controllers
    │   ├── screens/          # UI screens
    │   └── widgets/          # Reusable widgets
    └── shared/               # Shared components
        ├── models/           # Shared models
        └── widgets/          # Shared widgets
```

## Getting Started

### Prerequisites
- Flutter SDK (3.29.2)
- Dart SDK (3.7.2)
- VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd transcosmos_test
   ```
2. **Install FVM**
  - you can see how to install in https://fvm.app/documentation/getting-started/installation

3. **Install Flutter SDK Via FVM**
  - you can install Flutter SDK Version like this:
  ```bash
  fvm install 3.29.2
  ```
4. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```
5. **Run the application**
  - click run adn debug on VS Code or
  ```bash
  fvm flutter run
  ```

### Adding New Features

1. **Create Entity** in `lib/domain/entities/`
2. **Define Repository Interface** in `lib/domain/repositories/`
3. **Create Use Cases** in `lib/domain/usecases/`
4. **Implement Data Layer** in `lib/data/`
5. **Create New Feature Folder** in `lib/presentations/`
5. **Create Controller** in `lib/presenttions/feature_name/controllers/`
6. **Build UI** in `lib/presentations/feature_name/screens/`
7. **Add Binding** in `lib/presentations/feature_name/bindings/`

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



