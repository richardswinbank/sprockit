---
title: "sprockit.Execution"
permalink: /tables/Execution/
---

This table records [process]({{"/tables/Process/"|relative_url}}) executions.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ExecutionId**</ins>  |<ins>**INT**</ins>  |  |  |
|  |**ProcessId**  |**INT**  |  |  |
|  |**BatchId**  |**INT**  |  |  |
|  |ExternalHandlerId  |NVARCHAR(255)  |  |  |
|  |**ExecutionParameters**  |**XML**  |  |DEFAULT `'<Parameters/>'`  |
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
