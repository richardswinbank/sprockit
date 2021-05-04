---
title: "sprockit.RetryableError"
permalink: /tables/RetryableError/
---

This table contains patterns used by Sprockit to match retryable errors.

When the execution engine releases a [process]({{"/tables/Process/"|relative_url}}) with status `Errored`, Sprockit inspects the [event log]({{"/tables/Event/"|relative_url}}) for error-severity events, logged for the failed execution, which match a pattern configured in this table. If a match is found, and if the process has not already failed more than the maximum permitted number of consecutive failures, the process's status is set back to `Ready`. This makes the process available for reservation in the usual way, allowing it to be retried.

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|    |<ins>**ProcessType**</ins>  |<ins>**NVARCHAR(10)**</ins>  |The [type]({{"/tables/ProcessType/"|relative_url}}) of process to be matched by this pattern.   |Use `%` to indicate all process types.  |
|    |<ins>**ProcessPathPattern**</ins>  |<ins>**NVARCHAR(850)**</ins>  |The process path pattern to be matched for an error to be retried.   |DEFAULT `%` matches all process paths.  |
|    |<ins>**EventSourcePattern**</ins>  |<ins>**NVARCHAR(850)**</ins>  |The process path pattern to be matched for an error to be retried.   |DEFAULT `%` matches all event sources.  |
|    |<ins>**MessagePattern**</ins>  |<ins>**NVARCHAR(850)**</ins>  |The process path pattern to be matched for an error to be retried.   |DEFAULT `%` matches all messages.  |
|    |<ins>**MaximumRetries**</ins>  |<ins>**NVARCHAR(850)**</ins>  |The process path pattern to be matched for an error to be retried.   |DEFAULT `2` allows a matched error to be retried twice.   |
