---
title: "sprockit.Process"
permalink: /tables/Process/
---

This table defines processes controlled by Sprockit.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ProcessId**</ins>  |<ins>**INT**</ins>  |Unique identifier for a process  |  |
|  |**ProcessGroup**  |**INT**  |The group to which a process belongs.   |DEFAULT `1`  |
|UQ  |**ProcessPath**  |**NVARCHAR(850)**  |  |  |
|[FK]({{"/tables/ProcessType/"|relative_url}})  |**ProcessType**  |**NVARCHAR(10)**  |  |  |
|  |**Status**  |**NVARCHAR(20)**  |  |DEFAULT `'Done'`  |
|  |**ErrorCount**  |**INT**  |  |DEFAULT `0`  |
|  |**LastStatusUpdate**  |**DATETIME**  |  |DEFAULT `getutcdate()`  |
|  |LastExecutionId  |INT  |  |  |
|  |DefaultWatermark  |NVARCHAR(255)  |  |  |
|  |CurrentWatermark  |NVARCHAR(255)  |  |  |
|  |**AvgDuration**  |**INT**  |  |DEFAULT `0`  |
|  |**BranchWeight**  |**INT**  |  |DEFAULT `0`  |
|  |**IsEnabled**  |**BIT**  |  |DEFAULT `1`  |
|  |**Priority**  |**TINYINT**  |  |DEFAULT `100`  |
|  |**LogPropertyUpdates**  |**BIT**  |  |DEFAULT `0`  |
