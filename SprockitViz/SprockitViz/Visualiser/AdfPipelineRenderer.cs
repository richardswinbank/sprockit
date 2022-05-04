using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class AdfPipelineRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{GetBasicTooltip(n)} -- Azure Data Factory pipeline";
        }

        public override string GetLabel(Node n)
        {
            if (n.Type == "ADF" && n.Name.Contains('/'))
                return TwoPartLabel(n);
            return SimpleLabel(n);
        }

        private string SimpleLabel(Node n)
        {
            return $"<<TABLE border=\"0\"><TR><TD WIDTH=\"30\" HEIGHT=\"30\" FIXEDSIZE=\"TRUE\">{GetImageTag(n)}</TD><TD>{n.Name}</TD></TR></TABLE>>";
        }

        private string TwoPartLabel(Node n)
        {
            int off = n.Name.IndexOf('/');
            return $"<<TABLE border=\"0\"><TR><TD ROWSPAN=\"2\" WIDTH=\"30\" HEIGHT=\"30\" FIXEDSIZE=\"TRUE\">{GetImageTag(n)}</TD>" +
                $"<TD ALIGN=\"LEFT\">{n.Name.Substring(0, off)}</TD></TR><TR><TD ALIGN=\"LEFT\">" +
                $"<FONT COLOR=\"GRAY\" POINT-SIZE=\"10\">{n.Name[(off + 1)..]}</FONT></TD></TR></TABLE>>";
        }

        private string GetImageTag(Node n)
        {
            return $"<img scale=\"true\" src=\"datafactory.svg\"/>";
            //<TD<img SCALE=\"TRUE\" src
        }
    }
}