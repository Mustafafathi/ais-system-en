/*
    Minimal stored procedure skeletons for the anonymized schema.
    The full academic implementation uses the same architectural principle:
    PHP transports requests; SQL Server procedures enforce business rules.
*/

CREATE OR ALTER PROCEDURE ais.CheckRolePermission
    @UserId int,
    @PermissionCode nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CASE WHEN EXISTS (
            SELECT 1
            FROM ais.UserRoles ur
            INNER JOIN ais.RolePermissions rp ON rp.RoleId = ur.RoleId
            INNER JOIN ais.Permissions p ON p.PermissionId = rp.PermissionId
            WHERE ur.UserId = @UserId
              AND p.PermissionCode = @PermissionCode
        ) THEN 1 ELSE 0 END AS IsAllowed;
END;
GO

CREATE OR ALTER PROCEDURE ais.MarkAttendance
    @LessonId bigint,
    @StudentId int,
    @AttendanceStatusId tinyint,
    @MarkedByUserId int,
    @SourceCode nvarchar(32) = N'Manual',
    @ClientIp varchar(45) = NULL,
    @UserAgent nvarchar(512) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    MERGE ais.Attendance AS target
    USING (SELECT @LessonId AS LessonId, @StudentId AS StudentId) AS source
       ON target.LessonId = source.LessonId
      AND target.StudentId = source.StudentId
    WHEN MATCHED THEN
        UPDATE SET
            AttendanceStatusId = @AttendanceStatusId,
            MarkedAtUtc = sysutcdatetime(),
            MarkedByUserId = @MarkedByUserId,
            SourceCode = @SourceCode
    WHEN NOT MATCHED THEN
        INSERT (LessonId, StudentId, AttendanceStatusId, MarkedByUserId, SourceCode)
        VALUES (@LessonId, @StudentId, @AttendanceStatusId, @MarkedByUserId, @SourceCode);

    INSERT INTO ais.AuditLog (ActorUserId, ActionCode, EntityName, EntityKey, ClientIp, UserAgent, NewValueJson)
    VALUES (
        @MarkedByUserId,
        N'ATTENDANCE_MARKED',
        N'Attendance',
        CONCAT(@LessonId, N':', @StudentId),
        @ClientIp,
        @UserAgent,
        CONCAT(N'{"status":', @AttendanceStatusId, N',"source":"', @SourceCode, N'"}')
    );

    COMMIT TRANSACTION;
END;
GO
