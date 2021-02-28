﻿using FireFive.SprockitViz.PipelineGraph;

namespace FireFive.SprockitViz.Visualiser
{
    public class SqlTableRenderer : NodeRenderer
    {
        public override string GetTooltip(Node n)
        {
            return $"{n.Name} -- Azure SQL Database table";
        }

        public override string GetLabel(Node n, string outputFolder)
        {
            return $"<<TABLE border=\"0\"><TR><TD><img src=\"{outputFolder}\\sqldb.svg\"/></TD><TD>{n.Name.Replace("[Reporting].[", "").Replace("].[", ".").Replace("]", "")}</TD></TR></TABLE>>";
        }
    }
}
