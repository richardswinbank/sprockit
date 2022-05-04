# SprockitViz

SprockitViz is a small Javascript app that enables interactive value (ETL) pipeline exploration.

It uses your Sprockit processes XML config file to generate a suite of clickable SVG diagrams, wrapped up in an HTML file.

## Installation

1. Download and install [Graphviz](https://graphviz.org/) (used to draw node diagrams from Graphviz input files created by SprockitViz)
1. Clone the Sprockit repo and open `SprockitViz/SprockitViz.sln` in Visual Studio (2019 or above)
1. Build the solution
1. Unless you've changed the project's build profile, the built binaries will be located in `SprockitViz/SprockitViz/bin/Debug/netcoreapp3.1`. In here you can find and create settings files to provide information about your local Sprockit config, for example the locations of your Sprockit processes XML file and Graphviz install. You can either:
   * edit the file `SprockitvizSettings.json` directly, or
   * create a copy called `SprockitvizSettings.local.json` &mdash; if present, values in this file supsersede those in `SprockitvizSettings.json`

## Execution
Run `SprockitViz.exe` to generate output files. SprockitViz uses settings in `SprockitvizSettings.json`/`SprockitvizSettings.local.json` as follows:
   * *SourceFile* &mdash; is the full path of your Sprockit processes file.
   * *OutputFolder* &mdash; is the full path to the folder in which to place output files. The folder must exist.
   * *GraphvizAppFolder* &mdash; is the full path to the folder containing the Graphviz application files (e.g. `dot.exe`, `uf.exe`)
   * *DeleteWorkingFiles* &mdash; SprockitViz generates Graphviz input files which are presented as inputs to Graphviz for diagram production. When `true` these files are automatically deleted.
   * *DeleteWorkingFiles* &mdash; when `true`, output more information to the console
   * *Interactive* &mdash; when `true`, prompt the user for confirmation before closing the console. For automated Sprockitviz execution, set this to `false`.

## Using the output
Find the file `_sprockitviz.html` in your configured output folder and open it in a web browser of your choice.

## Diagnosing errors

Errors occur when your `SprockitvizSettings.json`/`SprockitvizSettings.local.json` settings or your Sprockit process configuration are invalid. 
   * If your Sprockit process configuration has errors, you can see them at the console by running Sprockitviz with *Interactive* = `true`. Configuration errors that cause Sprockitviz to fail would typically cause `sprockit.DeserialiseProcesses` also to fail. The SP tolerates case-only differences if your deployment database uses a case-insensitive collation, but SprockitViz is case sensitive.
   * If your settings configuration is invalid, `SprockitViz.exe` exits immediately, even with *Interactive* = `true`. To capture errors like this to the console, wrap your call to SprockitViz in a batch script followed by a `pause` command.
      ```
      .\SprockitViz.exe
      pause
      ```
      Typical setting errors are invalid paths to Sprockit processes, output folders or Graphviz. Note that backslashes must be escaped with a predceding backslash, e.g.:
      ```
      "SourceFile": "C:\\SprockitViz\\SprockitProcesses.xml",
      ```
