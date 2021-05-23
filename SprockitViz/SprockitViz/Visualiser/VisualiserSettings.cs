using FireFive.SprockitViz.PipelineGraph;
using System.Collections.Generic;

namespace FireFive.SprockitViz.Visualiser
{
    public class VisualiserSettings
    {
        #region JSON settings properties

        public string SourceFile { get; set; }
        public string OutputFolder { get; set; }
        public string GraphvizAppFolder { get; set; }
        public bool DeleteWorkingFiles { get; set; }
        public bool Verbose { get; set; }

        #endregion

        public Size MaxSize
        {
            get
            {
                return new Size() { Width = 4, Height = 6 };
            }
        }

        // timeout in seconds
        public int GraphvizTimeout { get { return 5; } }

        public int SubgraphRadius { get { return 2; } }
    }
}
