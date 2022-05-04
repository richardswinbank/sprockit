using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class StoredProcRenderer : SqlTableRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{base.GetTooltip(n)} -- Azure SQL Database stored procedure";
        }
    }
}
