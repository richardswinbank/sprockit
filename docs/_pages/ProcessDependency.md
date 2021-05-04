---
title: "sprockit.ProcessDependency"
permalink: /tables/ProcessDependency/
---

This table records dependencies between [processes]({{"/tables/Process/"|relative_url}}). Dependencies determine the order in which Sprockit reserves processes for execution.

Each row in the table records a dependency of one process on another single process. Multiple rows create complex dependency graphs in which a process may depend on (or be depended on by) many others. 

|  |Column  |Type   |Description  |Comments  |
|--|--|--|--|--|
|PK  |<ins>**DependencyId**</ins>  |<ins>**INT**</ins>  |Unique identifier for a dependency between two processes.  |  |
|[FK]({{"/tables/Process/"|relative_url}})  |**ProcessId**  |**INT**  |Identifies a process which has a dependency on another.  |A process becomes ready for execution (with status `Ready` when every process on which it depends has a status of `Done`.  |
|[FK]({{"/tables/Process/"|relative_url}})  |**DependsOn**  |**INT**  |Identifies another, different process, on which the process identified by [ProcessId] depends.  |  |
