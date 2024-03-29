---
title: "sprockit.Process"
permalink: /tables/Process/
---

This table defines processes controlled by Sprockit. 

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**ProcessId**</ins>  |<ins>**INT**</ins>  |Unique identifier for a process.  |  |
|  |**ProcessGroup**  |**INT**  |The group to which a process belongs. A single [batch]({{"/tables/Batch/"|relative_url}}) executes all processes from a given process group.  |DEFAULT `1`  |
|UQ  |**ProcessPath**  |**NVARCHAR(850)**  |Unique text identifier, sufficient to identify a process to its handler.   |  |
|[FK]({{"/tables/ProcessType/"|relative_url}})  |**ProcessType**  |**NVARCHAR(10)**  |The type of the process.  |  |
|  |**Status**  |**NVARCHAR(20)**  |The process's current runtime status  |DEFAULT `Done`  |
|  |**ErrorCount**  |**INT**  |The number of times, in succession, that execution of this process has failed.   |DEFAULT `0`  |
|  |**LastStatusUpdate**  |**DATETIME**  |The date and time at which the process's [Status] value was last updated.  |DEFAULT `getutcdate()`  |
|[FK]({{"/tables/Execution/"|relative_url}})  |LastExecutionId  |INT  |Identifies the most recent attempt to execute the process.  |  |
|  |DefaultWatermark  |NVARCHAR(255)  |The default/initial watermark value for this process.  |Set at process configuration.  |
|  |CurrentWatermark  |NVARCHAR(255)  |The current watermark value for this process.  |Set during the process's last successful execution.  |
|  |**AvgDuration**  |**INT**  |The process's average execution time, in seconds, over the last 7 days.  |Used by Sprockit for process selection. DEFAULT `0`  |
|  |**BranchWeight**  |**INT**  |The average time elapsed between when the process starts and the last of its downstream processes is complete.   |Used by Sprockit for process selection. DEFAULT `0`.  |
|  |**IsEnabled**  |**BIT**  |Indicates whether or not this process is to be executed.  |`1` (default) if the process is enabled, otherwise `0`.  |
|  |**Priority**  |**TINYINT**  |The priority of this process. Processes with lower [Priority] values are given higher priority by Sprockit.  |Used by Sprockit for process selection. DEFAULT `100`. |
|  |**LogPropertyUpdates**  |**BIT**  |  |DEFAULT `0`  |

## Process status
During batch execution, the table defines a queue of processes for execution via the [Status] field. When batch execution begins, all processes in the batch's process group are given [Status] = `Not ready`, after which processes with no [predecessors]({{"/tables/ProcessDependency/"|relative_url}}) are set to `Ready`. When the execution engine requests a process (via [sprockit].[ReserveProcess]) the highest-priority `Ready` process is returned.

On completion, the execution engine must release the process (via [sprockit].[ReleaseProcess]) with an appropriate status value of `Done`, `Errored` or `Stopped`. Releasing a process with status `Done` may cause Sprockit to flag other downstream processes as `Ready` -- these become available for selection by future calls to [sprockit].[ReserveProcess].

Releasing a process with status `Errored` has one of two effects:
 - if the [log event]({{"/tables/Event/"|relative_url}}) for the underlying error indicates that it is [retryable]({{"/tables/RetryableError/"|relative_url}}) (and the number of prior attempts does not exceed the maximum permitted), Sprockit re-queues the process by setting its status back to `Ready`
 - if the error is not retryable, the process retains its status of `Errored` and any downstream processes are given status `Blocked`.

## Priority
[sprockit].[ReserveProcess] selects a `Ready` process to return the execution engine in preference order of [Priority] (highest first), followed by [BranchWeight] (largest first) then [AvgDuration] (longest first).

Processes that are disabled ([IsEnabled] = `0`) or whose [process type]({{"/tables/ProcessType/"|relative_url}}) has no associated handler are not returned to the execution engine -- these are marked `Done` internally before [sprockit].[ReserveProcess] seeks another process to return.

