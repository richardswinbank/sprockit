using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class AdlsLocationRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure Data Lake Storage location";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            return $"<<TABLE border=\"0\"><TR><TD><img src=\"{outputFolder}\\datalake.svg\"/></TD><TD>{n.Name}</TD></TR></TABLE>>";
        }
    }
}