using System.Xml.Serialization;

namespace FireFive.SprockitViz.Xml
{
    [XmlRoot(ElementName = "Output")]
    public class Output
    {
        [XmlAttribute(AttributeName = "Path")]
        public string Path { get; set; }
    }
}