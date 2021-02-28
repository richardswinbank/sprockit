using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class AdfPipelineRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure Data Factory pipeline";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            if (n.Type == "ADF" && n.Name.Contains('/'))
                return TwoPartLabel(n, outputFolder);
            return SimpleLabel(n, outputFolder);
        }

        private string SimpleLabel(Node n, string outputFolder)
        {
            return $"<<TABLE border=\"0\"><TR><TD>{GetImageTag(n, outputFolder)}</TD><TD>{n.Name}</TD></TR></TABLE>>";
        }

        private string TwoPartLabel(Node n, string outputFolder)
        {
            int off = n.Name.IndexOf('/');
            return $"<<TABLE border=\"0\"><TR><TD ROWSPAN=\"2\">{GetImageTag(n, outputFolder)}</TD>" +
                $"<TD ALIGN=\"LEFT\">{n.Name.Substring(0, off)}</TD></TR><TR><TD ALIGN=\"LEFT\">" +
                $"<FONT COLOR=\"GRAY\" POINT-SIZE=\"10\">{n.Name[(off + 1)..]}</FONT></TD></TR></TABLE>>";
        }

        private string GetImageTag(Node n, string outputFolder)
        {
            return $"<img src=\"{outputFolder}\\datafactory.svg\"/>";
        }
    }
}