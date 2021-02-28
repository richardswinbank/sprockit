using System;
using System.Collections.Generic;

namespace FireFive.SprockitViz.PipelineGraph
{
    /*
     * Node class
     * Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net) 
     * http://richardswinbank.net/
     *
     * Class representing a node (some kind of database object) in an ETL pipeline graph.
     */
    public class Node
    {
        private Dictionary<string, string> properties;

        public Node(string id)
        {
            if (id == null || id.Length == 0)
                throw new Exception("Node ID must be non-null and non-zero in length");
            Name = id;
            properties = new Dictionary<string, string>();
            // Weight = 0;
        }

        // unique identifier for the object
        public string Name { get; set; }

        public string FileNameWithoutExtension { get { return Name.Replace('/', '_').Replace('\\', '_'); } }

        public string Type { get; set; }

        public void SetProperty(string propertyName, string propertyValue)
        {
            properties[propertyName] = propertyValue;
        }

        public IEnumerable<string> PropertyNames
        {
            get
            {
                return properties.Keys;
            }
        }

        //public bool HasProperty(string propertyName)
        //{
        //   return properties.ContainsKey(propertyName);
        //}

        public string GetProperty(string propertyName)
        {
           return properties[propertyName];
        }

        public override string ToString()
        {
            return $"Node[Name={Name},Type={Type}]";
        }

        // return true if parameter "nodes" contains a node 'parent' 
        // and parameter "edges" contains an edge 'parent' -> this.
        internal bool HasParent(List<Node> nodes, List<DirectedEdge> edges)
        {
            foreach (DirectedEdge e in edges)
                if (e.End == this && nodes.Contains(e.Start))
                    return true;
            return false;
        }
    }
}