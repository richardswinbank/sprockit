CREATE TABLE [sprockit].[RetryableError] (
    [ProcessType]    NVARCHAR (10)   NOT NULL ,
    [ProcessPathPattern]    NVARCHAR (850) NOT NULL DEFAULT '%',
    [EventSourcePattern] NVARCHAR (1024) NOT NULL DEFAULT '%',
    [MessagePattern] NVARCHAR (1024) NOT NULL DEFAULT '%',
    [MaximumRetries] INT             DEFAULT ((2)) NOT NULL
);

