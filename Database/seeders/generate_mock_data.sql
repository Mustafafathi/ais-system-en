/*
    Synthetic data only. Do not replace these rows with real students,
    phone numbers, emails, access cards, or institutional identifiers.
*/

INSERT INTO ais.Departments (DepartmentCode, DepartmentName)
VALUES (N'DEPT_001', N'Department_001');

INSERT INTO ais.AcademicGroups (DepartmentId, GroupCode, AdmissionYear)
VALUES (1, N'Group_001', 2026);

INSERT INTO ais.AttendanceStatuses (AttendanceStatusId, StatusCode, StatusName)
VALUES
    (1, N'Present', N'Present'),
    (2, N'Absent', N'Absent'),
    (3, N'Late', N'Late'),
    (4, N'Excused', N'Excused Absence');

INSERT INTO ais.Students (GroupId, ExternalStudentKey, DisplayName)
VALUES
    (1, N'STUDENT_001', N'Student_001'),
    (1, N'STUDENT_002', N'Student_002'),
    (1, N'STUDENT_003', N'Student_003');

INSERT INTO ais.Teachers (DepartmentId, ExternalTeacherKey, DisplayName)
VALUES (1, N'TEACHER_001', N'Teacher_001');

INSERT INTO ais.Subjects (SubjectCode, SubjectName)
VALUES (N'SUBJECT_001', N'Subject_001');

INSERT INTO ais.Rooms (RoomCode, BuildingCode, Capacity)
VALUES (N'ROOM_001', N'BUILDING_001', 30);
