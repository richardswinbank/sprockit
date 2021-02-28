using System.Xml.Serialization;

namespace FireFive.SprockitViz.Xml
{
    [XmlRoot(ElementName = "Input")]
    public class Input
    {
        [XmlAttribute(AttributeName = "Path")]
        public string Path { get; set; }
    }
}