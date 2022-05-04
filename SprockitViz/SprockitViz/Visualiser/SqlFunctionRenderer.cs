using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class SqlFunctionRenderer : SqlViewRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{base.GetTooltip(n)} -- Azure SQL Database function";
        }

        public override string GetLabel(Node n)
        {
            return base.GetLabel(n).Replace("</TD></TR></TABLE>", "()</TD></TR></TABLE>");
        }
    }
}
