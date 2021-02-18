---
layout: page
title: "About Sprockit"
permalink: /
---

Sprockit 2.0 is a reimplementation of [classic Sprockit](https://richardswinbank.net/sprockit), very much still in development. My intention here is to:

* decouple Sprockit's core metadata model from its execution engine (i.e. the SQL Server Agent in v1.6 and earlier), allowing other engines to use the same model
* continue to support existing users of SQL 2008+ by providing a SQL Agent-based execution engine out of the box
* encapsulate as much process management functionality as possible inside the metadata model SPs, to make consistent implementation in other engines (hopefully) fairly straightforward
* adjust the dependency model to introduce a bit more flexibility and to support DataOps-style data pipeline validations in-flight.
