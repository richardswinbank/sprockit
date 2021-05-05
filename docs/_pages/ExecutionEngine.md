---
title: "Execution engine"
permalink: /concepts/ExecutionEngine/
---

An execution engine provides the runtime components that execute ETL processes. The engine uses Sprockit to determine the order in which processes are executed, and to handle common issues like process errors, auto-retry, restartability and logging. 

Execution engines can be implemented in any technology which supports execution of the processes you wish to control, for example:
* a Windows application or service
* the SQL Server Agent (as used for execution by [classic Sprockit](https://richardswinbank.net/sprockit))
* Azure Data Factory
* Azure durable functions.

