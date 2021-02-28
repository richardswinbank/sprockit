using FireFive.SprockitViz.Visualiser;
using FireFive.SprockitViz.Xml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using System.Xml.Serialization;

namespace FireFive.SprockitViz
{
    class Program
    {
        private string sprockitFilePath;
        private Dictionary<string, string> settings;

        public Program(string sprockitFilePath, Dictionary<string, string> settings)
        {
            this.sprockitFilePath = sprockitFilePath;
            this.settings = settings;
        }

        static void Main(string[] args)
        {
            Console.WriteLine(@"
  ****************************************************************************
  *  Sprockit Pipeline Visualiser                                            *
  *  Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net)  *
  *  http://richardswinbank.net/sprockitviz                                  *
  ****************************************************************************
");
            Thread.Sleep(1500);

            /*
             * TODO: sort out command line option handling
             */
            var filename = @"C:\Users\boomin\source\repos\Boomin\Shared\Data-Platform\sprockit-processes\SprockitProcesses.xml";

            /*
             * TODO: sort out settings config
             */
            var settings = new Dictionary<string, string>
            {
                ["OutputFolder"] = @"C:\tmp\sprockitviz",
                ["Verbose"] = "true",
                ["GraphvizAppFolder"] = @"C:\Program Files (x86)\Graphviz2.38\bin",
                ["DeleteWorkingFiles"] = "false"
            };

            GraphvizVisualiser.AddRenderer("ADF", new AdfPipelineRenderer());
            GraphvizVisualiser.AddRenderer("ADLS", new AdlsLocationRenderer());
            GraphvizVisualiser.AddRenderer("ASQL", new StoredProcRenderer());
            GraphvizVisualiser.AddRenderer("TABLE", new SqlTableRenderer());
            GraphvizVisualiser.AddRenderer("VIEW", new SqlViewRenderer());
            GraphvizVisualiser.AddRenderer("TVF", new SqlFunctionRenderer());

            var p = new Program(filename, settings);
            /*
             * TODO: cleanup exception management
             */
            try
            {
                p.Run();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                Console.WriteLine(e.StackTrace);
            }

        }

        public void Run()
        {
            var p = ParseFile(sprockitFilePath);
            var graph = p.GetGraph("Sprockit 2.0");
            var vs = new VisualiserSettings(settings);
            var v = new GraphvizVisualiser(vs);

            //v.Visualise(graph);

            CopyAppFile("_sprockitviz.css", vs.OutputFolder);
            CopyAppFile("_sprockitviz.js", vs.OutputFolder);
            CopyAppFile("_sprockitviz.html", vs.OutputFolder);

            int i = 0;
            var nodeNames = new StringBuilder();
            foreach (var n in graph.Nodes)
            {
                i++;
                nodeNames.AppendLine(", \"" + n.FileNameWithoutExtension + "\"");

                Console.WriteLine("Drawing subgraph " + i + " of " + graph.NodeCount + " (" + n.Name + ")");
                // find the subgraph
                int radius = vs.SubgraphRadius > 0 ? vs.SubgraphRadius : 1;
                var subgraph = graph.Subgraph(n, radius);

                v.Visualise(subgraph);
            }
            File.WriteAllText(vs.OutputFolder + @"\_sprockitNodes.js", @"function getNodes() { 
   return [
     " + nodeNames.ToString().Substring(2) + @"
     ];
   }");
        }

        private void CopyAppFile(string fileName, string destinationFolder)
        {
            File.Copy(fileName, $@"{destinationFolder}\{fileName}", true);
            //string fileName = settings.OutputFolder + "\\" + settings.HtmlStyleSheet;
            //string fileContents = File.ReadAllText(settings.HtmlStyleSheet);
            //File.WriteAllText(fileName, fileContents);
        }

        private ProcessList ParseFile(string sprockitFilePath)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(ProcessList));
            using TextReader reader = new StringReader(File.ReadAllText(sprockitFilePath));
            var p = (ProcessList)serializer.Deserialize(reader);
            return p;
        }
    }
}
