CREATE TABLE [sprockit].[ProcessControlLimits](
	[ProcessId] [int] NOT NULL,
	[MetricName] [nvarchar](128) NOT NULL,
	[LowerControlLimit] [decimal](19,5) NOT NULL,
	[Mean] [decimal](19,5) NOT NULL,
	[UpperControlLimit] [decimal](19,5) NOT NULL
, CONSTRAINT PK__sprockit_ProcessControlLimits PRIMARY KEY (ProcessId, MetricName)
)
