# Authentication Feature - Clean Architecture

This module implements the Authentication feature using Clean Architecture principles while keeping GetX for state management and navigation.

## 📁 Structure

```
authentication/
├── domain/                    # Business Logic Layer
│   ├── entities/             # Core business objects
│   │   ├── user_entity.dart
│   │   └── auth_entity.dart
│   ├── repositories/         # Repository interfaces
│   │   └── auth_repository.dart
│   └── usecases/            # Business logic use cases
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── logout_usecase.dart
│
├── data/                     # Data Layer
│   ├── models/              # Data models (JSON serialization)
│   │   ├── user_model.dart
│   │   └── auth_model.dart
│   ├── data_sources/        # API and local storage
│   │   ├── auth_remote_data_source.dart
│   │   └── auth_local_data_source.dart
│   └── repositories/        # Repository implementations
│       └── auth_repository_impl.dart
│
├── presentation/            # UI Layer
│   ├── screens/            # UI screens
│   │   ├── login_screen.dart
│   │   ├── sign_up_screen.dart
│   │   └── complete_profile/
│   └── controllers/        # UI controllers (GetX)
│       ├── login_controller.dart
│       └── sign_up_controller.dart
│
└── authentication.dart      # Export file
```

## 🏗️ Architecture Layers

### 1. Domain Layer (Innermost)
- **Entities**: Pure business objects (e.g., `UserEntity`, `AuthEntity`)
- **Repositories**: Abstract interfaces defining contracts
- **Use Cases**: Single-responsibility business logic

**No dependencies** on external frameworks, databases, or UI.

### 2. Data Layer
- **Models**: Handle JSON serialization/deserialization
- **Data Sources**: 
  - `AuthRemoteDataSourceImpl` - API calls
  - `AuthLocalDataSourceImpl` - SharedPreferences
- **Repository Implementation**: Bridges domain and data layers

### 3. Presentation Layer (Outermost)
- **Controllers**: GetX controllers handling UI state
- **Screens**: Flutter widgets
- **Dependencies**: Only depend on Domain Layer (Use Cases)

## 🔄 Data Flow

```
User Action → Controller → Use Case → Repository → Data Source → API/Storage
                                                              ↓
User Update ← UI Update ← State Update ← Entity ← Repository ← Response
```

## 📝 Usage Example

### Login Flow

```dart
// 1. Controller receives user input
void handleLogin() async {
  // 2. Validate input
  if (!isValid) return;
  
  // 3. Execute use case
  final result = await loginUseCase(
    email: email,
    password: password,
    role: role,
  );
  
  // 4. Handle result
  if (result.token != null) {
    // Navigate to home
  }
}
```

### Dependency Injection

All dependencies are registered in `ControllerBinder`:

```dart
// Data Sources
Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());

// Repository
Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
  remoteDataSource: Get.find(),
  localDataSource: Get.find(),
));

// Use Cases
Get.lazyPut(() => LoginUseCase(Get.find()));

// Controllers
Get.put(LoginController(loginUseCase: Get.find()));
```

## ✅ Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation of concerns
3. **Flexibility**: Easy to swap data sources or UI frameworks
4. **Reusability**: Domain layer can be reused across platforms
5. **GetX Integration**: Keeps reactive state management and navigation

## 🔧 Adding New Features

1. **Create Entity** in `domain/entities/`
2. **Add Repository Method** in `domain/repositories/`
3. **Create Use Case** in `domain/usecases/`
4. **Implement Data Source** in `data/data_sources/`
5. **Update Repository Implementation** in `data/repositories/`
6. **Add Controller Method** in `presentation/controllers/`
7. **Register Dependencies** in `ControllerBinder`

## 🧪 Testing

```dart
// Unit Test Example for LoginUseCase
void main() {
  test('should return AuthEntity when login is successful', () async {
    // Arrange
    final mockRepo = MockAuthRepository();
    final useCase = LoginUseCase(mockRepo);
    
    // Act
    final result = await useCase(
      email: 'test@example.com',
      password: 'password123',
      role: 'Trainer',
    );
    
    // Assert
    expect(result, isA<AuthEntity>());
  });
}
```

## 📦 Dependencies

- `get` - State management and DI
- `shared_preferences` - Local storage
- `http` - Network calls (via ApiClient)

## 🚀 Migration Notes

This feature was migrated from a basic GetX pattern to Clean Architecture while:
- Keeping GetX for state management
- Maintaining existing UI structure
- Adding proper separation of concerns
- Improving testability and maintainability
