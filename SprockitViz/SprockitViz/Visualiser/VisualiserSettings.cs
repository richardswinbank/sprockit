using FireFive.SprockitViz.PipelineGraph;

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
        public bool Interactive { get; set; }

        #endregion

        public Size MaxSize
        {
            get
            {
                return new Size() { Width = 4, Height = 6 };
            }
        }
        public int SubgraphRadius { get { return 2; } }

        // timeout in seconds
        public int GraphvizTimeout { get { return 5; } }

    }
}
