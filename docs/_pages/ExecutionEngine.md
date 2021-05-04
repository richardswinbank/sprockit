---
title: "Execution engine"
permalink: /concepts/ExecutionEngine/
---

An execution engine provides the runtime components that execute ETL processes. The engine uses Sprockit to determine the order in which processes are executed, and to handle common issues like process errors, auto-retry, restartability and logging. 

Examples of execution engines could include:
* the SQL Server Agent (as used for execution by [classic Sprockit](https://richardswinbank.net/sprockit))
* Azure Data Factory

