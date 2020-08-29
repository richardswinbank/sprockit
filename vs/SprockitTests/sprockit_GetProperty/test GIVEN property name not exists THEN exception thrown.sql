CREATE PROCEDURE sprockit_GetProperty.[test GIVEN property name not exists THEN exception thrown]
AS

-- EXPECT
EXEC tSQLt.ExpectException @ExpectedMessagePattern = '%Property ''prop4'' is not defined%'
DECLARE @actual NVARCHAR(4000)

-- ACT
SELECT @actual = sprockit.GetProperty('prop4')
