# Migration Guide: Schedule Feature Refactoring

## Summary
The Schedule feature has been completely refactored from a single 989-line file into a clean, maintainable architecture with 29 focused files.

## Before vs After

### Before
```
trainer_home_schedule_screen.dart (989 lines)
├── Models (mixed in)
├── Main Screen (800+ lines)
├── App Bar Widget
├── Summary Card Widget
├── Timeline Section Widget
├── Mini Calendar Widget
├── Empty State Widget
├── Session Card Widget
└── Session Details Screen (250+ lines)
```

### After
```
schedule/
├── domain/ (Business Logic)
│   ├── entities/ (2 files)
│   ├── repositories/ (1 file)
│   └── usecases/ (5 files)
├── data/ (Data Handling)
│   ├── models/ (2 files)
│   ├── data_sources/ (4 files)
│   └── repositories/ (1 file)
├── presentation/ (UI Layer)
│   ├── bindings/ (1 file)
│   ├── controllers/ (1 file)
│   ├── screens/ (1 file)
│   └── widgets/components/ (10 files)
└── Documentation
    ├── schedule.dart (exports)
    └── README.md
```

## Key Improvements

### 1. Clean Architecture
- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Each component can be tested independently
- **Maintainability**: Easy to find and modify specific functionality
- **Scalability**: Easy to add new features without breaking existing code

### 2. Component-Based UI
- **Reusability**: Components can be used across the app
- **Composability**: Complex UIs built from simple parts
- **Readability**: Each component is < 200 lines
- **Consistency**: Shared design system

### 3. State Management
- **GetX Controller**: Centralized state management
- **Reactive Programming**: Automatic UI updates
- **Business Logic**: Moved out of UI widgets

### 4. Dependency Injection
- **GetX Binding**: Centralized dependency registration
- **Lazy Loading**: Efficient resource usage
- **Testability**: Easy to mock dependencies

## File-by-File Migration

### Domain Layer (New)

#### `domain/entities/session_entity.dart`
**Purpose**: Core business object for a session
**Migration**: Extracted from inline class in old file
**Changes**:
- Added helper methods (dateLabel, shortDateLabel, monthLabel)
- Added computed properties (isVirtual, sessionTitle)
- Made immutable with `const` constructor

#### `domain/entities/schedule_summary_entity.dart`
**Purpose**: Statistics for schedule summary
**Migration**: Extracted from state variables
**Changes**:
- Added totalSessions and upcomingSessions fields
- Made immutable

#### `domain/repositories/schedule_repository.dart`
**Purpose**: Defines data operations contract
**Migration**: New abstraction
**Changes**:
- Defines all data operations as interfaces
- No implementation details

#### `domain/usecases/*.dart`
**Purpose**: Encapsulate specific business operations
**Migration**: New layer
**Files**:
- `get_sessions_for_date_usecase.dart`
- `get_schedule_summary_usecase.dart`
- `get_session_details_usecase.dart`
- `cancel_session_usecase.dart`
- `reschedule_session_usecase.dart`

### Data Layer (New)

#### `data/models/session_model.dart`
**Purpose**: Data transfer object with serialization
**Migration**: Extended from SessionEntity
**Changes**:
- Added `fromJson` and `toJson` methods
- Added `copyWith` method
- Added imageUrl and metadata fields

#### `data/models/schedule_summary_model.dart`
**Purpose**: Data transfer object for summary
**Migration**: Extended from ScheduleSummaryEntity
**Changes**:
- Added serialization support

#### `data/data_sources/schedule_remote_data_source.dart`
**Purpose**: Abstract interface for remote data
**Migration**: New abstraction
**Changes**:
- Defines API operations

#### `data/data_sources/schedule_remote_data_source_impl.dart`
**Purpose**: Actual API implementation
**Migration**: Contains mock data from old file
**Changes**:
- Mock data clearly marked for replacement
- Ready for API integration

#### `data/data_sources/schedule_local_data_source.dart`
**Purpose**: Abstract interface for local data
**Migration**: New abstraction

#### `data/data_sources/schedule_local_data_source_impl.dart`
**Purpose**: SharedPreferences implementation
**Migration**: New feature
**Changes**:
- Caching support
- Offline-first architecture

#### `data/repositories/schedule_repository_impl.dart`
**Purpose**: Bridge between domain and data
**Migration**: Implements domain interface
**Changes**:
- Combines remote and local data sources
- Error handling and fallback logic

### Presentation Layer (Refactored)

#### `presentation/bindings/schedule_binding.dart`
**Purpose**: Dependency injection configuration
**Migration**: New feature
**Changes**:
- Registers all dependencies
- Lazy loading for efficiency

#### `presentation/controllers/schedule_controller.dart`
**Purpose**: State management and business logic
**Migration**: Extracted from `_ScheduleScreenState`
**Changes**:
- Moved from StatefulWidget state to GetX controller
- Added reactive properties (Rx)
- Encapsulated use cases
- Better testability

#### `presentation/screens/trainer_home_schedule_screen.dart`
**Purpose**: Main screen composition
**Migration**: Refactored from 800+ lines to < 300 lines
**Changes**:
- Removed business logic (moved to controller)
- Uses component widgets
- Reactive with Obx
- Cleaner, more readable

#### `presentation/widgets/components/` (10 files)
**Purpose**: Reusable UI components
**Migration**: Broken down from monolithic widgets

**Component Mapping**:

| Old Widget | New Components |
|------------|----------------|
| `_TrainerAppBar` | `trainer_app_bar.dart` |
| `_ScheduleSummaryCard` | `schedule_summary_card.dart` |
| `_ScheduleTimelineSection` | `schedule_timeline_section.dart` |
| `_MiniCalendar` | `mini_calendar.dart` |
| `_EmptySchedule` | `empty_schedule.dart` |
| `_SessionCard` | `session_card.dart` |
| `_AiNoteBox` | (merged into session_card.dart) |
| `_OutlineActionBtn` | (merged into session_card.dart) |
| Session Details UI | `session_info_header.dart`, `session_info_card.dart`, `client_info_card.dart` |

**New Sub-components**:
- `WeekStrip`: Horizontal day selector
- `DaySelectorItem`: Individual day item
- `TimelineIconBtn`: View toggle buttons
- `CalendarDayItem`: Calendar day cell
- `SessionDateColumn`: Date/time display
- `ActionButton`: Call/message button
- `_ClientOnlineBadge`: Online status
- `_OnlineStatusBadge`: Header online status
- `_NotificationIcon`: Notification badge
- `SessionIdCard`: Session ID display

## Usage Examples

### Before (Old Way)
```dart
// Everything in one file
// Hard to test
// Mixed concerns
class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 3;
  List<_Session> _sessions = [];
  
  void _loadSessions() {
    // Direct data access
    // Mixed with UI logic
  }
}
```

### After (Clean Way)
```dart
// Screen (UI only)
class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
      builder: (controller) => Column(
        children: [
          TrainerAppBar(...),
          ScheduleSummaryCard(...),
          // Components are reusable
        ],
      ),
    );
  }
}

// Controller (State & Logic)
class ScheduleController extends GetxController {
  final ScheduleRepository repository;
  final RxList<SessionEntity> sessions = [].obs;
  
  Future<void> loadSchedule() async {
    // Uses use cases
    // Pure business logic
  }
}

// Use Case (Single Responsibility)
class GetSessionsForDateUseCase {
  Future<List<SessionEntity>> call(DateTime date) {
    return repository.getSessionsForDate(date);
  }
}
```

## Testing Strategy

### Unit Tests (Domain Layer)
```dart
// test/domain/usecases/get_sessions_for_date_usecase_test.dart
test('should return sessions for date', () async {
  final repo = MockScheduleRepository();
  final usecase = GetSessionsForDateUseCase(repo);
  
  when(repo.getSessionsForDate(any))
    .thenAnswer((_) async => [testSession]);
  
  final result = await usecase(DateTime.now());
  
  expect(result.length, 1);
});
```

### Widget Tests (Components)
```dart
// test/widgets/components/session_card_test.dart
testWidgets('displays client name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SessionCard(session: testSession),
    ),
  );
  
  expect(find.text('Client: Smith III'), findsOneWidget);
});
```

### Integration Tests (Screens)
```dart
// test/screens/schedule_screen_test.dart
testWidgets('loads and displays sessions', (tester) async {
  final controller = MockScheduleController();
  
  await tester.pumpWidget(
    GetMaterialApp(
      initialBinding: ScheduleBinding(),
      home: ScheduleScreen(),
    ),
  );
  
  await tester.pumpAndSettle();
  
  expect(find.byType(SessionCard), findsWidgets);
});
```

## Benefits Realized

### Code Metrics
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Total Lines | 989 | ~2500 | More explicit |
| Longest File | 989 | 297 | 70% reduction |
| Avg File Size | 989 | ~86 | 91% reduction |
| Components | 8 | 18 | 125% increase |
| Test Coverage | 0% | Ready | 100% potential |

### Developer Experience
- ✅ **Findability**: Know exactly where each file is
- ✅ **Readability**: Each file has single purpose
- ✅ **Maintainability**: Changes are localized
- ✅ **Testability**: Each layer can be tested
- ✅ **Scalability**: Easy to add features

## Next Steps

1. **Update Imports**: Update any files importing the old file
   ```dart
   // Old import
   import 'package:.../features/trainer/schedule/presentation/trainer_home_schedule_screen.dart';
   
   // New import
   import 'package:.../features/trainer/schedule/schedule.dart';
   ```

2. **Register Binding**: Add to your app initialization
   ```dart
   Get.put(ScheduleBinding());
   ```

3. **Add Tests**: Start with domain layer tests

4. **API Integration**: Replace mock data in remote data source

5. **Code Review**: Team review of new structure

## Rollback Plan

If you need to rollback:
1. The old file is backed up (if you kept it)
2. Restore from git history
3. Revert commit

## Questions?

Refer to:
- `README.md` - Architecture documentation
- `schedule.dart` - All exports
- Individual component files - Inline documentation
