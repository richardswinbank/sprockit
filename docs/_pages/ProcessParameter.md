---
title: "sprockit.ProcessParameter"
permalink: /tables/ProcessParameter/
---

This table records parameter values to be supplied to [processes]({{"/tables/Process/"|relative_url}}) at [runtime]({{"/tables/Execution/"|relative_url}}). When a process is reserved by the execution engine, Sprockit returns the identity of the reserved process along with any configured parameter value.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ProcessId**</ins>  |<ins>**INT**</ins>  |Identifies the process to which the parameter belongs.   |  |
|PK  |<ins>**ParameterName**</ins>  |<ins>**NVARCHAR(128)**</ins>  |The name of the parameter.   |  |
|    |ParameterValue   |NVARCHAR(4000)   |The value of the parameter to be used by the process at runtime.   |    |

