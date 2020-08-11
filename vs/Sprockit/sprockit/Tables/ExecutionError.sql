CREATE TABLE [sprockit].[ExecutionError] (
    [ErrorId]       INT            IDENTITY (1, 1) NOT NULL,
    [ExecutionId]   INT            NOT NULL,
    [ErrorDateTime] DATETIME       NOT NULL,
    [Message]       NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK__Error__35856A2A3EA87742] PRIMARY KEY CLUSTERED ([ErrorId] ASC)
);

