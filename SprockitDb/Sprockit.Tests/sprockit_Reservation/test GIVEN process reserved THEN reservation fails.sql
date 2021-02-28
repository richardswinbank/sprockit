CREATE PROCEDURE [sprockit_Reservation].[test GIVEN process reserved THEN reservation fails]
AS

-- ARRANGE 
EXEC tSQLt.ExpectException @ExpectedMessagePattern = 'Violation of PRIMARY KEY constraint ''PK__sprockit_Reservation''.%'

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
  32
, 792
)
