---
title: "sprockit.ProcessType"
permalink: /tables/ProcessType/
---

This table enumerates supported process types.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
| PK |<ins>**ProcessType**</ins>  |**NVARCHAR(10)**    |Unique identifier for a process type.    |    |
|  |Description   |NVARCHAR(255)  |Textual description of this process type.  |  |
|  |**HasHandler**  |**BIT**  |Indicates whether or not the execution engine provides a handler for processes of this type. Processes of types that have no handler are not returned to the execution engine at reservation, but are marked `Done` internally and released.   |`1` if the execution engine provides a handler for processes of this type, otherwise `0`.  |

