---
title: "sprockit.Execution"
permalink: /tables/Execution/
---

This table records [process]({{"/tables/Process/"|relative_url}}) executions. A row in this table corresponds to a single execution attempt of a specified process.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ExecutionId**</ins>  |<ins>**INT**</ins>  |Unique identifier for the execution of a process.  |  |
|[FK]({{"/tables/Process/"|relative_url}})  |**ProcessId**  |**INT**  |Identifies the process executed.  |  |
|[FK]({{"/tables/Batch/"|relative_url}})  |**BatchId**  |**INT**  |Identifies the batch in which this execution took place.  |  |
|  |ExternalHandlerId  |NVARCHAR(255)  |  |  |
|  |**ExecutionParameters**  |**XML**  |XML summary of [parameter values]({{"/tables/Parameter/"|relative_url}}) returned to the exeution engine when the process was reserved.  |DEFAULT `'<Parameters/>'`  |
|  |**ExecutionProperties**  |**XML**  |  |DEFAULT `'<Properties/>'`  |
|  |**StartDateTime**  |**DATETIME**  |  |DEFAULT `getutcdate()`  |
|  |EndDateTime  |DATETIME  |  |  |
|  |**ProcessType**  |**NVARCHAR(10)**  |  |  |
|  |EndStatus  |NVARCHAR(20)  |  |  |
|  |AvgDuration  |INT  |  |  |
|  |InitialWatermark  |NVARCHAR(255)  |  |  |
|  |UpdatedWatermark  |NVARCHAR(255)  |  |  |
|  |BranchWeight  |INT  |  |  |
|  |IsEnabled  |BIT  |  |  |
|  |Priority  |TINYINT  |  |  |
