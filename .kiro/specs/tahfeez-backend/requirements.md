# Requirements Document

## Introduction

Tahfeez is a Quran memorization management backend system built on ASP.NET Core using clean architecture (API, Application, Domain, Infrastructure, SharedKernel). The system manages users across multiple roles, memorization classes, attendance tracking, recitation grading, subscription and salary management, badge awards, competitions, educational content, messaging, and monthly assessments. Authentication is handled via OpenIddict OAuth/OIDC with JWT bearer validation, and all data is persisted in MySQL via EF Core.

## Glossary

- **System**: The Tahfeez backend API as a whole.
- **API**: The ASP.NET Core Web API layer exposing HTTP endpoints.
- **Application**: The MediatR-based application layer containing commands, queries, and validators.
- **Domain**: The domain layer containing entities, enums, and business rules.
- **Infrastructure**: The EF Core persistence, Hangfire jobs, and external integrations layer.
- **SharedKernel**: Shared base types, result wrappers, and interfaces used across layers.
- **User**: A registered account with one of the defined roles.
- **Admin**: A User with the Admin role; has full system access.
- **Teacher**: A User with the Teacher role; manages assigned classes and students.
- **Student**: A User with the Student role; participates in classes and recitations.
- **Parent**: A User with the Parent role; views records of linked child Students.
- **Accountant**: A User with the Accountant role; manages financial records.
- **Supervisor**: A User with the Supervisor role; views all academic records.
- **Assistant**: A User with the Assistant role; assists Teachers in assigned classes.
- **Class**: A memorization class with assigned staff and enrolled Students.
- **Attendance**: A record of a Student's presence or absence for a specific date.
- **Recitation**: A logged recitation session with a grade for a Student.
- **Subscription**: A financial subscription record for a Student.
- **Payment**: A payment transaction linked to a Subscription.
- **Salary**: A monthly salary record for a Teacher or staff member.
- **Badge**: An award granted to a Student based on recitation performance thresholds.
- **Competition**: A memorization competition event with entries and rankings.
- **CompetitionEntry**: A Student's entry into a Competition.
- **EducationalContent**: A piece of educational material categorized by ContentCategory.
- **Message**: An internal message between Users.
- **MonthlyQuestion**: A monthly assessment question.
- **QuestionAnswer**: A Student's answer to a MonthlyQuestion.
- **GradeBookSettings**: Per-Teacher configuration for grade calculation.
- **BaseEntity**: Base type with Guid PK, createdAt, updatedAt.
- **AuditableEntity**: Extends BaseEntity with createdBy, updatedBy, isDeleted, deletedAt.
- **ISoftDeletable**: Interface marking entities for soft delete with isDeleted and deletedAt fields.
- **IFullAudit**: Interface marking entities for full audit tracking.
- **Result**: A wrapper type representing success or failure of an operation.
- **ProblemDetails**: RFC 7807 error response format.
- **Hangfire**: Background job scheduler used for monthly badge calculation.
- **MediatR**: Mediator library used for command/query dispatch in the Application layer.
- **FluentValidation**: Validation library used for request validation in the Application layer.
- **OpenIddict**: OAuth/OIDC server library used for authentication token issuance.
- **EF Core**: Entity Framework Core ORM used for MySQL persistence.

---

## Requirements

### Requirement 1: Project Structure and Architecture

**User Story:** As a developer, I want the system to follow clean architecture with clearly separated layers, so that the codebase is maintainable and testable.

#### Acceptance Criteria

1. THE System SHALL be organized into five projects: `Tahfeez.Api`, `Tahfeez.Application`, `Tahfeez.Domain`, `Tahfeez.Infrastructure`, and `Tahfeez.SharedKernel`.
2. THE System SHALL include two test projects: `Tahfeez.Api.Test` and `Tahfeez.Application.Test`.
3. THE SharedKernel SHALL define `BaseEntity` with a Guid primary key, `createdAt`, and `updatedAt` fields.
4. THE SharedKernel SHALL define `AuditableEntity` extending `BaseEntity` with `createdBy`, `updatedBy`, `isDeleted`, and `deletedAt` fields.
5. THE SharedKernel SHALL define a `Result` wrapper type representing either a success value or a failure with an error message.
6. IF an unhandled exception occurs, THEN THE API SHALL return an RFC 7807 ProblemDetails response.
7. THE Infrastructure SHALL use EF Core with a MySQL provider for all data persistence.
8. THE Infrastructure SHALL apply global query filters to exclude soft-deleted records from all queries on `ISoftDeletable` entities.
9. THE Infrastructure SHALL use an EF Core interceptor to automatically populate audit fields (`createdAt`, `updatedAt`, `createdBy`, `updatedBy`, `deletedAt`) on save.

---

### Requirement 2: Authentication and Token Issuance

**User Story:** As a user, I want to authenticate and receive a JWT token, so that I can access protected API endpoints.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/auth/register` for new user registration.
2. WHEN a registration request is received, THE API SHALL create the User with status `Pending` and return a success response.
3. THE API SHALL expose `POST /connect/token` for OAuth token issuance via OpenIddict.
4. WHEN valid credentials are submitted to `POST /connect/token`, THE API SHALL return a JWT access token and a refresh token.
5. WHEN an expired access token and a valid refresh token are submitted, THE API SHALL issue a new access token.
6. THE API SHALL validate JWT bearer tokens on all protected endpoints using ASP.NET Core JWT bearer middleware.
7. WHEN a User with status `Pending` authenticates and calls a protected endpoint, THE API SHALL return HTTP 403 with error code `account_pending`.

---

### Requirement 3: Role and User Seeding

**User Story:** As a system operator, I want roles and a default admin account seeded at startup, so that the system is immediately usable after deployment.

#### Acceptance Criteria

1. WHEN the application starts, THE Infrastructure SHALL seed the following roles if they do not exist: `Admin`, `Teacher`, `Student`, `Parent`, `Accountant`, `Supervisor`, `Assistant`.
2. WHEN the application starts, THE Infrastructure SHALL seed a default Admin User with email `admin@tahfeez.com`, password `Admin@123456`, fullName `Admin User`, role `Admin`, and status `Active` if the User does not already exist.

---

### Requirement 4: User Management

**User Story:** As an Admin, I want to manage user accounts, so that I can control who has access to the system.

#### Acceptance Criteria

1. THE API SHALL expose CRUD endpoints at `/api/users` restricted to the `Admin` role.
2. WHEN an Admin creates a User, THE API SHALL accept a `RegisterRequest` DTO with email, password, fullName, and role fields.
3. WHEN an Admin updates a User's status to `Active`, THE User SHALL be permitted to access protected endpoints.
4. WHEN an Admin soft-deletes a User, THE Infrastructure SHALL set `isDeleted = true` and `deletedAt` to the current UTC timestamp without removing the database record.
5. THE API SHALL return User records excluding soft-deleted entries in all list and detail responses.

---

### Requirement 5: Class Management

**User Story:** As an Admin or Supervisor, I want to manage memorization classes, so that students can be organized into learning groups.

#### Acceptance Criteria

1. THE API SHALL expose CRUD endpoints at `/api/classes` accessible to `Admin` and `Supervisor` roles.
2. WHEN a Class is created, THE API SHALL accept classType, classMode, and staff assignment fields.
3. WHEN a staff member is assigned to a Class, THE Application SHALL verify that the assigned User holds one of the roles `Teacher`, `Assistant`, or `Supervisor`.
4. IF a staff assignment is attempted with a User who does not hold an appropriate role, THEN THE Application SHALL return a failure Result with a descriptive error message.
5. THE API SHALL support listing all Classes with their enrolled Students and assigned staff.

---

### Requirement 6: Student Enrollment and Lifecycle

**User Story:** As a Teacher or Admin, I want to manage student enrollment in classes, so that students are correctly assigned and tracked.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/students/{id}/activate` to activate a Student account, restricted to `Admin`.
2. THE API SHALL expose `POST /api/students/{id}/assign-class` to assign a Student to a Class.
3. WHEN a Student is assigned to a Class, THE Application SHALL set the Student's `joinDate` to the current UTC date.
4. THE API SHALL expose `POST /api/students/{id}/transfer` to transfer a Student from one Class to another.
5. THE API SHALL expose `POST /api/students/{id}/promote` to promote a Student to the next level.
6. WHEN a Teacher accesses student endpoints, THE Application SHALL restrict results to Students enrolled in Classes assigned to that Teacher.
7. WHEN a Parent accesses student endpoints, THE Application SHALL restrict results to the Students linked to that Parent.

---

### Requirement 7: Attendance Tracking

**User Story:** As a Teacher, I want to record and update student attendance, so that participation is accurately tracked.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/attendance` to record an Attendance entry, accessible to `Teacher` and `Assistant` roles.
2. WHEN an Attendance entry is recorded, THE Application SHALL enforce uniqueness of the combination of userId and date; IF a duplicate is submitted, THEN THE Application SHALL return a failure Result with error `attendance_duplicate`.
3. THE API SHALL expose `PUT /api/attendance/{id}` to update an existing Attendance entry's status.
4. THE API SHALL expose `GET /api/attendance/reports` to retrieve attendance reports filtered by classId and date range.
5. WHEN a Teacher requests attendance records, THE Application SHALL return only records for Students in Classes assigned to that Teacher.

---

### Requirement 8: Recitation Logging

**User Story:** As a Teacher, I want to log recitation sessions with grades, so that student progress is recorded.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/recitations` to log a Recitation, accessible to `Teacher` and `Assistant` roles.
2. WHEN a Recitation is logged, THE Application SHALL record the recitationType, grade, surahStart, ayahStart, surahEnd, ayahEnd, and notes fields.
3. THE API SHALL expose `GET /api/recitations` to list Recitations filtered by studentId and date range.
4. WHEN a Teacher requests recitation records, THE Application SHALL return only records for Students in Classes assigned to that Teacher.
5. WHEN a Student requests recitation records, THE Application SHALL return only that Student's own records.

---

### Requirement 9: Subscription and Payment Management

**User Story:** As an Accountant or Admin, I want to manage student subscriptions and payments, so that financial records are accurate.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/subscriptions` to create a Subscription, restricted to `Admin` and `Accountant` roles.
2. THE API SHALL expose `GET /api/subscriptions` to list Subscriptions, restricted to `Admin` and `Accountant` roles.
3. THE API SHALL expose `GET /api/subscriptions/overdue` to list Subscriptions past their due date with no associated Payment, restricted to `Admin` and `Accountant` roles.
4. WHEN a Subscription's due date has passed and no Payment record exists for it, THE Application SHALL classify the Subscription as overdue.

---

### Requirement 10: Salary Management

**User Story:** As an Accountant or Admin, I want to manage staff salaries, so that payroll records are maintained.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/salaries` to create a Salary record, restricted to `Admin` and `Accountant` roles.
2. WHEN a Salary record is created, THE Application SHALL enforce uniqueness of the combination of userId and month; IF a duplicate is submitted, THEN THE Application SHALL return a failure Result with error `salary_duplicate`.
3. THE API SHALL expose `POST /api/salaries/{id}/mark-paid` to update a Salary record's status to `Paid`.
4. THE API SHALL expose `GET /api/salaries` to list Salary records filtered by userId and month, restricted to `Admin` and `Accountant` roles.

---

### Requirement 11: Badge Calculation and Awards

**User Story:** As a Student, I want to receive badges based on my recitation performance, so that my achievements are recognized.

#### Acceptance Criteria

1. THE Infrastructure SHALL schedule a Hangfire background job to run monthly at 02:00 UTC to calculate and award Badges.
2. WHEN the badge calculation job runs, THE Application SHALL evaluate each Student's recitation grades against defined BadgeType thresholds.
3. WHEN a Student's recitation grades meet the threshold for a BadgeType, THE Application SHALL create a Badge record for that Student if one does not already exist for the current month.
4. THE API SHALL expose `GET /api/badges` to list Badges for a Student, accessible to `Student`, `Teacher`, `Supervisor`, and `Admin` roles.
5. THE API SHALL expose `GET /api/badges/class/{classId}` to list Badges for all Students in a Class, accessible to `Teacher`, `Supervisor`, and `Admin` roles.
6. THE API SHALL expose `POST /api/badges/recalculate` to trigger badge recalculation on demand, restricted to `Admin`.

---

### Requirement 12: Competitions

**User Story:** As an Admin or Supervisor, I want to manage memorization competitions, so that students can participate in structured events.

#### Acceptance Criteria

1. THE API SHALL expose CRUD endpoints at `/api/competitions`, restricted to `Admin` and `Supervisor` roles for create, update, and delete operations.
2. THE API SHALL expose `POST /api/competitions/{id}/entries` to submit a CompetitionEntry for a Student.
3. WHEN a CompetitionEntry is submitted, THE Application SHALL verify the Student is enrolled in an active Class.
4. THE API SHALL expose `GET /api/competitions/{id}/ranking` to retrieve the ranked list of CompetitionEntries ordered by score descending.

---

### Requirement 13: Educational Content

**User Story:** As a Teacher or Admin, I want to manage educational content, so that students have access to learning materials.

#### Acceptance Criteria

1. THE API SHALL expose CRUD endpoints at `/api/educational-content`, restricted to `Teacher`, `Supervisor`, and `Admin` roles for create, update, and delete operations.
2. THE API SHALL expose `GET /api/educational-content` to list EducationalContent items, accessible to all authenticated Users.
3. WHEN a content list request includes a `category` query parameter, THE Application SHALL filter results to EducationalContent items matching the specified ContentCategory.

---

### Requirement 14: Internal Messaging

**User Story:** As a user, I want to send and receive internal messages, so that I can communicate within the platform.

#### Acceptance Criteria

1. THE API SHALL expose `POST /api/messages` to send a Message from the authenticated User to one or more recipients.
2. THE API SHALL expose `GET /api/messages/inbox` to list Messages received by the authenticated User.
3. THE API SHALL expose `GET /api/messages/sent` to list Messages sent by the authenticated User.
4. THE API SHALL expose `GET /api/messages/thread/{id}` to retrieve a message thread by its root Message id.
5. THE API SHALL expose `POST /api/messages/{id}/read` to mark a Message as read by the authenticated User.
6. THE API SHALL expose `DELETE /api/messages/{id}` to soft-delete a Message for the authenticated User.
7. WHEN a User requests inbox or sent messages, THE Application SHALL return only Messages where the authenticated User is the recipient or sender respectively.

---

### Requirement 15: Monthly Questions and Answers

**User Story:** As a Teacher, I want to create monthly assessment questions and grade student answers, so that monthly progress is evaluated.

#### Acceptance Criteria

1. THE API SHALL expose CRUD endpoints at `/api/monthly-questions`, restricted to `Teacher`, `Supervisor`, and `Admin` roles for create, update, and delete operations.
2. THE API SHALL expose `POST /api/monthly-questions/{id}/answers` to submit a QuestionAnswer for a Student.
3. WHEN a QuestionAnswer is submitted, THE Application SHALL record the studentId, answer text, and submission timestamp.
4. THE API SHALL expose `POST /api/monthly-questions/{id}/answers/{answerId}/grade` to assign a grade to a QuestionAnswer, restricted to `Teacher`, `Supervisor`, and `Admin` roles.
5. WHEN a Student submits an answer, THE Application SHALL restrict the studentId to the authenticated Student's own id.

---

### Requirement 16: GradeBook Settings

**User Story:** As a Teacher, I want to configure my grade calculation settings, so that grading reflects my class's criteria.

#### Acceptance Criteria

1. THE API SHALL expose `PUT /api/gradebook-settings` to create or update GradeBookSettings for the authenticated Teacher.
2. WHEN a GradeBookSettings upsert is requested, THE Application SHALL associate the settings with the authenticated Teacher's userId.
3. WHEN a GradeBookSettings upsert is requested for a Teacher who already has settings, THE Application SHALL update the existing record rather than creating a duplicate.

---

### Requirement 17: Diagnostics

**User Story:** As a system operator, I want health and version endpoints, so that I can monitor the system's status.

#### Acceptance Criteria

1. THE API SHALL expose `GET /api/diagnostics/health` returning HTTP 200 with a health status payload when all dependencies are reachable.
2. THE API SHALL expose `GET /api/diagnostics/version` returning the current application version string.

---

### Requirement 18: Validation

**User Story:** As an API consumer, I want clear validation errors on bad requests, so that I can correct my input.

#### Acceptance Criteria

1. THE Application SHALL use FluentValidation validators for all command and query request DTOs.
2. WHEN a request fails validation, THE API SHALL return HTTP 400 with a ProblemDetails body listing all validation errors.
3. THE Application SHALL validate that all Guid fields in requests are non-empty.
4. THE Application SHALL validate that date fields are not in the future where a past or present date is required.
5. THE Application SHALL validate that monetary amount fields are greater than zero.
6. THE Application SHALL validate that text fields do not exceed their defined maximum lengths.
7. THE Application SHALL validate that password fields meet the minimum complexity requirement of at least 8 characters, one uppercase letter, one digit, and one special character.
8. THE Application SHALL validate that enum fields contain only defined enum values.

---

### Requirement 19: Authorization Matrix Enforcement

**User Story:** As a system designer, I want resource-level authorization enforced in handlers, so that users can only access data they are permitted to see.

#### Acceptance Criteria

1. WHEN a Student calls any data endpoint, THE Application SHALL return only records owned by or associated with that Student.
2. WHEN a Parent calls any data endpoint, THE Application SHALL return only records associated with Students linked to that Parent.
3. WHEN a Teacher calls any data endpoint, THE Application SHALL return only records associated with Classes or Students assigned to that Teacher.
4. WHEN an Assistant calls any data endpoint, THE Application SHALL return only records associated with Classes or Students assigned to that Assistant.
5. WHEN a Supervisor calls any academic data endpoint, THE Application SHALL return all academic records without class-level restriction.
6. WHEN an Accountant calls any financial endpoint, THE Application SHALL return all financial records.
7. IF a User attempts to access a record outside their permitted scope, THEN THE API SHALL return HTTP 403.

---

### Requirement 20: Soft Delete

**User Story:** As a system operator, I want all deletions to be soft deletes, so that data is recoverable and audit trails are preserved.

#### Acceptance Criteria

1. THE Infrastructure SHALL implement soft delete for all entities implementing `ISoftDeletable` by setting `isDeleted = true` and `deletedAt` to the current UTC timestamp instead of issuing a SQL DELETE.
2. THE Infrastructure SHALL apply a global EF Core query filter on all `ISoftDeletable` entities to exclude records where `isDeleted = true` from all standard queries.
3. WHEN a soft-deleted entity is queried directly by id, THE API SHALL return HTTP 404.

---

### Requirement 21: Audit Logging

**User Story:** As a system operator, I want all entity changes to be audited automatically, so that I can trace who made what change and when.

#### Acceptance Criteria

1. THE Infrastructure SHALL automatically set `createdAt` and `createdBy` on insert for all `IFullAudit` entities via an EF Core save interceptor.
2. THE Infrastructure SHALL automatically update `updatedAt` and `updatedBy` on update for all `IFullAudit` entities via an EF Core save interceptor.
3. THE Infrastructure SHALL automatically set `deletedAt` on soft delete for all `IFullAudit` entities via an EF Core save interceptor.

---

### Requirement 22: Parsers and Serialization

**User Story:** As a developer, I want all enums serialized as numeric values in JSON, so that API consumers receive consistent, compact payloads.

#### Acceptance Criteria

1. THE API SHALL serialize all enum values as their underlying numeric integer in JSON responses.
2. THE API SHALL deserialize numeric integer values in JSON request bodies to their corresponding enum types.
3. FOR ALL enum values, serializing then deserializing SHALL produce the original enum value (round-trip property).
4. THE Application SHALL define the following enums with numeric serialization: `AttendanceStatus`, `BadgeType`, `ClassMode`, `ClassType`, `ContentCategory`, `PaymentMethod`, `RecitationType`, `SalaryStatus`, `SubscriptionMode`, `SubscriptionType`, `UserRole`, `UserStatus`.
