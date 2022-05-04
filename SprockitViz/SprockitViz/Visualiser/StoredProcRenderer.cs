using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class StoredProcRenderer : SqlTableRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{GetBasicTooltip(n)} -- Azure SQL Database stored procedure";
        }
    }
}
