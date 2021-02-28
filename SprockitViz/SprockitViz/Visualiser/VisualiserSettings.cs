using FireFive.SprockitViz.PipelineGraph;
using System;
using System.Collections.Generic;
using System.Text;

namespace FireFive.SprockitViz.Visualiser
{
    public class VisualiserSettings
    {
        private Dictionary<string, string> settings;

        public VisualiserSettings(Dictionary<string, string> settings)
        {
            this.settings = settings;
        }

        public string OutputFolder
        {
            get
            {
                return settings["OutputFolder"];
            }
        }

        public Size MaxSize
        {
            get
            {
                return new Size() { Width = 4, Height = 6 };
            }
        }

        public bool Verbose
        {
            get
            {
                return bool.Parse(settings["Verbose"]);
            }
        }

        public string GraphvizAppFolder
        {
            get
            {
                return settings["GraphvizAppFolder"];
            }
        }

        // timeout in seconds
        public int GraphvizTimeout { get { return 5; } }

        public bool DeleteWorkingFiles
        {
            get
            {
                return bool.Parse(settings["DeleteWorkingFiles"]);
            }
        }

        public int SubgraphRadius { get { return 2; } }
    }
}
