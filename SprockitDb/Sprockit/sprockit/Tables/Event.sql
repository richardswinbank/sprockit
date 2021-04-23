CREATE TABLE [sprockit].[Event] (
    [EventId]       INT             IDENTITY (1, 1) NOT NULL,
    [EventDateTime] DATETIME        NOT NULL,
    [Severity]      TINYINT         CONSTRAINT [DF__sprockit_Event__Severity] DEFAULT ((0)) NOT NULL,
    [ExecutionId]   INT             NULL,
    [EventSource]   NVARCHAR (1024) NULL,
    [Message]       NVARCHAR (MAX)  NOT NULL,
    [MetricValue] DECIMAL(19, 5) NULL, 
    CONSTRAINT [PK__sprockit_Event] PRIMARY KEY CLUSTERED ([EventId] ASC)
);

