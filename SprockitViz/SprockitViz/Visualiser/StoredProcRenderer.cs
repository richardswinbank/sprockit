using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class StoredProcRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure SQL Database stored procedure";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            return $"<<TABLE border=\"0\"><TR><TD><img src=\"{outputFolder}\\sqldb.svg\"/></TD><TD>{n.Name}</TD></TR></TABLE>>";
        }
    }
}
