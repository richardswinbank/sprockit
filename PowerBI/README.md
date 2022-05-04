# Sprockit dashboard

The Sprockit dashboard is a Power BI report that provides views of data in Sprockit tables.

# Refresh
The dashboard relies on a **direct query** connection to the underlying Sprockit database. This is necessary to make it usable for real-time monitoring, but requires you to use Power BI's refresh button to load fresh data.

When installing from the repo, you will need to connect the report to your Sprockit DB. Do this by opening the report in Power BI desktop then *Transform data* -> *Data source settings* -> *Change Source...*.

# Components

The dashboard contains six components. The performance of underlying queries isn't great; some components take time to load at each refresh.

* The **batch selector** (dropdown, top right) allows you to select a recent batch (ETL run) managed by Sprockit. Batch start times are in UTC. 
* The **Process status** donut (top centre) indicates the final status of each process in the group to which the selected batch relates.
The donut is based on the **current** set of processes defined in `sprockit.Process`, so processes may appear "not run", usually because either:
   * the process batch is incomplete
   * you are looking at an older batch (since which more new processes have been defined)
* The **Errors/Warnings** table (top left) shows errors and warnings raised during the batch.
   * Errors are reported in red and **include** retried errors.
   * Warnings are reported in orange.
* The **Batch profile** line chart (beneath the batch selector) shows the number of processes running in parallel at intervals during the batch.
* The bottom half of the page lists all executions attempted during the batch, including failures and subsequent retries -- retried/restarted processes will cause multiple attempts to appear here for the same process.

Right click on an entry in the list of executions, then *Drill through* -> *Execution detail* to access further detail about an execution.
