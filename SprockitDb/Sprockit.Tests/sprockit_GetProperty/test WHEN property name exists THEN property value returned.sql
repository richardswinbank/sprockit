CREATE PROCEDURE sprockit_GetProperty.[test WHEN property name exists THEN property value returned]
AS

-- ARRANGE 
DECLARE @expected NVARCHAR(4000) = 'val2';
DECLARE @actual NVARCHAR(4000);

-- ACT
SELECT @actual = sprockit.GetProperty('prop2');

-- ASSERT
EXEC tSQLt.AssertEquals 
  @expected = @expected
, @actual = @actual;
