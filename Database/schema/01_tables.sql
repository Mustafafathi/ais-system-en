/*
    University Attendance Management System
    Clean anonymized SQL Server schema skeleton.

    This file intentionally contains no INSERT statements, no real names,
    no phone numbers, no emails, no internal IP addresses, and no local paths.
*/

CREATE SCHEMA ais;
GO

CREATE TABLE ais.Departments (
    DepartmentId       int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Departments PRIMARY KEY,
    DepartmentCode     nvarchar(32) NOT NULL CONSTRAINT UQ_Departments_Code UNIQUE,
    DepartmentName     nvarchar(200) NOT NULL,
    IsActive           bit NOT NULL CONSTRAINT DF_Departments_IsActive DEFAULT (1),
    CreatedAtUtc       datetime2(0) NOT NULL CONSTRAINT DF_Departments_CreatedAt DEFAULT (sysutcdatetime())
);
GO

CREATE TABLE ais.AcademicGroups (
    GroupId            int IDENTITY(1,1) NOT NULL CONSTRAINT PK_AcademicGroups PRIMARY KEY,
    DepartmentId       int NOT NULL,
    GroupCode          nvarchar(32) NOT NULL CONSTRAINT UQ_AcademicGroups_Code UNIQUE,
    AdmissionYear      smallint NOT NULL,
    IsActive           bit NOT NULL CONSTRAINT DF_AcademicGroups_IsActive DEFAULT (1),
    CONSTRAINT FK_AcademicGroups_Departments
        FOREIGN KEY (DepartmentId) REFERENCES ais.Departments(DepartmentId),
    CONSTRAINT CK_AcademicGroups_AdmissionYear CHECK (AdmissionYear BETWEEN 2000 AND 2100)
);
GO

CREATE TABLE ais.Students (
    StudentId          int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Students PRIMARY KEY,
    GroupId            int NOT NULL,
    ExternalStudentKey nvarchar(64) NOT NULL CONSTRAINT UQ_Students_ExternalKey UNIQUE,
    DisplayName        nvarchar(200) NOT NULL,
    EnrollmentStatus   nvarchar(32) NOT NULL CONSTRAINT DF_Students_Status DEFAULT ('Active'),
    CreatedAtUtc       datetime2(0) NOT NULL CONSTRAINT DF_Students_CreatedAt DEFAULT (sysutcdatetime()),
    CONSTRAINT FK_Students_Groups FOREIGN KEY (GroupId) REFERENCES ais.AcademicGroups(GroupId),
    CONSTRAINT CK_Students_Status CHECK (EnrollmentStatus IN ('Active', 'AcademicLeave', 'Graduated', 'Expelled'))
);
GO

CREATE TABLE ais.Teachers (
    TeacherId          int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Teachers PRIMARY KEY,
    DepartmentId       int NOT NULL,
    ExternalTeacherKey nvarchar(64) NOT NULL CONSTRAINT UQ_Teachers_ExternalKey UNIQUE,
    DisplayName        nvarchar(200) NOT NULL,
    IsActive           bit NOT NULL CONSTRAINT DF_Teachers_IsActive DEFAULT (1),
    CONSTRAINT FK_Teachers_Departments FOREIGN KEY (DepartmentId) REFERENCES ais.Departments(DepartmentId)
);
GO

CREATE TABLE ais.Subjects (
    SubjectId          int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Subjects PRIMARY KEY,
    SubjectCode        nvarchar(32) NOT NULL CONSTRAINT UQ_Subjects_Code UNIQUE,
    SubjectName        nvarchar(200) NOT NULL,
    IsActive           bit NOT NULL CONSTRAINT DF_Subjects_IsActive DEFAULT (1)
);
GO

CREATE TABLE ais.Rooms (
    RoomId             int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Rooms PRIMARY KEY,
    RoomCode           nvarchar(64) NOT NULL CONSTRAINT UQ_Rooms_Code UNIQUE,
    BuildingCode       nvarchar(64) NOT NULL,
    Capacity           int NULL,
    CONSTRAINT CK_Rooms_Capacity CHECK (Capacity IS NULL OR Capacity > 0)
);
GO

CREATE TABLE ais.Lessons (
    LessonId           bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Lessons PRIMARY KEY,
    GroupId            int NOT NULL,
    SubjectId          int NOT NULL,
    TeacherId          int NOT NULL,
    RoomId             int NULL,
    StartsAtUtc        datetime2(0) NOT NULL,
    EndsAtUtc          datetime2(0) NOT NULL,
    QrSessionId        uniqueidentifier NULL,
    LessonStatus       nvarchar(32) NOT NULL CONSTRAINT DF_Lessons_Status DEFAULT ('Scheduled'),
    CONSTRAINT FK_Lessons_Groups FOREIGN KEY (GroupId) REFERENCES ais.AcademicGroups(GroupId),
    CONSTRAINT FK_Lessons_Subjects FOREIGN KEY (SubjectId) REFERENCES ais.Subjects(SubjectId),
    CONSTRAINT FK_Lessons_Teachers FOREIGN KEY (TeacherId) REFERENCES ais.Teachers(TeacherId),
    CONSTRAINT FK_Lessons_Rooms FOREIGN KEY (RoomId) REFERENCES ais.Rooms(RoomId),
    CONSTRAINT CK_Lessons_Time CHECK (StartsAtUtc < EndsAtUtc),
    CONSTRAINT CK_Lessons_Status CHECK (LessonStatus IN ('Scheduled', 'InProgress', 'Completed', 'Cancelled'))
);
GO

CREATE TABLE ais.AttendanceStatuses (
    AttendanceStatusId tinyint NOT NULL CONSTRAINT PK_AttendanceStatuses PRIMARY KEY,
    StatusCode         nvarchar(32) NOT NULL CONSTRAINT UQ_AttendanceStatuses_Code UNIQUE,
    StatusName         nvarchar(100) NOT NULL
);
GO

CREATE TABLE ais.Attendance (
    AttendanceId       bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Attendance PRIMARY KEY,
    LessonId           bigint NOT NULL,
    StudentId          int NOT NULL,
    AttendanceStatusId tinyint NOT NULL,
    MarkedAtUtc        datetime2(0) NOT NULL CONSTRAINT DF_Attendance_MarkedAt DEFAULT (sysutcdatetime()),
    MarkedByUserId     int NULL,
    SourceCode         nvarchar(32) NOT NULL CONSTRAINT DF_Attendance_Source DEFAULT ('Manual'),
    Comment            nvarchar(500) NULL,
    RowVersion         rowversion NOT NULL,
    CONSTRAINT UQ_Attendance_LessonStudent UNIQUE (LessonId, StudentId),
    CONSTRAINT FK_Attendance_Lessons FOREIGN KEY (LessonId) REFERENCES ais.Lessons(LessonId),
    CONSTRAINT FK_Attendance_Students FOREIGN KEY (StudentId) REFERENCES ais.Students(StudentId),
    CONSTRAINT FK_Attendance_Statuses FOREIGN KEY (AttendanceStatusId) REFERENCES ais.AttendanceStatuses(AttendanceStatusId),
    CONSTRAINT CK_Attendance_Source CHECK (SourceCode IN ('Manual', 'QR', 'Import', 'System'))
);
GO

CREATE TABLE ais.Excuses (
    ExcuseId           bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Excuses PRIMARY KEY,
    AttendanceId       bigint NOT NULL,
    StatusCode         nvarchar(32) NOT NULL CONSTRAINT DF_Excuses_Status DEFAULT ('Pending'),
    StudentComment     nvarchar(1000) NULL,
    ReviewerComment    nvarchar(1000) NULL,
    SubmittedAtUtc     datetime2(0) NOT NULL CONSTRAINT DF_Excuses_SubmittedAt DEFAULT (sysutcdatetime()),
    ReviewedAtUtc      datetime2(0) NULL,
    ReviewedByUserId   int NULL,
    CONSTRAINT FK_Excuses_Attendance FOREIGN KEY (AttendanceId) REFERENCES ais.Attendance(AttendanceId),
    CONSTRAINT CK_Excuses_Status CHECK (StatusCode IN ('Pending', 'Approved', 'Rejected'))
);
GO

CREATE TABLE ais.Users (
    UserId             int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
    LoginName          nvarchar(100) NOT NULL CONSTRAINT UQ_Users_Login UNIQUE,
    PasswordHash       varbinary(32) NOT NULL,
    PasswordSalt       varbinary(32) NOT NULL,
    FailedLoginCount   tinyint NOT NULL CONSTRAINT DF_Users_FailedLogin DEFAULT (0),
    LockedUntilUtc     datetime2(0) NULL,
    StudentId          int NULL,
    TeacherId          int NULL,
    IsActive           bit NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
    CreatedAtUtc       datetime2(0) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (sysutcdatetime()),
    CONSTRAINT FK_Users_Students FOREIGN KEY (StudentId) REFERENCES ais.Students(StudentId),
    CONSTRAINT FK_Users_Teachers FOREIGN KEY (TeacherId) REFERENCES ais.Teachers(TeacherId)
);
GO

CREATE TABLE ais.Roles (
    RoleId             int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Roles PRIMARY KEY,
    RoleCode           nvarchar(64) NOT NULL CONSTRAINT UQ_Roles_Code UNIQUE,
    RoleName           nvarchar(100) NOT NULL
);
GO

CREATE TABLE ais.Permissions (
    PermissionId       int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Permissions PRIMARY KEY,
    PermissionCode     nvarchar(100) NOT NULL CONSTRAINT UQ_Permissions_Code UNIQUE,
    PermissionName     nvarchar(200) NOT NULL
);
GO

CREATE TABLE ais.RolePermissions (
    RoleId             int NOT NULL,
    PermissionId       int NOT NULL,
    CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleId, PermissionId),
    CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleId) REFERENCES ais.Roles(RoleId),
    CONSTRAINT FK_RolePermissions_Permissions FOREIGN KEY (PermissionId) REFERENCES ais.Permissions(PermissionId)
);
GO

CREATE TABLE ais.UserRoles (
    UserId             int NOT NULL,
    RoleId             int NOT NULL,
    AssignedAtUtc      datetime2(0) NOT NULL CONSTRAINT DF_UserRoles_AssignedAt DEFAULT (sysutcdatetime()),
    CONSTRAINT PK_UserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES ais.Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES ais.Roles(RoleId)
);
GO

CREATE TABLE ais.AuditLog (
    AuditLogId         bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_AuditLog PRIMARY KEY,
    OccurredAtUtc      datetime2(0) NOT NULL CONSTRAINT DF_AuditLog_OccurredAt DEFAULT (sysutcdatetime()),
    ActorUserId        int NULL,
    ActionCode         nvarchar(64) NOT NULL,
    EntityName         nvarchar(128) NOT NULL,
    EntityKey          nvarchar(128) NULL,
    ClientIp           varchar(45) NULL,
    UserAgent          nvarchar(512) NULL,
    OldValueJson       nvarchar(max) NULL,
    NewValueJson       nvarchar(max) NULL,
    CONSTRAINT FK_AuditLog_Users FOREIGN KEY (ActorUserId) REFERENCES ais.Users(UserId)
);
GO

CREATE TABLE ais.IntegrationEventNonces (
    Nonce              nvarchar(128) NOT NULL CONSTRAINT PK_IntegrationEventNonces PRIMARY KEY,
    SourceSystemCode   nvarchar(32) NOT NULL,
    ReceivedAtUtc      datetime2(0) NOT NULL CONSTRAINT DF_IntegrationEventNonces_ReceivedAt DEFAULT (sysutcdatetime()),
    ExpiresAtUtc       datetime2(0) NOT NULL,
    PayloadHashSha256  char(64) NOT NULL,
    CONSTRAINT CK_IntegrationEventNonces_Dates CHECK (ReceivedAtUtc < ExpiresAtUtc)
);
GO

CREATE INDEX IX_Students_Group_Status
    ON ais.Students (GroupId, EnrollmentStatus)
    INCLUDE (ExternalStudentKey, DisplayName);
GO

CREATE INDEX IX_Lessons_Group_Date
    ON ais.Lessons (GroupId, StartsAtUtc)
    INCLUDE (SubjectId, TeacherId, RoomId, LessonStatus);
GO

CREATE INDEX IX_Attendance_Status_Lesson
    ON ais.Attendance (AttendanceStatusId, LessonId)
    INCLUDE (StudentId, MarkedAtUtc, SourceCode);
GO

CREATE INDEX IX_Excuses_Pending
    ON ais.Excuses (StatusCode, SubmittedAtUtc)
    INCLUDE (AttendanceId)
    WHERE StatusCode = 'Pending';
GO

CREATE INDEX IX_AuditLog_Date_Entity
    ON ais.AuditLog (OccurredAtUtc, EntityName)
    INCLUDE (ActorUserId, ActionCode, EntityKey, ClientIp);
GO
