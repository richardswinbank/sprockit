using System.Xml.Serialization;

namespace FireFive.SprockitViz.Xml
{
    [XmlRoot(ElementName = "Parameter")]
    public class Parameter
    {
        [XmlAttribute(AttributeName = "Name")]
        public string Name { get; set; }

        [XmlAttribute(AttributeName = "Value")]
        public string Value { get; set; }
    }
}