# Implementation Plan: Class Management

## Overview

Fix all data-layer bugs (type/mode int, envelope unwrap, createClass returns String ID)
and deliver a fully working, role-aware class management UI. Work is split into three
dependency-safe tracks: data-layer corrections (Track 1), presentation-layer work
(Track 2), and tests (Track 3).

---

## Tasks

- [x] 1. Fix `ClassEntity` — change `type`/`mode` to `int`, add `typeName`/`modeName` getters
  - In `lib/features/class/domain/entities/class_entity.dart`:
    - Change `type` field from `String` to `int`
    - Change `mode` field from `String` to `int`
    - Add `typeName` computed getter: `1` → `"Boys"`, `2` → `"Girls"`, else `"Unknown"`
    - Add `modeName` computed getter: `1` → `"Online"`, `2` → `"Offline"`, else `"Unknown"`
    - Remove any `ClassType` / `ClassMode` string constant classes
    - Update `Equatable` props list to include the updated fields
  - _Requirements: 1.1, 1.4, 1.5_

- [x] 2. Fix `ClassModel.fromJson` — parse `type`/`mode` as `int` with safe defaults
  - In `lib/features/class/data/models/class_model.dart`:
    - Change `type` parsing to `(json['type'] as int?) ?? 0`
    - Change `mode` parsing to `(json['mode'] as int?) ?? 0`
    - Change `studentCount` parsing to `(json['studentCount'] as int?) ?? 0`
    - Change `id`/`name` parsing to `json['id'] as String? ?? ''` and `json['name'] as String? ?? ''`
    - Ensure `toJson` serialises `type` and `mode` as `int` (no String cast)
  - _Requirements: 1.2, 1.3, 1.6, 9.1–9.6_

- [x] 3. Fix `ClassRemoteDataSource` — unwrap envelope in `getAllClasses`; `createClass` returns `String`
  - In `lib/features/class/data/datasources/class_remote_datasource.dart`:
    - Update abstract interface: `createClass` return type `Future<ClassModel>` → `Future<String>`; change `type`/`mode` params to `int`
    - In `ClassRemoteDataSourceImpl.getAllClasses`: extract `response['value']`; if `null` or not `List` return `[]`; use `.whereType<Map<String, dynamic>>()` to skip non-map items; map each valid item to `ClassModel.fromJson`
    - In `ClassRemoteDataSourceImpl.createClass`: extract `response['value']` as `String`; throw `ServerException(message: 'Invalid response: missing class ID')` if absent or not a `String`; return the UUID string on success
  - _Requirements: 2.1–2.3, 3.1–3.3, 1.10, 1.11_

- [x] 4. Fix `ClassRepository` abstract interface — `createClass` returns `Either<Failure, String>`
  - In `lib/features/class/domain/repositories/class_repository.dart`:
    - Change `createClass` return type to `Future<Either<Failure, String>>`
    - Change `type`/`mode` params to `int`
  - _Requirements: 3.4, 1.8_

- [x] 5. Fix `ClassRepositoryImpl` — `createClass` returns `Either<Failure, String>`
  - In `lib/features/class/data/repositories/class_repository_impl.dart`:
    - Update `createClass` signature: return `Future<Either<Failure, String>>`, params `type`/`mode` as `int`
    - On data source success: `return Right(id)` where `id` is the `String` returned
    - On `ServerException`: `return Left(ServerFailure(e.message))`
    - On `NetworkException`: `return Left(NetworkFailure(e.message))`
  - _Requirements: 3.5, 3.6, 1.9_

- [x] 6. Fix `CreateClassUseCase` — `int` params, returns `Either<Failure, String>`
  - In `lib/features/class/domain/usecases/class_usecases.dart`:
    - Change `CreateClassUseCase.call` return type to `Future<Either<Failure, String>>`
    - Change `type`/`mode` params to `int`
    - Forward all params to `repository.createClass(...)` unchanged
  - _Requirements: 3.7, 1.7, 1.14_

- [x] 7. Fix `CreateClassEvent` — `type`/`mode` fields as `int`
  - In `lib/features/class/presentation/blocs/class_event.dart`:
    - Change `CreateClassEvent.type` from `String` to `int`
    - Change `CreateClassEvent.mode` from `String` to `int`
    - Update `props` list in `Equatable` if present
  - _Requirements: 1.12_

- [ ] 8. Fix `ClassBloc._onCreateClass` — handle `String` ID from use case
  - In `lib/features/class/presentation/blocs/class_bloc.dart`:
    - In the `_onCreateClass` handler, the fold success branch now receives a `String` `id`
    - Emit `ClassOperationSuccess('Class created successfully (ID: $id)')` on `Right(id)`
    - Emit `ClassError(failure.message)` on `Left(failure)` — unchanged
    - Confirm `event.type` and `event.mode` are passed to the use case as `int`
  - _Requirements: 3.8, 3.9, 1.13_

- [~] 9. Checkpoint — data layer complete
  - Ensure all data-layer files compile without errors.
  - Run `flutter analyze lib/features/class/` and fix any type errors before proceeding.
  - Ask the user if any questions arise before starting Track 2.

- [~] 10. Fix `main_shell.dart` — wrap `ClassesScreen` in `BlocProvider<ClassBloc>`
  - In `lib/screens/main_shell.dart`:
    - Import `flutter_bloc`, `ClassBloc`, and the DI container (`injection_container.dart`)
    - In the `_screens` list (or equivalent widget array), wrap the `ClassesScreen` entry with `BlocProvider<ClassBloc>(create: (_) => sl<ClassBloc>(), child: const ClassesScreen())`
    - Do not change any other screen entries
  - _Requirements: 6.1 (BLoC must be in scope when ClassesScreen mounts)_

- [~] 11. Rewrite `ClassesScreen` — BLoC wiring, JWT RBAC, live list, delete flow, navigation
  - In `lib/screens/classes_screen.dart`:
    - Remove all hardcoded `_ClassData` / mock data structures and mock lists
    - Add state fields: `bool _canManage = false` and `String? _deletingId`
    - In `initState`: call `_resolveRole()` and dispatch `GetAllClassesEvent()`
    - Implement `_resolveRole()`: read `'access_token'` via `FlutterSecureStorage`; decode with `JwtDecoder.decode`; set `_canManage = true` only if `role == 'Admin' || role == 'Supervisor'`; catch all exceptions and leave `_canManage = false`
    - Replace body with `BlocConsumer<ClassBloc, ClassState>`:
      - `listener`: on `ClassOperationSuccess` when `_deletingId != null` → clear `_deletingId`, dispatch `GetAllClassesEvent`; on `ClassError` when `_deletingId != null` → clear `_deletingId`, show `SnackBar` (3 s duration)
      - `builder`: `ClassLoading` (no prior list) → `CircularProgressIndicator`; `ClassError` → error message + Retry button; `ClassesLoaded([])` → `"No classes found"` centred text; `ClassesLoaded(list)` → `"${list.length} classes"` header + `ListView` of class cards
    - Each class card displays: `entity.name`, `entity.typeName` badge, `entity.modeName` badge, `"${entity.studentCount} students"`
    - Delete icon shown only when `_canManage`; disabled while `_deletingId != null`
    - Implement `_confirmDelete`: `showDialog` → `AlertDialog` with title `'Delete class?'`, body includes `cls.name`, Cancel and Delete buttons; on confirm, set `_deletingId = cls.id`, dispatch `DeleteClassEvent(cls.id)`
    - FAB shown only when `_canManage`; on tap, call `_openAddClass`
    - Implement `_openAddClass`: `Navigator.push` with `BlocProvider.value<ClassBloc>`; `.then((_) { if (mounted) context.read<ClassBloc>().add(GetAllClassesEvent()); })`
  - _Requirements: 5.1–5.7, 6.1–6.7, 7.1–7.6, 8.10_

- [~] 12. Create `AddClassScreen` — form with name/type/mode, validation, BlocListener
  - Create new file `lib/screens/add_class_screen.dart`:
    - `StatefulWidget` — receives `ClassBloc` via `BlocProvider.value` from parent; does NOT create its own bloc
    - State fields: `GlobalKey<FormState> _formKey`, `TextEditingController _nameController`, `int? _selectedType`, `int? _selectedMode`, `bool _isSubmitting = false`
    - `Form` with three fields:
      1. `TextFormField` for name — validator: trim, reject empty/whitespace-only → `'Class name is required'`; reject length > 100 → `'Name must be 100 characters or fewer'`
      2. `DropdownButtonFormField<int>` for type — items: `Boys` (1), `Girls` (2); `value: _selectedType`; validator: null → `'Please select a class type'`
      3. `DropdownButtonFormField<int>` for mode — items: `Online` (1), `Offline` (2); `value: _selectedMode`; validator: null → `'Please select a class mode'`
    - Submit `ElevatedButton` — disabled/shows `CircularProgressIndicator` when `_isSubmitting`; `onPressed` calls `_submit()`
    - `_submit()`: validate form; if valid, dispatch `CreateClassEvent(name: _nameController.text.trim(), type: _selectedType!, mode: _selectedMode!)`
    - Wrap form body with `BlocListener<ClassBloc, ClassState>`: `ClassLoading` → `_isSubmitting = true`; `ClassOperationSuccess` → `Navigator.pop(context)`; `ClassError` → `_isSubmitting = false` + `SnackBar` (3 s) + preserve form values
  - _Requirements: 8.1–8.11_

- [~] 13. Checkpoint — presentation layer complete
  - Ensure all presentation files compile without errors.
  - Run `flutter analyze lib/screens/` and fix any type/lint errors.
  - Ask the user if any questions arise before starting Track 3 (tests).

- [ ] 14. Write property-based and unit tests for the data layer (Properties 1–8)
  - [~] 14.1 Write property test for `ClassModel` round-trip (Property 1)
    - File: `test/features/class/data/models/class_model_test.dart`
    - Use `fast_check`; generate random `ClassModel` instances with arbitrary `id`, `name`, `type`, `mode`, `studentCount`; assert `ClassModel.fromJson(model.toJson())` equals original
    - Tag: `// Feature: class-management, Property 1: ClassModel round-trip`
    - _Requirements: 9.6_

  - [ ]* 14.2 Write property test for non-int `type` defaults to 0 (Property 2)
    - File: same as 14.1
    - Generate JSON maps where `"type"` is `null`, absent, a `String`, or a `double`; assert `fromJson(map).type == 0`
    - Tag: `// Feature: class-management, Property 2: non-int type defaults to 0`
    - _Requirements: 1.2_

  - [ ]* 14.3 Write property test for non-int `mode` defaults to 0 (Property 3)
    - File: same as 14.1
    - Generate JSON maps where `"mode"` is `null`, absent, a `String`, or a `double`; assert `fromJson(map).mode == 0`
    - Tag: `// Feature: class-management, Property 3: non-int mode defaults to 0`
    - _Requirements: 1.3_

  - [ ]* 14.4 Write property test for `typeName`/`modeName` getters (Property 4)
    - File: `test/features/class/domain/entities/class_entity_test.dart`
    - Generate arbitrary ints for `type`; assert `typeName` returns `"Boys"` for 1, `"Girls"` for 2, `"Unknown"` otherwise; same for `modeName`
    - Tag: `// Feature: class-management, Property 4: typeName and modeName for all ints`
    - _Requirements: 1.4, 1.5_

  - [ ]* 14.5 Write property test for envelope unwrap preserves N items (Property 5)
    - File: `test/features/class/data/datasources/class_remote_datasource_test.dart`
    - Mock `ApiClient.get` to return `{ 'value': listOf(N valid item maps) }`; assert returned list length == N and field values match
    - Tag: `// Feature: class-management, Property 5: envelope unwrap preserves all items`
    - _Requirements: 2.1, 4.2, 4.3_

  - [ ]* 14.6 Write property test for non-list envelope value returns empty list (Property 6)
    - File: same as 14.5
    - Generate non-list values for `response['value']` (`null`, absent, `int`, `String`, `Map`); assert `getAllClasses()` returns `[]` without throwing
    - Tag: `// Feature: class-management, Property 6: non-list value returns empty list`
    - _Requirements: 2.2_

  - [ ]* 14.7 Write property test for mixed-type envelope items — invalid items skipped (Property 7)
    - File: same as 14.5
    - Generate lists mixing valid `Map<String, dynamic>` items and invalid non-map items; assert only valid items produce `ClassModel` instances; no exception thrown
    - Tag: `// Feature: class-management, Property 7: mixed-type items skipped`
    - _Requirements: 2.3_

  - [ ]* 14.8 Write property test for `createClass` extracts UUID verbatim (Property 8)
    - File: same as 14.5
    - Generate UUID strings; mock `ApiClient.post` to return `{ 'value': uuid }`; assert returned value equals the UUID unchanged
    - Tag: `// Feature: class-management, Property 8: createClass extracts UUID verbatim`
    - _Requirements: 3.2_

  - [ ]* 14.9 Write example-based unit tests for data layer edge cases
    - File: same as 14.5
    - `createClass` — `response['value']` is `null` or non-string → `ServerException` with message `'Invalid response: missing class ID'` (Req 3.3)
    - `ClassRepositoryImpl.createClass` — data source returns ID → `Right(id)` (Req 3.5)
    - `ClassRepositoryImpl.createClass` — data source throws `ServerException` → `Left(ServerFailure(...))` (Req 3.6)

- [ ] 15. Write widget tests for `ClassesScreen` (Properties 9–10)
  - [~] 15.1 Write property test for RBAC — `_canManage` matches Admin/Supervisor role (Property 9)
    - File: `test/screens/classes_screen_test.dart`
    - For all role strings: assert FAB and delete icons present only when role is `"Admin"` or `"Supervisor"`; absent for any other string, missing/expired token, or malformed JWT
    - Tag: `// Feature: class-management, Property 9: _canManage iff Admin or Supervisor`
    - _Requirements: 5.1–5.7_

  - [ ]* 15.2 Write property test for class card renders all required fields (Property 10)
    - File: same as 15.1
    - Generate random `ClassEntity` instances; pump `ClassesScreen` in `ClassesLoaded([entity])` state; assert card shows `entity.name`, `entity.typeName`, `entity.modeName`, `"${entity.studentCount} students"`
    - Tag: `// Feature: class-management, Property 10: card renders all required fields`
    - _Requirements: 6.7_

  - [ ]* 15.3 Write example-based widget tests for `ClassesScreen` states and interactions
    - File: same as 15.1
    - `ClassLoading` → `CircularProgressIndicator` visible (Req 6.2)
    - `ClassesLoaded([])` → `"No classes found"` (Req 6.4)
    - `ClassError` → error text + Retry button; tapping Retry dispatches `GetAllClassesEvent` (Req 6.6)
    - `ClassesLoaded(list)` → `"${list.length} classes"` header + N cards (Req 6.3, 6.5)
    - `GetAllClassesEvent` dispatched on mount (Req 6.1)
    - `_canManage = true` → FAB and delete icons visible (Req 5.4, 5.6)
    - `_canManage = false` → FAB and delete icons absent (Req 5.5, 5.7)
    - Delete icon tap → `AlertDialog` with class name (Req 7.1)
    - AlertDialog "Delete" → `DeleteClassEvent` dispatched (Req 7.2)
    - AlertDialog "Cancel" → no event dispatched (Req 7.4)
    - `ClassLoading` after delete → delete buttons disabled (Req 7.6)
    - `ClassError` after delete → `SnackBar` shown (Req 7.5)

- [ ] 16. Write widget tests for `AddClassScreen` (Properties 11–12)
  - [~] 16.1 Write property test for whitespace-only name is always rejected (Property 11)
    - File: `test/screens/add_class_screen_test.dart`
    - Generate strings composed entirely of whitespace characters (space, tab, `\n`, `\r`, non-breaking space); fill name field; tap Submit; assert inline validation error shown and no `CreateClassEvent` dispatched
    - Tag: `// Feature: class-management, Property 11: whitespace-only name rejected`
    - _Requirements: 8.1_

  - [ ]* 16.2 Write property test for valid submission dispatches correct `CreateClassEvent` (Property 12)
    - File: same as 16.1
    - For each combination of `type ∈ {1, 2}` and `mode ∈ {1, 2}` and a generated valid name (non-empty, ≤ 100 non-whitespace chars): fill form, tap Submit; assert exactly one `CreateClassEvent` dispatched with exact `int` values and trimmed name
    - Tag: `// Feature: class-management, Property 12: valid submit dispatches correct event`
    - _Requirements: 8.7, 1.12, 1.13_

  - [ ]* 16.3 Write example-based widget tests for `AddClassScreen` states and validation
    - File: same as 16.1
    - Empty name → inline validation error, no event (Req 8.4)
    - No type selected → inline validation error, no event (Req 8.5)
    - No mode selected → inline validation error, no event (Req 8.6)
    - `ClassLoading` after submit → Submit button disabled with `CircularProgressIndicator` (Req 8.8)
    - `ClassOperationSuccess` → `Navigator.pop` called (Req 8.9)
    - `ClassError` → `SnackBar` shown, form values preserved (Req 8.11)

- [~] 17. Final checkpoint — all tests pass
  - Run `flutter test test/features/class/ test/screens/` and fix any failures.
  - Ensure `flutter analyze` reports no issues across the entire `lib/` tree.
  - Ask the user if any questions arise.

---

## Notes

- Tasks marked with `*` are optional and can be skipped for a faster MVP iteration.
- Tasks 1–8 (Track 1) are independent of each other and can be worked in any order within the track, but ALL must be complete before starting Task 10 (Track 2).
- Tasks 10–12 (Track 2) must be done in order: shell provider first, then screen rewrites.
- Each property test must carry the tag comment `// Feature: class-management, Property N: ...` as specified in the design.
- The `fast_check` package must be added as a `dev_dependency` if not already present.
- All correctness properties are defined in `design.md` — the implementation task for each property test references the exact property number.

---

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1", "2", "3", "4", "7"] },
    { "id": 1, "tasks": ["5", "6", "8"] },
    { "id": 2, "tasks": ["10"] },
    { "id": 3, "tasks": ["11"] },
    { "id": 4, "tasks": ["12"] },
    { "id": 5, "tasks": ["14.1", "14.4", "14.5", "15.1", "16.1"] },
    { "id": 6, "tasks": ["14.2", "14.3", "14.6", "14.7", "14.8", "14.9", "15.2", "15.3", "16.2", "16.3"] }
  ]
}
```
