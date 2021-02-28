CREATE TABLE [sprockit].ProcessMetric (
  ExecutionId INT		    NOT NULL
, MetricName NVARCHAR(128)  NOT NULL
, MetricValue DECIMAL(19,5) NOT NULL
)

GO

CREATE CLUSTERED INDEX CL__sprockit_ProcessMetric
ON sprockit.ProcessMetric (
  ExecutionId
)
