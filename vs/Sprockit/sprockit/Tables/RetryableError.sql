CREATE TABLE [sprockit].[RetryableError] (
    [ProcessType]    NVARCHAR (10)   NOT NULL,
    [ProcessPathPattern]    NVARCHAR (850)   NOT NULL DEFAULT '%',
    [MessagePattern] NVARCHAR (1024) NOT NULL,
    [MaximumRetries] INT             DEFAULT ((3)) NOT NULL,
    FOREIGN KEY ([ProcessType]) REFERENCES [sprockit].[ProcessType] ([ProcessType])
);

