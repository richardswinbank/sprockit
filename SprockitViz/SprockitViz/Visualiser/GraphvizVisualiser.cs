using FireFive.SprockitViz.PipelineGraph;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace FireFive.SprockitViz.Visualiser
{
    /*
     * GraphvizVisualiser class
     * Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net) 
     * http://richardswinbank.net/
     *
     * Wrapper for Graphviz application.
     */
    public class GraphvizVisualiser
    {
        private static readonly Dictionary<string, NodeRenderer> renderers = new Dictionary<string, NodeRenderer>();

        public static void AddRenderer(string key, NodeRenderer renderer)
        {
            renderers[key] = renderer;
        }

        // configuration for this visualiser
        private VisualiserSettings settings;

        // create a new instance with a specified configuration
        public GraphvizVisualiser(VisualiserSettings settings)
        {
            this.settings = settings;
        }

        // get a DOT script for a graph, then invoke Graphviz to produce an image in SVG format
        public void Visualise(Graph g)
        {
            string outputFormat = "svg";

            // make sure we have an output folder
            string outputFolder = settings.OutputFolder;
            if (!Directory.Exists(outputFolder))
                Directory.CreateDirectory(outputFolder);

            // prepare working & output file names
            string ufFile = $@"{outputFolder}\{g.FileNameWithoutExtension}.uf";
            string dotFile = $@"{outputFolder}\{g.FileNameWithoutExtension}.gv";
            string imgFile = $@"{outputFolder}\{g.FileNameWithoutExtension}.{outputFormat}"; 

            // needs unflatten?
            int maxLeafStagger = GetMaxLeafStagger(g);
            if (maxLeafStagger > 0)  // unflatten
            {
                // write the DOT script into a different file (we want to be able to keep inputs 
                // for unflatten.exe *and* dot.exe when settings.DeleteWorkingFiles is false)
                File.WriteAllText(ufFile, GetDotScript(g));
                // call unflatten.exe, writing output script into dotFile
                ExecuteGraphviz(GraphvizExecutable.Unflatten, ufFile, dotFile, "-fl" + maxLeafStagger);
            }
            else
            {
                // write input script directly into dotFile
                File.WriteAllText(dotFile, GetDotScript(g));
            }

            ExecuteGraphviz(GraphvizExecutable.Dot, dotFile, imgFile, $"-T{outputFormat} -Kdot");
        }

        // return a DOT script for a specified graph
        private string GetDotScript(Graph g)
        {
            StringBuilder sb = new StringBuilder();

            // graph header
            sb.AppendLine("digraph \"Sprockit v2.0\" {");
            sb.AppendLine("  node[shape=box,fontname=helvetica,fontsize=12];");

            // add nodes
            var basicRenderer = new NodeRenderer();
            foreach (Node n in g.Nodes)
            {
                var r = (renderers.ContainsKey(n.Type) ? renderers[n.Type] : basicRenderer);
                sb.AppendLine($"  {r.Render(n, g.IsCentre(n), settings.OutputFolder)};");
            }

            // add edges
            foreach (DirectedEdge e in g.Edges)
                sb.AppendLine("  " + Enquote(e.Start.Name) + " -> " + Enquote(e.End.Name)
                  + " [style=" + Enquote(e is DirectedConnection ? "dashed" : "solid")
                  + ",tooltip=" + Enquote($"{e.Start.Name} -> {e.End.Name}")
                  + "];");

            // graph closing brace
            sb.AppendLine("}");

            return sb.ToString();
        }

        // surround a string with double quotes
        private string Enquote(string s)
        {
            return "\"" + s + "\"";
        }

        // Calculate an appropriate maxLeafStagger value for Graphviz's unflatten program. Basically:
        //  - if a graph is too wide for the configured MaxSize, aim to unflatten it to make it narrow enough 
        //  - if a graph is too wide *and* too tall, aim to unflatten it into something approaching the same aspect ratio as MaxSize
        private int GetMaxLeafStagger(Graph g)
        {
            Size size = g.GetSize();
            float overSize = (float)size.Width / settings.MaxSize.Width;

            if (overSize <= 1)  // not too wide
                return 0;

            int maxLeafStagger = 0;
            string trace = size.ToString() + "; match ";

            if (overSize * size.Height > settings.MaxSize.Height)
            // compressing to MaxWidth wouldn't fit on the page -- try to match aspect ratio
            {
                float density = (float)g.NodeCount / (size.Width * size.Height);
                density = 1;
                float targetCount = settings.MaxSize.Width * settings.MaxSize.Height * density;
                float targetWidth = g.NodeCount / targetCount * settings.MaxSize.Width;

                maxLeafStagger = (int)((g.NodeCount + 1) / targetWidth);
                trace += "aspect ratio";
            }
            else // try to compress to MaxWidth
            {
                maxLeafStagger = (g.NodeCount + 1) / settings.MaxSize.Width;
                trace += "max width";
            }

            trace += "; maxLeafStagger = " + maxLeafStagger;
            if (settings.Verbose)
                Console.WriteLine(trace);

            return maxLeafStagger;
        }

        #region Graphviz execution

        private StringBuilder stdErr;  // StringBuilder to collect output written to stderr during ExecuteGraphviz()

        // event handler for stderr write events (appends output to stdErr)
        private void StdErrDataReceived(object sender, DataReceivedEventArgs e)
        {
            stdErr.AppendLine(e.Data);
        }

        // enum to represent supported Graphviz apps
        private enum GraphvizExecutable { Dot, Unflatten }

        // execute a Graphviz application
        private void ExecuteGraphviz(GraphvizExecutable executable, string inputFile, string outputFile, string commandLineArgs)
        {
            // prepare to execute Graphviz application
            Process gv = new Process();
            gv.StartInfo.CreateNoWindow = true;
            gv.StartInfo.UseShellExecute = false;
            gv.StartInfo.FileName = settings.GraphvizAppFolder + "\\" + (executable == GraphvizExecutable.Dot ? "dot" : "unflatten") + ".exe";
            if (!File.Exists(gv.StartInfo.FileName))
                throw new Exception("Graphviz executable " + gv.StartInfo.FileName + " not found.");
            gv.StartInfo.Arguments = commandLineArgs + " -o \"" + outputFile + "\" \"" + inputFile + "\"";

            // set up standard error redirection
            gv.StartInfo.RedirectStandardError = true;
            stdErr = new StringBuilder();
            gv.ErrorDataReceived += StdErrDataReceived;

            // execute Graphviz application
            gv.Start();
            gv.BeginErrorReadLine();
            if (!gv.WaitForExit(settings.GraphvizTimeout * 1000))  // still waiting after 5s? Assume Graphviz has crashed
            {
                gv.Kill();
                gv.WaitForExit();
                RaiseGraphvizRenderingException(outputFile, inputFile, true);
            }
            if (gv.ExitCode != 0)
                RaiseGraphvizRenderingException(outputFile, inputFile, false);

            // tidy up
            if (settings.DeleteWorkingFiles)
                File.Delete(inputFile);
        }

        private void RaiseGraphvizRenderingException(string outputFile, string inputFile, bool timeout)
        {
            throw new Exception("Graphviz " + (timeout ? "timed out" : "error")
              + " rendering " + outputFile
              + " from " + inputFile
              + Environment.NewLine + stdErr.ToString());
        }

        #endregion Graphviz execution

        #region DOT script builder functions

        //// return a string describing a node's duration, if applicable
        //protected string GetDurationDescription(Node n)
        //{
        //    if (!n.HasProperty("AvgDuration"))
        //        return "";
        //    int duration = 0;
        //    int.TryParse(n.GetProperty("AvgDuration"), out duration);
        //    TimeSpan t = TimeSpan.FromSeconds(duration);
        //    return "Duration = " + string.Format("{0:D2}:{1:D2}:{2:D2}", t.Hours, t.Minutes, t.Seconds);
        //}

        //// return a string detailing a node's ID
        //protected string GetIdDescription(string id)
        //{
        //    if (id[0] == 'R')
        //        return "ResourceUid = " + id.Substring(1, id.Length - 1);
        //    return "ProcessId = " + id.Substring(1, id.Length - 1);
        //}

        //// translate DbObjectType enum members to descriptions
        //protected string GetTypeDescription(DbObjectType type)
        //{
        //    switch (type)
        //    {
        //        case DbObjectType.StoredProcedure:
        //            return "Stored procedure";
        //        case DbObjectType.SsisPackage:
        //            return "SSIS package";
        //        case DbObjectType.ScalarFunction:
        //            return "Scalar function";
        //        case DbObjectType.TableValuedFunction:
        //            return "Table-valued function";
        //        default:
        //            return type.ToString();
        //    }
        //}

        //// get the color name configured for a node's database; if none, default to black
        //protected string GetDbColor(Node n)
        //{
        //    if (settings.DbColors.ContainsKey(n.DbName))
        //        return settings.DbColors[n.DbName];
        //    return "black";
        //}

        #endregion DOT script builder functions
    }

}
