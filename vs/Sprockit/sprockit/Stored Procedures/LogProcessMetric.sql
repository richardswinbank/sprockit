/*
 * sprockit.[LogProcessMetric] 
 * Copyright (c) 2021 Richard Swinbank (richard@richardswinbank.net) 
 * http://richardswinbank.net/sprockit
 *
 * Log a process metric
 */

CREATE PROCEDURE [sprockit].LogProcessMetric (
  @executionId INT
, @metricName NVARCHAR(128)
, @metricValue DECIMAL(19,5)
)
AS

INSERT INTO [sprockit].ProcessMetric (
  ExecutionId
, MetricName
, MetricValue
) VALUES (
  @executionId
, @metricName
, @metricValue
);

