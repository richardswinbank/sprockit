CREATE TABLE [sprockit].[RetryableError] (
    [MessagePattern] NVARCHAR (1024) NOT NULL,
    [ProcessType]    NVARCHAR (10)   NOT NULL,
    [MaximumRetries] INT             DEFAULT ((0)) NOT NULL,
    FOREIGN KEY ([ProcessType]) REFERENCES [sprockit].[ProcessType] ([ProcessType])
);

