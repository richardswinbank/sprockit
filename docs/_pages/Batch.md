---
title: "sprockit.Batch"
permalink: /tables/Batch/
---

This table records execution batches. 

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**BatchId**</ins>  |<ins>**INT**</ins>  |Unique identifier for the batch.  |  |
|  |**ProcessGroup**  |**INT**  |The group of processes executed in the batch.  |A completed batch consists of a successful execution of every [process]({{"/tables/Process/"|relative_url}}) in the batch's process group.  |
|  |ExternalManagerId  |NVARCHAR(1024)  |External identifier for the execution engine's process manager.  |This could be a SQL Server Agent job name, or an Azure Data Factory pipeline run ID.  |
|  |**StartDateTime**  |**DATETIME**  |The date and time at which the batch started.  |DEFAULT `getutcdate()`  |
|  |EndDateTime  |DATETIME  |The date and time at which the batch finished.  |A batch's [EndDateTime] is not determined until the start of the subsequent batch.   |
