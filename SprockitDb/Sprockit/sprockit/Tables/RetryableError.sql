CREATE TABLE [sprockit].[RetryableError] (
    [ProcessType]    NVARCHAR (10)   NOT NULL ,
    [ProcessPathPattern]    NVARCHAR (850)   NULL DEFAULT '%',
    [MessagePattern] NVARCHAR (1024) NOT NULL,
    [MaximumRetries] INT             DEFAULT ((2)) NOT NULL
);

