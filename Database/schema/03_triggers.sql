/*
    Minimal trigger skeletons for audit and workflow consistency.
*/

CREATE OR ALTER TRIGGER ais.TRG_Excuses_ApplyApprovedStatus
ON ais.Excuses
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
       SET AttendanceStatusId = s.AttendanceStatusId,
           SourceCode = N'System',
           MarkedAtUtc = sysutcdatetime()
    FROM ais.Attendance a
    INNER JOIN inserted i ON i.AttendanceId = a.AttendanceId
    INNER JOIN ais.AttendanceStatuses s ON s.StatusCode = N'Excused'
    WHERE i.StatusCode = N'Approved';
END;
GO

CREATE OR ALTER TRIGGER ais.TRG_Attendance_Audit
ON ais.Attendance
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ais.AuditLog (ActorUserId, ActionCode, EntityName, EntityKey, NewValueJson)
    SELECT
        i.MarkedByUserId,
        N'ATTENDANCE_CHANGED',
        N'Attendance',
        CONVERT(nvarchar(128), i.AttendanceId),
        CONCAT(N'{"lessonId":', i.LessonId, N',"studentId":', i.StudentId, N',"status":', i.AttendanceStatusId, N'}')
    FROM inserted i;
END;
GO
