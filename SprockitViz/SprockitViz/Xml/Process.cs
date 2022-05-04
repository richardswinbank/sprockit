using System.Xml.Serialization;

namespace FireFive.SprockitViz.Xml
{
    [XmlRoot(ElementName = "Process")]
    public class Process
    {
        [XmlAttribute(AttributeName = "Path")]
        public string Path { get; set; }

        [XmlAttribute(AttributeName = "Type")]
        public string Type { get; set; }

        [XmlAttribute(AttributeName = "Group")]
        public string Group { get; set; }

        [XmlAttribute(AttributeName = "DefaultWatermark")]
        public string DefaultWatermark { get; set; }

        [XmlAttribute(AttributeName = "Priority")]
        public string Priority { get; set; }

        [XmlAttribute(AttributeName = "LogPropertyUpdates")]
        public string LogPropertyUpdates { get; set; }

        [XmlArray("Parameters")]
        [XmlArrayItem("Parameter", typeof(Parameter))]
        public Parameter[] Parameters { get; set; }

        [XmlArray("Requires")]
        [XmlArrayItem("Input", typeof(Input))]
        public Input[] Inputs { get; set; }

        [XmlArray("Produces")]
        [XmlArrayItem("Output", typeof(Output))]
        public Output[] Outputs { get; set; }
    }
}