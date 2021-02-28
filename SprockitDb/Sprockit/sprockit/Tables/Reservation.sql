CREATE TABLE [sprockit].[Reservation] (
    [ProcessId]       INT      NOT NULL,
    ReservationDateTime DATETIME CONSTRAINT DF__sprockit_Reservation__ReservationDateTime DEFAULT (GETUTCDATE()) NOT NULL,
    CONSTRAINT PK__sprockit_Reservation PRIMARY KEY CLUSTERED ([ProcessId] ASC)
);





