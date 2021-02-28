using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class SqlFunctionRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure SQL Database function";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            return $"<<TABLE border=\"0\"><TR><TD><img src=\"{outputFolder}\\sqldb.svg\"/></TD><TD>{n.Name}()</TD></TR></TABLE>>";
        }

        public override string GetStyle(Node n, bool isCentre)
        {
            return "dashed";
        }
    }
}
