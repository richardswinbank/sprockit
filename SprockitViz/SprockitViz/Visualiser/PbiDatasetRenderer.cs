using FireFive.SprockitViz.PipelineGraph;
using FireFive.SprockitViz.Visualiser;

namespace FireFive.SprockitViz
{
    public class PbiDatasetRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{GetBasicTooltip(n)} -- Power BI shared dataset";
        }

        public override string GetLabel(Node n)
        {
            return $"<<TABLE border=\"0\"><TR><TD WIDTH=\"30\" HEIGHT=\"30\" FIXEDSIZE=\"TRUE\"><img SCALE=\"TRUE\" src=\"aas.svg\"/></TD><TD>{n.Name}</TD></TR></TABLE>>";
        }
    }
}