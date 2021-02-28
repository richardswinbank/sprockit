using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class NodeRenderer
    {
        public string Render(Node n, bool isCentre)
        {
            return Enquote(n.Name) + "["
                + $"href={Enquote("_sprockitviz.html?node=" + n.FileNameWithoutExtension)},target=_parent"
                + (isCentre ? $",fillcolor=gold" : "")
                + $",style={Enquote(GetStyle(n, isCentre))}"
                + $",tooltip={Enquote(GetTooltip(n))}"
                + "]";
        }

        // surround a string with double quotes
        public string Enquote(string s)
        {
            return "\"" + s + "\"";
        }

        public virtual string GetStyle(Node n, bool isCentre)
        {
            return "rounded" + (isCentre ? $",filled" : "");
        }

        public virtual string GetTooltip(Node n)
        {
            return n.Name;
        }
    }
}