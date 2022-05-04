using FireFive.Sprockit.GraphSource;
using FireFive.SprockitViz.PipelineGraph;
using System.Xml.Serialization;

namespace FireFive.SprockitViz.Xml
{
    [XmlRoot("Processes")]
    public class ProcessList : AbstractGraphSource
    {
        [XmlElement(ElementName = "Process")]
        public Process[] Processes { get; set; }

        [XmlAttribute(AttributeName = "Group")]
        public string Group { get; set; }

        public override Graph GetGraph(string graphName)
        {
            Graph graph = new Graph(graphName);

            foreach (var p in Processes)
            {
                var n = new Node(p.Path)
                {
                    Type = p.Type
                };

                n.SetProperty("DefaultWatermark", p.DefaultWatermark);
                n.SetProperty("Priority", p.Priority);
                n.SetProperty("LogPropertyUpdates", p.LogPropertyUpdates);
                n.SetProperty("DefaultWatermark", p.DefaultWatermark);                
                n.SetProperty("Group", p.Group ?? "1");

                if (p.Parameters != null)
                    for (int i = 0; i < p.Parameters.Length; i++)
                        n.SetProperty($"Parameter{i}", $"{p.Parameters[i].Name} = {p.Parameters[i].Value}");

                graph.AddNode(n);
            }

            foreach (var p in Processes)
            {
                if (p.Inputs != null)
                    foreach (var i in p.Inputs)
                        graph.AddEdge(i.Path, p.Path);
                if (p.Outputs != null)
                    foreach (var o in p.Outputs)
                        graph.AddEdge(p.Path, o.Path);
            }

            return graph;
        }

        public override string ToString()
        {
            return $"{Processes.Length} processes";
        }
    }
}
