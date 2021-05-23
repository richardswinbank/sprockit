using FireFive.SprockitViz.Visualiser;
using FireFive.SprockitViz.Xml;
using Microsoft.Extensions.Configuration;
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
        private VisualiserSettings vs;

        public Program(VisualiserSettings settings)
        {
            vs = settings;
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

            var builder = new ConfigurationBuilder()
                .AddJsonFile($"SprockitvizSettings.json", true, true)
                .AddJsonFile($"SprockitvizSettings.Dev.json", true, true);
            var config = builder.Build();

            GraphvizVisualiser.AddRenderer("ADF", new AdfPipelineRenderer());
            GraphvizVisualiser.AddRenderer("ADLS", new AdlsLocationRenderer());
            GraphvizVisualiser.AddRenderer("ASQL", new StoredProcRenderer());
            GraphvizVisualiser.AddRenderer("TABLE", new SqlTableRenderer());
            GraphvizVisualiser.AddRenderer("VIEW", new SqlViewRenderer());
            GraphvizVisualiser.AddRenderer("TVF", new SqlFunctionRenderer());
            GraphvizVisualiser.AddRenderer("PBI", new PbiDatasetRenderer());

            var p = new Program(config.Get<VisualiserSettings>());
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
            var p = ParseFile(vs.SourceFile);
            var graph = p.GetGraph("Sprockit 2.0");
            var v = new GraphvizVisualiser(vs);

            v.Visualise(graph);

            CopyAppFile("_sprockitviz.css", vs.OutputFolder);
            CopyAppFile("_sprockitviz.js", vs.OutputFolder);
            CopyAppFile("_sprockitviz.html", vs.OutputFolder);
            foreach (var file in Directory.GetFiles("Icons"))
                CopyAppFile(file, vs.OutputFolder);

            int i = 0;
            var nodeNames = new StringBuilder();
            foreach (var n in graph.Nodes)
            {
                i++;
                nodeNames.AppendLine(", \"" + n.Name + "\"");

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
            File.Copy(fileName, $@"{destinationFolder}\{Path.GetFileName(fileName)}", true);
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
