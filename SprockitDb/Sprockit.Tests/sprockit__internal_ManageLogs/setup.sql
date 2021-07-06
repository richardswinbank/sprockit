CREATE PROCEDURE sprockit__internal_ManageLogs.[setup]
AS

EXEC tSQLt.FakeTable @TableName = 'sprockit.Batch'

INSERT INTO sprockit.[Batch] (
  BatchId
, CreatedDateTime
) VALUES
  (1, '1900-01-01 00:00')
, (2, '2008-01-01 00:00')
, (3, '2021-07-02 00:00')
, (4, '2021-07-03 12:45');

EXEC tSQLt.FakeTable @TableName = 'sprockit.Execution'

INSERT INTO sprockit.Execution (
  BatchId
) VALUES
  (1)
, (2)
, (3)
, (3)
, (4)
, (4);

EXEC tSQLt.FakeTable @TableName = 'sprockit.Event'

INSERT INTO sprockit.[Event] (
  EventDateTime
) VALUES
  ('1900-01-01 00:00')
, ('2008-01-01 00:00')
, ('2021-07-02 00:00')
, ('2021-07-02 23:17')
, ('2021-07-03 17:11')
, ('2021-07-04 12:45')
, ('2021-07-05 02:00');


