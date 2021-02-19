---
title: "sprockit.Process"
permalink: /sprockit.Process/
---

Each row in this table represents a [process]{% link _pages/processes.md %} managed by Sprockit.

|  |Column name  |Column type  |Description  |Notes  |
|---|---|---|---|---|
|PK  |**ProcessId**|**INT**|Unique identifier for the process.   |IDENTITY   |
|  |ProcessGroup|INT|[Group]{% link _pages/process-groups.md %} to which the process belongs.  |   |
|UQ  |ProcessPath|NVARCHAR(850)|Unique name for the process.   |Need not mean anything, even to the process's [handler]{% link _pages/process-handlers.md %}.    |
|[FK]{% link _pages/sprockit-processtype.md %} |ProcessType|NVARCHAR(10)|The process's type.   |Typically used by the [process manager]{% link _pages/process-manager.md %} to assign the appropriate process handler.  |
|  |Status|NVARCHAR(20)|The process's current execution status.   |Updated by Sprockit. A process cycles through a series of status values during a [batch]{% link _pages/sprockit-batch.md %} run. Initially it is *Not ready*, then when all its inputs are available it becomes *Ready*. When reserved it starts *Running*, after which it may complete normally (*Done*) or fail (*Errored*). In the latter case, any downstream processes not yet ready become *Blocked*.   |
|  |ErrorCount|INT|The number of successive execution failures for the process.   |Updated by Sprockit. Incremented when an execution of the process is released with end status 'Errored'; reset to zero when released with any other end status.   |
|  |LastStatusUpdate|DATETIME|The date and time at which the status of this process was last updated.  |Updated by Sprockit.   |
|[RL]{% link _pages/sprockit-execution.md %} |*LastExecutionId*|*INT*|Identifies the last execution of this process   |Updated by Sprockit.   |
|  |*DefaultWatermark*|*NVARCHAR(255)*|The default [watermark value]{% link _pages/watermarks.md %} for this process.   |   |
|  |*CurrentWatermark*|*NVARCHAR(255)*|The process's current [watermark value]{% link _pages/watermarks.md %}.   |   |
|  |AvgDuration|INT|The average duration of this process's recent executions, in seconds.   |Updated by Sprockit.   |
|  |BranchWeight|INT|A process's branch weight is the average time elapsed between when execution of the process starts and the last of its downstream processes is complete.   |Updated by Sprockit. BranchWeight is used to choose between multiple ready processes when reserving one for execution.   |
|  |IsEnabled|BIT|Indicates whether this process is to be executed or not.   |Processes with IsEnabled = 0 are never returned when a process is returned but when ready are immediately marked *Done*.  |
|  |Priority|TINYINT|The process's priority.   |Used to choose between multiple ready processes when reserving one for execution. Higher-priority ready processes (lower values) are chosen over lower-priority ones, even when they have lower branch weights.   |
|  |LogPropertyUpdates|BIT|Indicates whether execution property updates are also to be written to the event log.   |   |
