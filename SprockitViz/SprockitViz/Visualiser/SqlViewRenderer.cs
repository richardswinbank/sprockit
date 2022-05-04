using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class SqlViewRenderer : SqlTableRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{base.GetTooltip(n)} -- Azure SQL Database view";
        }

        public override string GetStyle(Node n, bool isCentre)
        {
            return "dashed";
        }
    }
}
