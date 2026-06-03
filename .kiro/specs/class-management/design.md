# Design Document: Class Management

## Overview

This design corrects all bugs in the existing class management scaffold and delivers a
fully working, role-aware class management feature in the Tahfeez Flutter app.

The work falls into two tracks:

1. **Data-layer corrections** — fix `type`/`mode` to `int` across every layer; unwrap
   the `{ "value": [...] }` response envelope in `getAllClasses`; change `createClass`
   to return a `String` ID instead of a `ClassEntity`.
2. **Presentation-layer work** — wire `ClassBloc` into `main_shell.dart` via
   `BlocProvider`; replace hardcoded mock data in `ClassesScreen` with live BLoC state;
   implement JWT-based RBAC; add delete confirmation flow; build `AddClassScreen`.

No new packages are required. All existing packages (`flutter_bloc`, `dartz`,
`flutter_secure_storage`, `jwt_decoder`, `dio`, `get_it`) are already available.

---

## Architecture

The app follows Clean Architecture with three layers. The diagram below shows the
complete data flow for the two primary use cases: listing classes and creating a class.

```
┌───────────────────────────────────────────────────────────────────────────────┐
│  Presentation Layer                                                           │
│                                                                               │
│  main_shell.dart                                                              │
│    └─ BlocProvider<ClassBloc>(                                                │
│         create: (_) => sl<ClassBloc>(),                                       │
│         child: ClassesScreen()          ◄────── dispatchs events              │
│       )                                          reads states                 │
│                                                                               │
│  ClassesScreen (StatefulWidget)                                               │
│    initState:                                                                 │
│      1. read JWT → decode role → set _canManage                               │
│      2. add(GetAllClassesEvent())                                             │
│    BlocConsumer/BlocBuilder reacts to ClassState                              │
│    FAB → Navigator.push(BlocProvider.value → AddClassScreen).then(refresh)   │
│    Delete icon → showDialog → add(DeleteClassEvent(id))                       │
│                                                                               │
│  AddClassScreen (StatefulWidget, receives existing ClassBloc via value)       │
│    Submit → add(CreateClassEvent(name, type:int, mode:int))                   │
│    BlocListener: Success → pop(); Error → SnackBar                            │
└───────────────────────────────────────────────────────────────────────────────┘
           │ events                            ▲ states
           ▼                                   │
┌───────────────────────────────────────────────────────────────────────────────┐
│  Domain Layer                                                                 │
│                                                                               │
│  ClassBloc → GetAllClassesUseCase → ClassRepository (abstract)               │
│           → CreateClassUseCase    → ClassRepository.createClass()            │
│           → DeleteClassUseCase    → ClassRepository.deleteClass()            │
│                                                                               │
│  ClassEntity  (id: String, name: String, type: int, mode: int,               │
│                studentCount: int, typeName getter, modeName getter)           │
└───────────────────────────────────────────────────────────────────────────────┘
           │ Either<Failure, T>
           ▼
┌───────────────────────────────────────────────────────────────────────────────┐
│  Data Layer                                                                   │
│                                                                               │
│  ClassRepositoryImpl                                                          │
│    getAllClasses → ClassRemoteDataSourceImpl.getAllClasses()                   │
│    createClass  → ClassRemoteDataSourceImpl.createClass() → String ID        │
│    deleteClass  → ClassRemoteDataSourceImpl.deleteClass()                     │
│                                                                               │
│  ClassRemoteDataSourceImpl                                                    │
│    getAllClasses: apiClient.get('/api/classes')                                │
│                  → extract response['value'] as List                          │
│                  → map each Map item to ClassModel.fromJson                   │
│    createClass:  apiClient.post('/api/classes', data:{name,type:int,mode:int})│
│                  → extract response['value'] as String (UUID)                 │
│    deleteClass:  apiClient.delete('/api/classes/{id}')                        │
│                                                                               │
│  ClassModel.fromJson                                                          │
│    type: (json['type'] as int?) ?? 0                                          │
│    mode: (json['mode'] as int?) ?? 0                                          │
└───────────────────────────────────────────────────────────────────────────────┘
           │ Bearer token via interceptor
           ▼
    ASP.NET Core API  https://alamin.gleeze.com
```

---

## Components and Interfaces

### Files to Modify

#### 1. `lib/features/class/domain/entities/class_entity.dart`

**Changes:**
- `type` field: `String` → `int`
- `mode` field: `String` → `int`
- Add `typeName` computed getter
- Add `modeName` computed getter
- Remove `ClassType` and `ClassMode` string constant classes (replaced by int logic)

```dart
class ClassEntity extends Equatable {
  final String id;
  final String name;
  final int type;     // was String
  final int mode;     // was String
  // ... optional fields unchanged ...
  final int studentCount;

  String get typeName {
    switch (type) {
      case 1: return 'Boys';
      case 2: return 'Girls';
      default: return 'Unknown';
    }
  }

  String get modeName {
    switch (mode) {
      case 1: return 'Online';
      case 2: return 'Offline';
      default: return 'Unknown';
    }
  }
}
```

---

#### 2. `lib/features/class/data/models/class_model.dart`

**Changes:**
- `fromJson`: parse `type` and `mode` as `(json['type'] as int?) ?? 0` and
  `(json['mode'] as int?) ?? 0` — no String cast
- `toJson`, `toCreateJson`, `toUpdateJson`: fields are already forwarded, no change
  needed beyond the type fix flowing from `ClassEntity`

```dart
factory ClassModel.fromJson(Map<String, dynamic> json) {
  return ClassModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    type: (json['type'] as int?) ?? 0,   // was json['type'] ?? ''
    mode: (json['mode'] as int?) ?? 0,   // was json['mode'] ?? ''
    studentCount: (json['studentCount'] as int?) ?? 0,
    // optional fields unchanged
  );
}
```

---

#### 3. `lib/features/class/data/datasources/class_remote_datasource.dart`

**Abstract interface changes:**
- `createClass` return type: `Future<ClassModel>` → `Future<String>`
- `createClass` params: `type`/`mode` → `int`

**Implementation changes:**

`getAllClasses`:
```dart
Future<List<ClassModel>> getAllClasses() async {
  try {
    final response = await apiClient.get(ApiConstants.classesEndpoint);
    final raw = response['value'];
    if (raw == null || raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => ClassModel.fromJson(e))
        .toList();
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}
```

`createClass`:
```dart
Future<String> createClass({
  required String name,
  required int type,
  required int mode,
  String? teacherId,
  String? assistantId,
  String? supervisorId,
}) async {
  try {
    final response = await apiClient.post(
      ApiConstants.classesEndpoint,
      data: {
        'name': name,
        'type': type,
        'mode': mode,
        'teacherId': teacherId,
        'assistantId': assistantId,
        'supervisorId': supervisorId,
      },
    );
    final id = response['value'];
    if (id == null || id is! String) {
      throw ServerException(message: 'Invalid response: missing class ID');
    }
    return id;
  } catch (e) {
    if (e is ServerException) rethrow;
    throw ServerException(message: e.toString());
  }
}
```

---

#### 4. `lib/features/class/domain/repositories/class_repository.dart`

**Changes:**
- `createClass` return type: `Future<Either<Failure, ClassEntity>>` → `Future<Either<Failure, String>>`
- `createClass` params `type`/`mode`: `String` → `int`

```dart
Future<Either<Failure, String>> createClass({
  required String name,
  required int type,
  required int mode,
  String? teacherId,
  String? assistantId,
  String? supervisorId,
});
```

---

#### 5. `lib/features/class/data/repositories/class_repository_impl.dart`

**Changes:**
- `createClass` return type: `Future<Either<Failure, ClassEntity>>` → `Future<Either<Failure, String>>`
- `createClass` params `type`/`mode`: `String` → `int`
- On success: `Right(result)` where `result` is a `String` (the ID returned from data source)

```dart
Future<Either<Failure, String>> createClass({
  required String name,
  required int type,
  required int mode,
  String? teacherId,
  String? assistantId,
  String? supervisorId,
}) async {
  try {
    final id = await remoteDataSource.createClass(
      name: name, type: type, mode: mode,
      teacherId: teacherId, assistantId: assistantId, supervisorId: supervisorId,
    );
    return Right(id);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

---

#### 6. `lib/features/class/domain/usecases/class_usecases.dart`

**Changes in `CreateClassUseCase`:**
- Return type: `Future<Either<Failure, ClassEntity>>` → `Future<Either<Failure, String>>`
- `type`/`mode` params: `String` → `int`

```dart
class CreateClassUseCase {
  Future<Either<Failure, String>> call({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) {
    return repository.createClass(
      name: name, type: type, mode: mode,
      teacherId: teacherId, assistantId: assistantId, supervisorId: supervisorId,
    );
  }
}
```

---

#### 7. `lib/features/class/presentation/blocs/class_event.dart`

**Changes in `CreateClassEvent`:**
- `type` field: `String` → `int`
- `mode` field: `String` → `int`

```dart
class CreateClassEvent extends ClassEvent {
  final String name;
  final int type;   // was String
  final int mode;   // was String
  final String? teacherId;
  final String? assistantId;
  final String? supervisorId;
  // ...
}
```

---

#### 8. `lib/features/class/presentation/blocs/class_bloc.dart`

**Changes in `_onCreateClass`:**
- The `event.type` and `event.mode` are now `int` — no other changes needed for the
  call signature.
- The fold success branch receives a `String` (the ID), so emit message that includes it:

```dart
result.fold(
  (failure) => emit(ClassError(failure.message)),
  (id) => emit(ClassOperationSuccess('Class created successfully (ID: $id)')),
);
```

---

#### 9. `lib/screens/main_shell.dart`

**Change:** Wrap `ClassesScreen` in a `BlocProvider` so the bloc is available to both
`ClassesScreen` and `AddClassScreen` (via `BlocProvider.value` when navigating).

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection_container.dart' as di;
import '../features/class/presentation/blocs/class_bloc.dart';

// Inside _screens list:
BlocProvider<ClassBloc>(
  create: (_) => di.sl<ClassBloc>(),
  child: const ClassesScreen(),
),
```

> **Rationale:** `sl.registerFactory` creates a fresh `ClassBloc` per call. By
> creating the instance in `BlocProvider` at the shell level, the same instance is
> shared between `ClassesScreen` and `AddClassScreen` (passed via `BlocProvider.value`
> during navigation). This means success/error states from `AddClassScreen` are
> immediately visible in the parent.

---

#### 10. `lib/screens/classes_screen.dart` — Full Rewrite

**Key changes:**
- Remove all hardcoded `_ClassData` / mock data
- Import `flutter_bloc`, `ClassBloc`, `ClassState`, `ClassEvent`, `ClassEntity`
- Add `_canManage` state field; resolve in `initState`
- Dispatch `GetAllClassesEvent` in `initState`
- Replace grid of mock cards with `BlocBuilder`-driven `ListView`
- FAB and delete icons conditional on `_canManage`
- Delete flow: `showDialog` → `DeleteClassEvent` → refresh on success / SnackBar on error
- Navigate to `AddClassScreen` using `BlocProvider.value` + `.then(refresh)`

**State class fields:**
```dart
class _ClassesScreenState extends State<ClassesScreen> {
  bool _canManage = false;
  String? _deletingId;        // tracks which class delete is in-flight
}
```

**`initState` logic:**
```dart
void initState() {
  super.initState();
  _resolveRole();
  context.read<ClassBloc>().add(GetAllClassesEvent());
}

Future<void> _resolveRole() async {
  try {
    final storage = di.sl<FlutterSecureStorage>();
    final token = await storage.read(key: 'access_token');
    if (token == null) return;
    final claims = JwtDecoder.decode(token);  // throws on malformed/expired
    final role = claims['role'] as String?;
    if (mounted) {
      setState(() {
        _canManage = role == 'Admin' || role == 'Supervisor';
      });
    }
  } catch (_) {
    // malformed/expired JWT → no privilege, _canManage remains false
  }
}
```

**BlocConsumer setup:**
```dart
BlocConsumer<ClassBloc, ClassState>(
  listener: (context, state) {
    if (state is ClassOperationSuccess && _deletingId != null) {
      setState(() => _deletingId = null);
      context.read<ClassBloc>().add(GetAllClassesEvent());
    }
    if (state is ClassError && _deletingId != null) {
      setState(() => _deletingId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message),
                 duration: const Duration(seconds: 3)),
      );
    }
  },
  builder: (context, state) {
    if (state is ClassLoading && _deletingId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ClassError) {
      return _buildError(context, state.message);
    }
    if (state is ClassesLoaded) {
      if (state.classes.isEmpty) {
        return const Center(child: Text('No classes found'));
      }
      return _buildList(context, state.classes);
    }
    return const Center(child: CircularProgressIndicator());
  },
)
```

**Class card rendering (driven by `ClassEntity`):**
- Name: `entity.name`
- Type badge: `entity.typeName` — coloured chip
  - Boys: `TahfeezColors.primaryContainer` background
  - Girls: `TahfeezColors.tertiaryContainer` background
  - Unknown: `TahfeezColors.surfaceContainer` background
- Mode badge: `entity.modeName` — chip with icon
  - Online: `Icons.desktop_windows_outlined`
  - Offline: `Icons.storefront_outlined`
- Student count: `"${entity.studentCount} students"`
- Delete icon: shown only when `_canManage`; disabled while `_deletingId != null`

**Navigate to AddClassScreen:**
```dart
void _openAddClass(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<ClassBloc>(),
        child: const AddClassScreen(),
      ),
    ),
  ).then((_) {
    if (mounted) {
      context.read<ClassBloc>().add(GetAllClassesEvent());
    }
  });
}
```

**Delete confirmation dialog:**
```dart
Future<void> _confirmDelete(BuildContext context, ClassEntity cls) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete class?'),
      content: Text('This will permanently delete "${cls.name}".'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false),
                   child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true),
                   child: const Text('Delete')),
      ],
    ),
  );
  if (confirmed == true && mounted) {
    setState(() => _deletingId = cls.id);
    context.read<ClassBloc>().add(DeleteClassEvent(cls.id));
  }
}
```

---

### Files to Create

#### 11. `lib/screens/add_class_screen.dart` — New File

`AddClassScreen` is a new `StatefulWidget`. It receives the `ClassBloc` instance via
`BlocProvider.value` from `ClassesScreen` and does not create its own bloc.

**State fields:**
```dart
class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _selectedType;    // null = not yet selected
  int? _selectedMode;    // null = not yet selected
  bool _isSubmitting = false;
}
```

**Form structure:**
1. `TextFormField` for name
   - `validator`: trim and check `isEmpty` → "Class name is required"; check
     `length > 100` → "Name must be 100 characters or fewer"
   - The validator also rejects whitespace-only strings (checked via `.trim().isEmpty`)
2. `DropdownButtonFormField<int>` for type
   - Items: `DropdownMenuItem(value: 1, child: Text('Boys'))`,
             `DropdownMenuItem(value: 2, child: Text('Girls'))`
   - `value: _selectedType` (initially `null`, so no pre-selection)
   - `validator`: null check → "Please select a class type"
   - `onChanged`: `setState(() => _selectedType = value)`
3. `DropdownButtonFormField<int>` for mode
   - Items: `DropdownMenuItem(value: 1, child: Text('Online'))`,
             `DropdownMenuItem(value: 2, child: Text('Offline'))`
   - `value: _selectedMode`
   - `validator`: null check → "Please select a class mode"
   - `onChanged`: `setState(() => _selectedMode = value)`
4. Submit `ElevatedButton`
   - Disabled/shows `CircularProgressIndicator` when `_isSubmitting`
   - `onPressed`: calls `_submit()`

**Submit logic:**
```dart
void _submit() {
  if (!_formKey.currentState!.validate()) return;
  context.read<ClassBloc>().add(CreateClassEvent(
    name: _nameController.text.trim(),
    type: _selectedType!,
    mode: _selectedMode!,
  ));
}
```

**BlocListener (wraps form body):**
```dart
BlocListener<ClassBloc, ClassState>(
  listener: (context, state) {
    if (state is ClassLoading) {
      setState(() => _isSubmitting = true);
    } else if (state is ClassOperationSuccess) {
      Navigator.pop(context);   // returns to ClassesScreen
    } else if (state is ClassError) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message),
                 duration: const Duration(seconds: 3)),
      );
      // form values are preserved — no reset
    }
  },
  child: /* form */,
)
```

> **Note:** `BlocListener` uses the `ClassBloc` from `BlocProvider.value`, which is
> the same instance as the parent `ClassesScreen`. When `ClassOperationSuccess` is
> emitted, both screens react: `AddClassScreen` pops, and `ClassesScreen` refreshes via
> the `.then()` callback on `Navigator.push`.

---

## Data Models

### `ClassEntity` (updated)

| Field          | Type       | Notes                                     |
|----------------|------------|-------------------------------------------|
| `id`           | `String`   | defaults to `""` if absent/null in JSON   |
| `name`         | `String`   | defaults to `""` if absent/null in JSON   |
| `type`         | `int`      | 1=Boys, 2=Girls; defaults to 0            |
| `mode`         | `int`      | 1=Online, 2=Offline; defaults to 0        |
| `studentCount` | `int`      | defaults to 0 if absent/null in JSON      |
| `typeName`     | `String` (computed) | "Boys" / "Girls" / "Unknown"   |
| `modeName`     | `String` (computed) | "Online" / "Offline" / "Unknown"|
| `teacherId`    | `String?`  | optional                                  |
| `teacherName`  | `String?`  | optional                                  |
| `assistantId`  | `String?`  | optional                                  |
| `assistantName`| `String?`  | optional                                  |
| `supervisorId` | `String?`  | optional                                  |
| `supervisorName`| `String?` | optional                                  |

### `CreateClassEvent` (updated)

| Field          | Type       |
|----------------|------------|
| `name`         | `String`   |
| `type`         | `int`      |
| `mode`         | `int`      |
| `teacherId`    | `String?`  |
| `assistantId`  | `String?`  |
| `supervisorId` | `String?`  |

### API Request Body — POST `/api/classes`

```json
{
  "name": "string",
  "type": 1,
  "mode": 1,
  "teacherId": null,
  "assistantId": null,
  "supervisorId": null
}
```

### API Response — GET `/api/classes`

```json
{
  "value": [
    { "id": "uuid", "name": "string", "type": 1, "mode": 1, "studentCount": 12 }
  ],
  "isSuccess": true
}
```

### API Response — POST `/api/classes`

```json
{
  "value": "550e8400-e29b-41d4-a716-446655440000",
  "isSuccess": true
}
```

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid
executions of a system — essentially, a formal statement about what the system should
do. Properties serve as the bridge between human-readable specifications and
machine-verifiable correctness guarantees.*

---

### Property 1: `ClassModel.fromJson` → `toJson` round-trip

*For any* valid `ClassModel` (where `id` and `name` are non-null strings and `type` and
`mode` are ints), calling `ClassModel.fromJson(model.toJson())` SHALL produce a
`ClassModel` with identical `id`, `name`, `type`, `mode`, and `studentCount` values.

**Validates: Requirements 9.6**

---

### Property 2: Non-int `type` in JSON always defaults to 0

*For any* JSON map where the `"type"` field is `null`, absent, a `String`, a `double`,
or any other non-`int` value, `ClassModel.fromJson` SHALL produce a model where
`type == 0`.

**Validates: Requirements 1.2**

---

### Property 3: Non-int `mode` in JSON always defaults to 0

*For any* JSON map where the `"mode"` field is `null`, absent, a `String`, a `double`,
or any other non-`int` value, `ClassModel.fromJson` SHALL produce a model where
`mode == 0`.

**Validates: Requirements 1.3**

---

### Property 4: `typeName` and `modeName` getters are correct for all int inputs

*For any* integer `t`, `ClassEntity.typeName` SHALL return `"Boys"` when `t == 1`,
`"Girls"` when `t == 2`, and `"Unknown"` for all other values. Equivalently for
`modeName`: `"Online"` for 1, `"Offline"` for 2, `"Unknown"` otherwise.

**Validates: Requirements 1.4, 1.5**

---

### Property 5: Envelope unwrapping preserves all items

*For any* list of N valid class JSON objects wrapped in `{ "value": [...] }`,
`ClassRemoteDataSourceImpl.getAllClasses` SHALL return a list of exactly N
`ClassModel` instances with the same field values.

**Validates: Requirements 2.1, 4.2, 4.3**

---

### Property 6: Non-list `value` in envelope returns empty list

*For any* response map where `response['value']` is `null`, absent, an `int`, a
`String`, or a `Map`, `ClassRemoteDataSourceImpl.getAllClasses` SHALL return an
empty `List<ClassModel>` without throwing.

**Validates: Requirements 2.2**

---

### Property 7: Mixed-type envelope items — invalid items are skipped

*For any* list that contains a mix of valid `Map<String, dynamic>` items and invalid
(non-map) items, `ClassRemoteDataSourceImpl.getAllClasses` SHALL return a list
containing only the `ClassModel` instances derived from the valid map items, with no
exception thrown.

**Validates: Requirements 2.3**

---

### Property 8: `createClass` extracts and returns the UUID verbatim

*For any* valid UUID string returned in `response['value']` from a successful POST,
`ClassRemoteDataSourceImpl.createClass` SHALL return that exact string unchanged.

**Validates: Requirements 3.2**

---

### Property 9: RBAC — `_canManage` is true if and only if role is Admin or Supervisor

*For any* JWT payload where the `role` claim is present, `_canManage` in
`ClassesScreen` SHALL be `true` if and only if `role == "Admin"` or
`role == "Supervisor"`. For any other role string (including empty string), and for
missing/expired/malformed tokens, `_canManage` SHALL be `false`.

**Validates: Requirements 5.1–5.7**

---

### Property 10: Class card renders all required fields for any `ClassEntity`

*For any* `ClassEntity`, the rendered class card widget SHALL contain the entity's
`name`, its `typeName` string, its `modeName` string, and a string matching
`"${entity.studentCount} students"`.

**Validates: Requirements 6.7**

---

### Property 11: Submit with whitespace-only name is always rejected

*For any* string composed entirely of whitespace characters (space, tab, newline,
non-breaking space), submitting it as the class name in `AddClassScreen` SHALL fail
form validation and SHALL NOT dispatch `CreateClassEvent`.

**Validates: Requirements 8.1**

---

### Property 12: Valid form submission dispatches `CreateClassEvent` with correct int values

*For any* valid name (non-empty, non-whitespace, ≤ 100 chars), and for each combination
of type ∈ {1, 2} and mode ∈ {1, 2}, submitting the `AddClassScreen` form SHALL dispatch
exactly one `CreateClassEvent` carrying the exact `int` values for `type` and `mode`
and the trimmed name string.

**Validates: Requirements 8.7, 1.12, 1.13**

---

**Property Reflection:**

- Properties 2 and 3 address the same pattern (non-int JSON default) for different
  fields — kept separate because they test distinct fields and the generators differ.
- Properties 4 (typeName/modeName) is complementary to the round-trip (Property 1) but
  tests the computed getter logic specifically, not serialisation.
- Properties 5, 6, and 7 all concern envelope unwrapping but test distinct failure
  modes; no redundancy.
- Property 10 (card render) is distinct from Property 12 (form submit) — different
  components, no overlap.
- Properties 11 and 12 both concern form validation but test opposite cases (invalid vs.
  valid); they cannot be merged.

---

## Error Handling Strategy

### Data Layer

| Scenario | Behaviour |
|---|---|
| `DioException` with connection timeout | `ApiClient` throws `NetworkException("Connection timeout")` |
| `DioException` with no internet | `ApiClient` throws `NetworkException("No internet connection")` |
| HTTP 401 | `ApiClient` attempts token refresh once via interceptor; if refresh fails, throws `AuthException` |
| HTTP 4xx / 5xx with body | `ApiClient` parses `error_description` or `message` from body; throws `ServerException(message)` |
| `response['value']` is null after POST 2xx | `ClassRemoteDataSourceImpl` throws `ServerException("Invalid response: missing class ID")` |
| `response['value']` is not a List after GET | `ClassRemoteDataSourceImpl` returns `[]` — no exception |
| Individual list item is not a Map | item is silently skipped; remaining items parsed normally |

`ClassRepositoryImpl` catches `ServerException` → `Left(ServerFailure(message))` and
`NetworkException` → `Left(NetworkFailure(message))`.

### BLoC Layer

| Event | Failure outcome | State emitted |
|---|---|---|
| `GetAllClassesEvent` | any failure | `ClassError(message)` |
| `CreateClassEvent` | any failure | `ClassError(message)` |
| `DeleteClassEvent` | any failure | `ClassError(message)` |

On `ClassError` after a `DeleteClassEvent`, `ClassesScreen` shows a `SnackBar`
(3-second duration). Previous `ClassesLoaded` list remains visible because the
`BlocConsumer.builder` only re-renders on `ClassError` / `ClassLoading` /
`ClassesLoaded` — the list from the prior `ClassesLoaded` is not cleared.

### UI Layer

| State | UI response |
|---|---|
| `ClassLoading` (initial, no prior list) | `CircularProgressIndicator` centred |
| `ClassLoading` (during delete) | List stays visible; delete buttons disabled |
| `ClassesLoaded([])` | Empty-state text: `"No classes found"` |
| `ClassesLoaded(list)` | `ListView` with `"${list.length} classes"` header |
| `ClassError` | Error message + "Retry" button (dispatches `GetAllClassesEvent`) |
| `ClassOperationSuccess` (from delete) | Silently refresh via `GetAllClassesEvent` |
| `ClassError` (from delete) | `SnackBar` with error message, list unchanged |
| `ClassOperationSuccess` (from create) | `AddClassScreen` pops; `ClassesScreen` refreshes |
| `ClassError` (from create) | `SnackBar` in `AddClassScreen`; form values preserved |
| JWT missing / expired / malformed | `_canManage = false`; FAB and delete buttons hidden |

---

## Navigation Flow

```
MainShell
  └─ BlocProvider<ClassBloc> (index 1 in _screens)
       └─ ClassesScreen
            │
            │  FAB tapped (only if _canManage)
            ▼
       BlocProvider.value<ClassBloc>
         └─ AddClassScreen
              │
              │  Success → Navigator.pop()
              ▼
       ClassesScreen.then() → add(GetAllClassesEvent())
```

The `ClassBloc` instance is created once in `BlocProvider` inside `MainShell`.
`AddClassScreen` shares that same instance via `BlocProvider.value`. This means:

- State emitted by `AddClassScreen`'s `CreateClassEvent` is also visible to
  `ClassesScreen`'s `BlocConsumer`.
- When `ClassOperationSuccess` fires, `AddClassScreen` pops and control returns to
  `ClassesScreen`, whose `.then()` callback immediately dispatches `GetAllClassesEvent`.

No route-based navigation (named routes / `GoRouter`) is introduced; simple
`Navigator.push/pop` suffices for this two-screen flow.

---

## Testing Strategy

### Overview

Testing follows a dual approach: property-based tests for universal correctness
invariants and example-based unit/widget tests for specific interactions and state
transitions.

**PBT library:** [`fast_check`](https://pub.dev/packages/fast_check) (Dart port of
fast-check, supports arbitrary generators and shrinking). Minimum 100 iterations per
property test.

### Unit Tests — Data Layer

| Test | Type | Description |
|---|---|---|
| `ClassModel.fromJson` round-trip | **Property** | Property 1 — generate random ClassModel, toJson → fromJson, assert equality |
| `ClassModel.fromJson` — non-int type defaults to 0 | **Property** | Property 2 — generate non-int values for "type" key |
| `ClassModel.fromJson` — non-int mode defaults to 0 | **Property** | Property 3 — generate non-int values for "mode" key |
| `ClassEntity.typeName` for all ints | **Property** | Property 4 — generate arbitrary ints |
| `ClassEntity.modeName` for all ints | **Property** | Property 4 — generate arbitrary ints |
| `getAllClasses` envelope unwrap — N items preserved | **Property** | Property 5 — mock apiClient.get with random-length list |
| `getAllClasses` — non-list value → empty list | **Property** | Property 6 — generate non-list envelope values |
| `getAllClasses` — mixed-type list skips non-maps | **Property** | Property 7 — generate mixed lists |
| `createClass` — extracts UUID verbatim | **Property** | Property 8 — generate UUID strings |
| `createClass` — null/non-string value → ServerException | **Example** | Requirement 3.3 |
| `ClassRepositoryImpl.createClass` — Right(id) on success | **Example** | Requirement 3.5 |
| `ClassRepositoryImpl.createClass` — Left on ServerException | **Example** | Requirement 3.6 |

### Unit Tests — BLoC Layer

| Test | Type | Description |
|---|---|---|
| `GetAllClassesEvent` → `ClassLoading` then `ClassesLoaded` | **Example** | Req 4.2–4.3 |
| `GetAllClassesEvent` → `ClassLoading` then `ClassError` | **Example** | Req 4.4 |
| `CreateClassEvent` → `ClassLoading` then `ClassOperationSuccess` (with ID in message) | **Example** | Req 3.8 |
| `CreateClassEvent` → `ClassLoading` then `ClassError` | **Example** | Req 3.9 |
| `DeleteClassEvent` → `ClassLoading` then `ClassOperationSuccess` | **Example** | Req 7.3 |
| `DeleteClassEvent` → `ClassLoading` then `ClassError` | **Example** | Req 7.5 |
| `int` type/mode flows from `CreateClassEvent` to `CreateClassUseCase` | **Example** | Req 1.13 |

### Widget Tests — `ClassesScreen`

| Test | Type | Description |
|---|---|---|
| `GetAllClassesEvent` dispatched on mount | **Example** | Req 6.1 |
| `ClassLoading` state → shows `CircularProgressIndicator` | **Example** | Req 6.2 |
| `ClassesLoaded([])` → shows "No classes found" | **Example** | Req 6.4 |
| `ClassError` → shows error message + Retry button | **Example** | Req 6.6 |
| Retry button dispatches `GetAllClassesEvent` | **Example** | Req 6.6 |
| `ClassesLoaded(list)` → renders N cards | **Property** | Property — generate lists of random length |
| Each card shows name, typeName, modeName, studentCount | **Property** | Property 10 — generate random ClassEntity |
| `_canManage = false` → no FAB, no delete buttons | **Example** | Req 5.5, 5.7 |
| `_canManage = true` → FAB and delete buttons visible | **Example** | Req 5.4, 5.6 |
| `_canManage` false for non-Admin/non-Supervisor roles | **Property** | Property 9 |
| Delete icon tap → shows AlertDialog with class name | **Example** | Req 7.1 |
| AlertDialog "Delete" → dispatches `DeleteClassEvent` | **Example** | Req 7.2 |
| AlertDialog "Cancel" → no event dispatched | **Example** | Req 7.4 |
| `ClassLoading` after delete → delete buttons disabled | **Example** | Req 7.6 |
| `ClassError` after delete → SnackBar shown | **Example** | Req 7.5 |

### Widget Tests — `AddClassScreen`

| Test | Type | Description |
|---|---|---|
| Empty name → validation error, no event dispatched | **Example** | Req 8.4 |
| Whitespace-only name → rejected for any whitespace string | **Property** | Property 11 |
| No type selected → validation error | **Example** | Req 8.5 |
| No mode selected → validation error | **Example** | Req 8.6 |
| Valid submit → `CreateClassEvent` with correct int values | **Property** | Property 12 |
| `ClassLoading` after submit → button disabled | **Example** | Req 8.8 |
| `ClassOperationSuccess` → `Navigator.pop` called | **Example** | Req 8.9 |
| `ClassError` → SnackBar shown, form values preserved | **Example** | Req 8.11 |

### Property-Test Configuration (fast_check)

Each property test must include a comment referencing its design property:
```dart
// Feature: class-management, Property 1: ClassModel round-trip
fc.assert(
  fc.property(classModelArb, (model) {
    final roundTripped = ClassModel.fromJson(model.toJson());
    expect(roundTripped.id, equals(model.id));
    // ...
  }),
  options: fc.Options(numRuns: 100),
);
```

Tag format: `// Feature: class-management, Property {N}: {short description}`
