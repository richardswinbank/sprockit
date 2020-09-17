CREATE PROCEDURE [sprockit_Reservation].[test GIVEN handler holding reservation THEN reservation fails]
AS

-- ARRANGE 
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Violation of UNIQUE KEY constraint ''UQ__sprockit_Reservation''.%'

INSERT INTO sprockit.Reservation (
  ProcessId
, HandlerId
) VALUES (
  32
, 791
)

-- ACT
INSERT INTO sprockit.Reservation (
  ProcessId
, HandlerId
) VALUES (
  33
, 791
)
