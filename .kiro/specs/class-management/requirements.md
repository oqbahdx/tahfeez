# Requirements Document

## Introduction

This feature completes the class management functionality in the Tahfeez Flutter application. The app connects to an ASP.NET Core Web API at `https://alamin.gleeze.com`. Significant portions of the backend wiring (BLoC, use cases, repository, data source) are already scaffolded but contain bugs: `type` and `mode` fields are typed as `String` throughout the stack when the API uses `int`; the `getAllClasses` data source does not unwrap the `{ "value": [...] }` response envelope; `createClass` returns a full `ClassEntity` when the API only returns a new ID string; and the UI screen uses hardcoded mock data instead of real BLoC state. This feature corrects all of those issues and delivers a fully working, role-aware class management screen.

## Glossary

- **ClassBloc**: The Flutter BLoC responsible for all class-related state management.
- **ClassEntity**: The domain-layer representation of a class (id, name, type, mode, studentCount, etc.).
- **ClassModel**: The data-layer model that extends `ClassEntity` and handles JSON serialisation.
- **ClassRemoteDataSource**: The data-layer class that calls the REST API via `ApiClient`.
- **ClassRepositoryImpl**: The data-layer implementation of `ClassRepository` that bridges the data source and the domain.
- **ClassRepository**: The domain-layer abstract interface for class data operations.
- **ApiClient**: The app's Dio-based HTTP client with auth interceptor and automatic token refresh.
- **Result_Envelope**: The JSON wrapper `{ "value": ..., "isSuccess": bool, "error": string }` returned by every API endpoint.
- **Admin**: A user whose JWT `role` claim equals `"Admin"` (server enum value 1). May create and delete classes.
- **Supervisor**: A user whose JWT `role` claim equals `"Supervisor"` (server enum value 6). May create and delete classes.
- **ClassType**: An integer discriminator — `1` = Boys, `2` = Girls.
- **ClassMode**: An integer discriminator — `1` = Online, `2` = Offline.
- **JWT_Decoder**: The `jwt_decoder` package used to decode the stored access token and read claims such as `role`.

---

## Requirements

### Requirement 1: Correct `type` and `mode` field types across all layers

**User Story:** As a developer maintaining the Tahfeez app, I want `type` and `mode` to be `int` in every layer (entity, model, use case, repository, bloc, events), so that the data contract matches the API and values are never silently coerced or misinterpreted.

#### Acceptance Criteria

1. THE `ClassEntity` SHALL declare `type` as `int` and `mode` as `int`.
2. IF a JSON source provides `type` as a non-`int` value (including `null`), THEN `ClassModel.fromJson` SHALL default `type` to `0`.
3. IF a JSON source provides `mode` as a non-`int` value (including `null`), THEN `ClassModel.fromJson` SHALL default `mode` to `0`.
4. THE `ClassEntity` SHALL expose a computed getter `typeName` that returns `"Boys"` WHEN `type == 1`, returns `"Girls"` WHEN `type == 2`, and returns `"Unknown"` for any other value.
5. THE `ClassEntity` SHALL expose a computed getter `modeName` that returns `"Online"` WHEN `mode == 1`, returns `"Offline"` WHEN `mode == 2`, and returns `"Unknown"` for any other value.
6. THE `ClassModel` SHALL parse `type` and `mode` from JSON as `int`, not as `String`.
7. THE `CreateClassUseCase` SHALL accept `type` as `int` and `mode` as `int` in its call signature.
8. THE `ClassRepository` abstract interface SHALL declare `createClass` with `type` as `int` and `mode` as `int`.
9. THE `ClassRepositoryImpl` SHALL implement `createClass` with `type` as `int` and `mode` as `int`.
10. THE `ClassRemoteDataSource` abstract interface SHALL declare `createClass` with `type` as `int` and `mode` as `int`.
11. THE `ClassRemoteDataSourceImpl` SHALL send `type` and `mode` as `int` in the POST body.
12. THE `CreateClassEvent` SHALL carry `type` as `int` and `mode` as `int`.
13. THE `ClassBloc` SHALL pass `int` values for `type` and `mode` when invoking `CreateClassUseCase`.
14. IF the use-case layer receives a `type` value that is not `1` or `2`, THEN `CreateClassUseCase` SHALL propagate the value to the repository unchanged without throwing; validation of allowed values is the responsibility of the UI layer.

---

### Requirement 2: Unwrap the Result Envelope in `getAllClasses`

**User Story:** As a developer, I want `getAllClasses` to correctly parse the server's `{ "value": [...] }` envelope, so that the list of classes is properly extracted and not treated as the raw response map.

#### Acceptance Criteria

1. WHEN `GET /api/classes` returns `{ "value": [...], "isSuccess": true }`, THE `ClassRemoteDataSourceImpl` SHALL extract the list from `response['value']` and parse each item with `ClassModel.fromJson`.
2. IF `response['value']` is `null`, absent, or not a `List`, THEN THE `ClassRemoteDataSourceImpl` SHALL return an empty list rather than throwing.
3. IF any individual item within `response['value']` is not a `Map<String, dynamic>`, THEN THE `ClassRemoteDataSourceImpl` SHALL skip that item and continue parsing the remaining items.
4. THE `ClassModel.fromJson` SHALL NOT expect the raw response map to be a flat list; it SHALL always operate on an individual item map.

---

### Requirement 3: `createClass` returns the new class ID (String), not a full entity

**User Story:** As a developer, I want the `createClass` operation to return the newly created class's ID string (a UUID), so that the caller knows which resource was created without requiring an additional fetch.

#### Acceptance Criteria

1. THE `ClassRemoteDataSource` abstract interface SHALL declare `createClass` with return type `Future<String>`.
2. WHEN `POST /api/classes` returns an HTTP 2xx response with a non-null string in `response['value']`, THE `ClassRemoteDataSourceImpl` SHALL extract that string and return it as the new class ID.
3. IF `response['value']` is `null` or not a `String` after a successful HTTP 2xx, THEN THE `ClassRemoteDataSourceImpl` SHALL throw a `ServerException` with message `"Invalid response: missing class ID"`.
4. THE `ClassRepository` abstract interface SHALL declare `createClass` with return type `Future<Either<Failure, String>>`.
5. WHEN the data source returns a valid ID string, THE `ClassRepositoryImpl` SHALL return `Right(id)`.
6. WHEN the data source throws a `ServerException` or `NetworkException`, THE `ClassRepositoryImpl` SHALL return `Left(ServerFailure(message))` or `Left(NetworkFailure(message))` respectively.
7. THE `CreateClassUseCase` SHALL return `Future<Either<Failure, String>>`.
8. WHEN `ClassBloc` handles `CreateClassEvent` and the use case returns `Right(id)`, THE `ClassBloc` SHALL emit `ClassOperationSuccess` with a message that includes the created class ID.
9. WHEN `ClassBloc` handles `CreateClassEvent` and the use case returns `Left(failure)`, THE `ClassBloc` SHALL emit `ClassError` with the failure message.

---

### Requirement 4: `getAllClasses` always returns a valid list

**User Story:** As a developer, I want `getAllClasses` to always return a `List<ClassEntity>` (never null), so that the UI never needs null-checks on the class list.

#### Acceptance Criteria

1. THE `GetAllClassesUseCase` SHALL return `Future<Either<Failure, List<ClassEntity>>>` and the `List` SHALL never be `null`.
2. WHEN the API returns a `value` array with zero elements, THE `ClassesLoaded` state SHALL carry an empty, non-null `List<ClassEntity>`.
3. WHEN the API returns a `value` array with one or more elements, THE `ClassesLoaded` state SHALL carry a `List<ClassEntity>` with exactly the same number of elements as the array.
4. IF a network or server error occurs before any successful load, THE `ClassBloc` SHALL emit `ClassError` with a message that identifies the failure type (network vs. server), and the bloc SHALL remain in the `ClassError` state with no list emitted.
5. IF a network or server error occurs after at least one successful load, THE `ClassBloc` SHALL emit `ClassError` and the previously emitted `ClassesLoaded` list SHALL remain accessible in the most recently emitted `ClassesLoaded` state (not overwritten).

---

### Requirement 5: Role-based access control for class creation and deletion

**User Story:** As a user of the Tahfeez app, I want the "Add Class" button and delete controls to only appear when I have Admin or Supervisor role, so that lower-privileged users cannot accidentally trigger privileged operations.

#### Acceptance Criteria

1. WHEN `ClassesScreen` initialises, it SHALL read the stored access token via `FlutterSecureStorage` and decode it with `jwt_decoder` to extract the `role` claim.
2. IF no access token is stored, THEN `ClassesScreen` SHALL treat the user as having no privileged role and SHALL NOT render the "Add Class" FAB or any delete controls.
3. IF the stored JWT is expired or cannot be parsed by `jwt_decoder`, THEN `ClassesScreen` SHALL treat the user as having no privileged role and SHALL NOT render the "Add Class" FAB or any delete controls.
4. IF the decoded `role` claim equals `"Admin"` or `"Supervisor"`, THEN `ClassesScreen` SHALL render the "Add Class" FAB.
5. IF the decoded `role` claim is any value other than `"Admin"` or `"Supervisor"`, THEN `ClassesScreen` SHALL NOT render the "Add Class" FAB.
6. IF the decoded `role` claim equals `"Admin"` or `"Supervisor"`, THEN each class card SHALL display a dedicated delete icon button.
7. IF the decoded `role` claim is any value other than `"Admin"` or `"Supervisor"`, THEN class cards SHALL NOT contain any delete icon button or delete affordance.

---

### Requirement 6: Classes screen displays live API data

**User Story:** As an authenticated user, I want to see all classes fetched from the API in a list, so that I always have an up-to-date view of the institution's classes.

#### Acceptance Criteria

1. WHEN `ClassesScreen` is mounted, THE `ClassBloc` SHALL dispatch `GetAllClassesEvent` automatically.
2. WHILE the bloc is in `ClassLoading` state, THE `ClassesScreen` SHALL display a centered `CircularProgressIndicator` and SHALL NOT display a class list or empty-state.
3. WHEN the bloc emits `ClassesLoaded` with a list of N classes (N ≥ 1), THE `ClassesScreen` SHALL display a header reading `"N classes"` (using plural form for all counts).
4. WHEN the bloc emits `ClassesLoaded` with an empty list, THE `ClassesScreen` SHALL display a centred empty-state message reading `"No classes found"` and SHALL NOT display a list.
5. WHEN the bloc emits `ClassesLoaded` with a non-empty list, THE `ClassesScreen` SHALL render a `ListView` containing one card per class.
6. WHEN the bloc emits `ClassError`, THE `ClassesScreen` SHALL display the error message text and a labelled "Retry" button; tapping the Retry button SHALL dispatch `GetAllClassesEvent`.
7. EACH class card SHALL display: the class name, a type badge showing `typeName` from `ClassEntity` (Boys/Girls/Unknown), a mode badge showing `modeName` from `ClassEntity` (Online/Offline/Unknown), and the `studentCount` formatted as `"N students"`.

---

### Requirement 7: Delete a class with confirmation

**User Story:** As an Admin or Supervisor, I want to delete a class after confirming my intent, so that accidental deletions are prevented.

#### Acceptance Criteria

1. WHEN a user taps the delete icon button on a class card, THE `ClassesScreen` SHALL display an `AlertDialog` containing: the text `"Delete class?"`, a body message that includes the class name, a "Cancel" button, and a "Delete" button.
2. WHEN the user taps the "Delete" button in the confirmation dialog, THE `ClassBloc` SHALL dispatch `DeleteClassEvent` with that class's ID, and THE delete icon button for that class SHALL be disabled while `ClassLoading` is in progress.
3. WHEN `ClassBloc` emits `ClassOperationSuccess` in response to a `DeleteClassEvent`, THE `ClassesScreen` SHALL dispatch `GetAllClassesEvent` to refresh the list.
4. WHEN the user taps the "Cancel" button or dismisses the confirmation dialog by tapping outside it, THE `ClassesScreen` SHALL take no action and the dialog SHALL close.
5. IF `ClassBloc` emits `ClassError` after a `DeleteClassEvent`, THEN THE `ClassesScreen` SHALL display a `SnackBar` with the error message for at least 3 seconds.
6. WHILE `ClassBloc` is in `ClassLoading` state following a `DeleteClassEvent`, THE delete icon buttons on all cards SHALL be disabled to prevent concurrent delete dispatches.

---

### Requirement 8: Add Class form screen

**User Story:** As an Admin or Supervisor, I want a dedicated form to create a new class with name, type, and mode, so that I can expand the institution's class roster.

#### Acceptance Criteria

1. THE `AddClassScreen` SHALL provide a text field for the class name; the name SHALL be required, SHALL be between 1 and 100 non-whitespace characters, and SHALL display an inline validation error if the field is empty or contains only whitespace.
2. THE `AddClassScreen` SHALL provide a dropdown for class type with exactly two options: `"Boys"` (maps to int value `1`) and `"Girls"` (maps to int value `2`); no option SHALL be pre-selected on screen open.
3. THE `AddClassScreen` SHALL provide a dropdown for class mode with exactly two options: `"Online"` (maps to int value `1`) and `"Offline"` (maps to int value `2`); no option SHALL be pre-selected on screen open.
4. WHEN the user taps "Submit" with an empty or whitespace-only name field, THE `AddClassScreen` SHALL display an inline validation error on the name field and SHALL NOT dispatch `CreateClassEvent`.
5. WHEN the user taps "Submit" with no type selected, THE `AddClassScreen` SHALL display an inline validation error on the type dropdown and SHALL NOT dispatch `CreateClassEvent`.
6. WHEN the user taps "Submit" with no mode selected, THE `AddClassScreen` SHALL display an inline validation error on the mode dropdown and SHALL NOT dispatch `CreateClassEvent`.
7. WHEN the user taps "Submit" with a valid name (1–100 non-whitespace chars), a selected type, and a selected mode, THE `AddClassScreen` SHALL dispatch `CreateClassEvent` with the `int` values for type and mode and the trimmed name string.
8. WHILE `ClassBloc` is in `ClassLoading` state following a `CreateClassEvent`, THE `AddClassScreen` SHALL disable the Submit button and replace its label with a `CircularProgressIndicator`.
9. WHEN `ClassBloc` emits `ClassOperationSuccess`, THE `AddClassScreen` SHALL call `Navigator.pop` to return to `ClassesScreen`.
10. WHEN `ClassesScreen` receives focus after `AddClassScreen` pops, THE `ClassesScreen` SHALL dispatch `GetAllClassesEvent` to refresh the list.
11. IF `ClassBloc` emits `ClassError` during creation, THEN THE `AddClassScreen` SHALL display a `SnackBar` with the error message, SHALL remain open, and SHALL preserve the current form field values.

---

### Requirement 9: `ClassModel` correctly deserialises individual class items

**User Story:** As a developer, I want `ClassModel.fromJson` to correctly parse all fields including `int` type/mode, so that every class card renders accurate data.

#### Acceptance Criteria

1. WHEN a JSON item contains `"type": 1` as an `int`, THE `ClassModel.fromJson` SHALL set `type` to the integer `1`.
2. WHEN a JSON item contains `"mode": 2` as an `int`, THE `ClassModel.fromJson` SHALL set `mode` to the integer `2`.
3. WHEN a JSON item contains `"studentCount": 12`, THE `ClassModel.fromJson` SHALL set `studentCount` to `12`.
4. IF `"studentCount"` is absent or `null` in the JSON, THEN `ClassModel.fromJson` SHALL set `studentCount` to `0`.
5. IF any required string field (`"id"` or `"name"`) is absent or `null` in the JSON, THEN `ClassModel.fromJson` SHALL set that field to an empty string `""`.
6. FOR ALL valid class JSON objects (where `id`, `name` are non-null strings and `type`, `mode` are ints), parsing with `ClassModel.fromJson` then calling `toJson` then parsing again SHALL produce a `ClassModel` with identical field values (round-trip property).
