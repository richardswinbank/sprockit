using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class SqlFunctionRenderer : SqlViewRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure SQL Database function";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            return base.GetLabel(n, outputFolder).Replace("</TD></TR></TABLE>", "()</TD></TR></TABLE>");
        }
    }
}
