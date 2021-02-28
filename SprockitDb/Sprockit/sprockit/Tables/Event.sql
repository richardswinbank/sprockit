CREATE TABLE [sprockit].[Event] (
    [EventId]       INT             IDENTITY (1, 1) NOT NULL,
    [EventDateTime] DATETIME        NOT NULL,
    [Severity]      TINYINT         CONSTRAINT [DF__Event__Severity__51300E55] DEFAULT ((0)) NOT NULL,
    [ExecutionId]   INT             NULL,
    [EventSource]   NVARCHAR (1024) NULL,
    [Message]       NVARCHAR (MAX)  NOT NULL,
    CONSTRAINT [PK__sprockit_Event] PRIMARY KEY CLUSTERED ([EventId] ASC)
);

