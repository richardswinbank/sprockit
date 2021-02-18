|  |Column name  |Column type  |Description  |Notes  |
|---|---|---|---|---|
|PK  |ProcessId|INT|   |   |
|  |ProcessGroup|INT|   |   |
|UQ  |ProcessPath|NVARCHAR(850)|   |   |
|FK  |ProcessType|NVARCHAR(10)|   |   |
|  |Status|NVARCHAR(20)|   |   |
|  |ErrorCount|INT|   |   |
|  |LastStatusUpdate|DATETIME|   |   |
|RL |LastExecutionId|INT|   |   |
|  |DefaultWatermark|NVARCHAR(255)|   |   |
|  |CurrentWatermark|NVARCHAR(255)|   |   |
|  |AvgDuration|INT|   |   |
|  |BranchWeight|INT|   |   |
|  |IsEnabled|BIT|   |   |
|  |Priority|TINYINT|   |   |
|  |LogPropertyUpdates|BIT|   |   |
