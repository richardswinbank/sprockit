using FireFive.SprockitViz.PipelineGraph;
using System.Text;

namespace FireFive.SprockitViz.Visualiser
{
    public class NodeRenderer
    {
        public string Render(Node n, bool isCentre, string outputFolder)
        {
            return Enquote(n.Name) + "["
                + $"label={GetLabel(n)}"
                + $",href={Enquote("_sprockitviz.html?node=" + n.Name)},target=_parent"
                + (isCentre ? $",fillcolor=gold" : "")
                + $",style={Enquote(GetFullStyle(n, isCentre))}"
                + $",tooltip={Enquote(GetTooltip(n) + GetParameterSummary(n))}"
                + "]";
        }

        // surround a string with double quotes
        private string Enquote(string s)
        {
            return "\"" + s + "\"";
        }

        private string GetParameterSummary(Node n)
        {
            var sb = new StringBuilder();
            foreach (var pn in n.PropertyNames)
                if (pn.StartsWith("Parameter"))
                    sb.Append("&#13;&#10; - " + n.GetProperty(pn));

            if (sb.Length == 0)
                return "";
            return "&#13;&#10;-------------&#13;&#10;Parameters:" + sb.ToString();
        }

        public virtual string GetLabel(Node n)
        {
            return Enquote(n.Name);
        }

        public virtual string GetTooltip(Node n)
        {
            return n.Name;
        }

        private string GetFullStyle(Node n, bool isCentre)
        {
            var s = GetStyle(n, isCentre);
            return s + (s.Length > 0 ? "," : "") + "rounded" + (isCentre ? $",filled" : "");
        }

        public virtual string GetStyle(Node n, bool isCentre)
        {
            return "";
        }
    }
}