using FireFive.SprockitViz.PipelineGraph;
using FireFive.SprockitViz.Visualiser;

namespace FireFive.SprockitViz
{
    public class PbiDatasetRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Power BI shared dataset";
        }

        public override string GetLabel(Node n)
        {
            return $"<<TABLE border=\"0\"><TR><TD></TD><TD>{n.Name}</TD></TR></TABLE>>";
        }
    }
}