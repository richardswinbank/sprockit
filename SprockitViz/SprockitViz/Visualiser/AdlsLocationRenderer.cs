using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class AdlsLocationRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{GetBasicTooltip(n)} -- Azure Data Lake Storage location";
        }

        public override string GetLabel(Node n)
        {
            return $"<<TABLE border=\"0\"><TR><TD WIDTH=\"30\" HEIGHT=\"30\" FIXEDSIZE=\"TRUE\"><img SCALE=\"TRUE\" src=\"datalake.svg\"/></TD><TD>{n.Name}</TD></TR></TABLE>>";
        }
    }
}