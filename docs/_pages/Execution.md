---
title: "sprockit.Execution"
permalink: /tables/Execution/
---

This table records [process]({{"/tables/Process/"|relative_url}}) executions. A row in this table corresponds to a single execution attempt of a specified process.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ExecutionId**</ins>  |<ins>**INT**</ins>  |Unique identifier for the execution of a process.  |  |
|[FK]({{"/tables/Process/"|relative_url}})  |**ProcessId**  |**INT**  |Identifies the process executed.  |  |
|[FK]({{"/tables/Batch/"|relative_url}})  |**BatchId**  |**INT**  |Identifies the batch during which this execution took place.  |  |
|  |ExternalHandlerId  |NVARCHAR(255)  |External identifier for the execution engine’s process handler, responsible for this execution.   |This could be a SQL Server Agent job name, or an Azure Data Factory pipeline run ID.  |
|  |**ExecutionParameters**  |**XML**  |XML summary of [parameter values]({{"/tables/Parameter/"|relative_url}}) returned to the exeution engine when the process was reserved.  |DEFAULT `'<Parameters/>'`  |
|  |**ExecutionProperties**  |**XML**  |XML summary of properties logged during or for this execution.  |DEFAULT `'<Properties/>'`. An execution property is a name/value pair logged using [sprockit].[SetExecutionProperty]. A property's name is unique within an execution; calling [sprockit].[SetExecutionProperty] twice for the same execution ID and property name overwrites the first property value with the second.   |
|  |**StartDateTime**  |**DATETIME**  |The UTC date and time at which the process was reserved.  |DEFAULT `getutcdate()`  |
|  |EndDateTime  |DATETIME  |The UTC date and time at which the process was released.  |  |
|[FK]({{"/tables/ProcessType/"|relative_url}})  |**ProcessType**  |**NVARCHAR(10)**  |The type of the process, as recorded in [sprockit].[Process] at the time the process was reserved.   |  |
|  |EndStatus  |NVARCHAR(20)  |The status with which the execution finished.  |`Done` if successful or `Errored` if failed. Cancelled processes should be released with end status `Stopped`.  |
|  |AvgDuration  |INT  |The average duration of the process's execution, as recorded in [sprockit].[Process] at the time the process was reserved.  |  |
|  |InitialWatermark  |NVARCHAR(255)  |The process's watermark value, as recorded in [sprockit].[Process] at the time the process was reserved.  |  |
|  |UpdatedWatermark  |NVARCHAR(255)  |The latest watermark value recorded during or for this execution.    |  |
|  |BranchWeight  |INT  |The process's branch weight, as recorded in [sprockit].[Process] at the time the process was reserved.    |  |
|  |IsEnabled  |BIT  |Whether or not the process is enabled, as recorded in [sprockit].[Process] at the time the process was reserved.    |`1` if enabled, otherwise `0`.  |
|  |Priority  |TINYINT  |The process's priority, as recorded in [sprockit].[Process] at the time the process was reserved.    |  |
