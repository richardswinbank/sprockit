CREATE TABLE [sprockit].[Reservation] (
    [ProcessId]       INT      NOT NULL,
    [HandlerId]       INT      NOT NULL,
    ReservationDateTime DATETIME CONSTRAINT DF__sprockit_Reservation__ReservationDateTime DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT PK__sprockit_Reservation PRIMARY KEY CLUSTERED ([ProcessId] ASC),
    CONSTRAINT UQ__sprockit_Reservation UNIQUE NONCLUSTERED ([HandlerId] ASC)
);





