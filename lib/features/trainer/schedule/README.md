# Schedule Feature - Clean Architecture

## Overview
This feature has been refactored to follow **Clean Architecture** principles with **component-based UI** design.

## Architecture Layers

```
lib/features/trainer/schedule/
├── domain/                          # Business Logic Layer
│   ├── entities/                    # Core business objects
│   │   ├── session_entity.dart
│   │   └── schedule_summary_entity.dart
│   ├── repositories/                # Repository interfaces
│   │   └── schedule_repository.dart
│   └── usecases/                    # Business use cases
│       ├── get_sessions_for_date_usecase.dart
│       ├── get_schedule_summary_usecase.dart
│       ├── get_session_details_usecase.dart
│       ├── cancel_session_usecase.dart
│       └── reschedule_session_usecase.dart
│
├── data/                            # Data Layer
│   ├── models/                      # Data models (extensions of entities)
│   │   ├── session_model.dart
│   │   └── schedule_summary_model.dart
│   ├── data_sources/                # Data sources (local & remote)
│   │   ├── schedule_remote_data_source.dart
│   │   ├── schedule_remote_data_source_impl.dart
│   │   ├── schedule_local_data_source.dart
│   │   └── schedule_local_data_source_impl.dart
│   └── repositories/                # Repository implementations
│       └── schedule_repository_impl.dart
│
└── presentation/                    # UI Layer
    ├── bindings/                    # Dependency injection
    │   └── schedule_binding.dart
    ├── controllers/                 # State management (GetX)
    │   └── schedule_controller.dart
    ├── screens/                     # Full screens
    │   └── trainer_home_schedule_screen.dart
    └── widgets/components/          # Reusable UI components
        ├── trainer_app_bar.dart
        ├── schedule_summary_card.dart
        ├── schedule_timeline_section.dart
        ├── mini_calendar.dart
        ├── empty_schedule.dart
        ├── session_card.dart
        ├── session_info_header.dart
        ├── session_info_card.dart
        └── client_info_card.dart
```

## Key Principles

### 1. **Separation of Concerns**
- **Domain Layer**: Pure business logic, no external dependencies
- **Data Layer**: Handles data fetching (API, local storage)
- **Presentation Layer**: UI and state management

### 2. **Dependency Rule**
- Domain → No dependencies
- Data → Depends on Domain
- Presentation → Depends on Domain

### 3. **Component-Based UI**
Each UI component is:
- **Reusable**: Can be used in multiple places
- **Independent**: Minimal internal state
- **Configurable**: Accepts parameters via constructor
- **Testable**: Easy to unit test

## Component Breakdown

### Layout Components
| Component | Purpose |
|-----------|---------|
| `TrainerAppBar` | User profile, greeting, notifications |
| `ScheduleSummaryCard` | Session statistics display |
| `ScheduleTimelineSection` | Week strip / calendar toggle |

### Interactive Components
| Component | Purpose |
|-----------|---------|
| `WeekStrip` | Horizontal day selector |
| `DaySelectorItem` | Individual day item |
| `MiniCalendar` | Month calendar view |
| `CalendarDayItem` | Individual calendar day |

### Content Components
| Component | Purpose |
|-----------|---------|
| `SessionCard` | Session display with actions |
| `SessionDateColumn` | Date/time display |
| `AiNoteBox` | AI recommendation display |
| `OutlineActionBtn` | Action button style |
| `SessionInfoHeader` | Session details header |
| `SessionInfoCard` | Session note display |
| `SessionIdCard` | Session ID display |
| `ClientInfoCard` | Client info with actions |
| `ActionButton` | Call/message button |
| `EmptySchedule` | Empty state display |

## Usage

### Initialize Dependency Injection
```dart
// In your app.dart or main.dart
Get.put(ScheduleBinding());
```

### Navigate to Schedule Screen
```dart
Get.to(() => const ScheduleScreen());
```

### Access Controller
```dart
final controller = Get.find<ScheduleController>();

// Load data
controller.loadSchedule();

// Select a day
controller.selectDay(3);

// Cancel a session
controller.cancelSession(sessionId);
```

## Testing

### Unit Tests (Domain Layer)
```dart
test('GetSessionsForDateUseCase should return sessions', () async {
  final mockRepo = MockScheduleRepository();
  final usecase = GetSessionsForDateUseCase(mockRepo);
  
  final result = await usecase(DateTime.now());
  
  expect(result, isA<List<SessionEntity>>());
});
```

### Widget Tests (Components)
```dart
testWidgets('SessionCard displays client name', (tester) async {
  final session = SessionEntity(...);
  
  await tester.pumpWidget(
    MaterialApp(
      home: SessionCard(session: session),
    ),
  );
  
  expect(find.text('Client: Smith III'), findsOneWidget);
});
```

## Migration Notes

### What Changed
1. ✅ Single large file → Multiple focused files
2. ✅ Mixed concerns → Clear layer separation
3. ✅ Long widgets → Small reusable components
4. ✅ Hardcoded data → Repository pattern
5. ✅ No DI → GetX dependency injection

### What Stayed the Same
- UI design and appearance
- User interactions
- Mock data (for now)

## Next Steps

1. **API Integration**: Replace mock data in `ScheduleRemoteDataSourceImpl`
2. **Error Handling**: Add proper error states and retry logic
3. **Loading States**: Add shimmer loading components
4. **Caching Strategy**: Implement smart caching with Hive
5. **Real-time Updates**: Add WebSocket support for live updates

## File Naming Conventions

- **Entities**: `*_entity.dart`
- **Models**: `*_model.dart`
- **Use Cases**: `*_usecase.dart`
- **Repositories**: `*_repository.dart`
- **Data Sources**: `*_data_source.dart`
- **Controllers**: `*_controller.dart`
- **Components**: `*_component.dart` or descriptive name

## Code Style

- Use `const` constructors where possible
- Use `final` for immutable variables
- Follow Dart standard formatting
- Add documentation comments for public APIs
- Use meaningful variable names
