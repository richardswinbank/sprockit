---
title: "sprockit.Event"
permalink: /tables/Event/
---

This table records [execution]({{"/tables/Execution/"|relative_url}}) and other events. Events are written to the log by calling the procedure [sprockit].[LogEvent]. 

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**EventId**</ins>  |<ins>**INT**</ins>  |Unique identifier for the event.  |  |
|  |**EventDateTime**  |**DATETIME**  |The date and time at which the event was logged.   |   |
|  |**Severity**   |**TINYINT**  |The event's severity.    |Events with a severity of 200 or more are considered errors; events with severity between 100 and 199 are considered warnings. Information-only events have severity < 100.  |  
|[RL]({{"/tables/Execution/"|relative_url}})  |ExecutionId   |INT   |Identifies the execution, if any, with which the event is associated.  |    |
|  |EventSource   |NVARCHAR(1024)   |Identifies the event source, if supplied.   |   |
|  |**Message**   |**NVARCHAR(4000)**   |Description of the event.    |   |
|  |MetricValue   |DECIMAL(19,5)    |An optional numeric value supplied with (or as) an event.   |Metric values logged with a keyword identifier as [Message] (for example `RowsInserted`) can be useful for routine performance monitoring.   |    |
