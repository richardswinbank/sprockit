CREATE TABLE [sprockit].[Reservation] (
    [ProcessId]       INT      NOT NULL,
    [HandlerId]       INT      NOT NULL,
    [ReservationTime] DATETIME DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ProcessId] ASC)
);

