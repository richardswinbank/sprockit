# Sprockit 2.0

This is a reimplementation of [Sprockit](http://sprockit.info), very much still in development. My intention here is to:

* decouple Sprockit's metadata model from its execution engine (i.e. the SQL Server Agent in v1.6 and earlier), allowing other engines to use the same model
* continue to support existing users of SQL 2008+ by providing a SQL Agent-based execution engine out of the box
* encapsulate as much process management functionality inside the metadata model SPs as possible, to make consistent implementation in other engines (hopefully) fairly straightforward
* adjust the dependency model to introduce a bit more flexibility and to support DataOps-style data pipeline validations in-flight.
