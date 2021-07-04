using System;
using System.Collections.Generic;
using System.Text;

namespace FireFive.SprockitViz.PipelineGraph
{
    /*
     * Graph class
     * Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net) 
     * http://richardswinbank.net/
     *
     * Class representing an ETL pipeline graph. 
     * 
     * ETL pipelines are directed, acyclic graphs (DAGs). This implementation is inherently directed 
     * because its edges are directed, but it does not explicitly prevent the introduction of cycles.
     * An instance of this class containing cycles would be error-prone (e.g. the recursive GetSize()
     * method would fail to terminate).
     */
    public class Graph
    {
        private Node centre;
        private Dictionary<string, Node> nodes;  // implemented as dictionary to ensure ID uniqueness
        private Dictionary<DirectedEdge, bool> pathCache;  // cache of paths tested for existence (accelerates ContainsPath)

        // collection of nodes
        public IEnumerable<Node> Nodes { get { return nodes.Values; } }

        // get the node collection as a List object
        private List<Node> ConvertNodesToList()
        {
            var list = new List<Node>();
            foreach (var n in Nodes)
                list.Add(n);
            return list;
        }

        // collection of edges
        public List<DirectedEdge> Edges { get; private set; }

        // instantiate a graph with a name
        public Graph(string name)
        {
            nodes = new Dictionary<string, Node>();
            Edges = new List<DirectedEdge>();
            pathCache = new Dictionary<DirectedEdge, bool>();
            Name = name;
        }

        // instantiate a graph with a nominated centre node
        public Graph(Node centre) : this(centre.Name)
        {
            AddNode(centre);
            this.centre = centre;
        }

        // return true if n is the centre of this graph
        public bool IsCentre(Node n)
        {
            return n == centre;
        }

        // the number of nodes in the graph
        public int NodeCount
        {
            get
            {
                return nodes.Count;
            }
        }

        // the name of the graph
        public string Name { get; private set; }

        public string FileNameWithoutExtension
        {
            get
            {
                if (centre != null)
                    return centre.FileNameWithoutExtension;
                return Name.Replace("\\", "_").Replace("/", "_");                
            }
        }

        // The size of this (directed, acyclic) graph. Calculated by decomposing the graph into "ranks":
        //  - first rank is the set of nodes in the graph with no parents (so the graph *must* be acyclic!)
        //  - next rank is their immediate children 
        //  - and so on
        // Width is the size of the widest rank, height is the number of ranks.
        public Size GetSize()
        {
            Size size = Size.Empty;
            GetSize(ConvertNodesToList(), size);
            return size;
        }

        // internal implementation of GetSize. Approach is to:
        //  - identify the the set of nodes in the incoming subgraph with no parent (its roots -- a DAG can have > 1)
        //  - remove the root nodes (top rank)
        //  - recurse into the reduced subgraph
        private void GetSize(List<Node> subgraph, Size size)
        {
            if (subgraph.Count == 0)  // if the graph isn't a DAG, this termination condition will never be met!
                return;

            List<Node> roots = Roots(subgraph);
            size.Width = roots.Count > size.Width ? roots.Count : size.Width;
            size.Height += 1;

            foreach (Node root in roots)
                subgraph.Remove(root);
            GetSize(subgraph, size);
        }

        // return the roots of a graph
        private List<Node> Roots(List<Node> graph)
        {
            List<Node> roots = new List<Node>();
            foreach (Node n in graph)
                if (!n.HasParent(graph, Edges))
                    roots.Add(n);
            return roots;
        }

        // return the subgraph of specified radius around a given node
        internal Graph Subgraph(Node centre, int radius)
        {
            // find the nodes in the subgraph -- this is the set of ancestors and descendants within 
            // the radius distance(ancestors and descendants exist because the graph is directed)
            var subgraph = new Graph(centre);
            subgraph.AddAncestors(centre, radius, this);
            subgraph.AddDescendants(centre, radius, this);

            // if an edge exists between any pair of nodes in the subgraph, add it to the subgraph
            foreach (DirectedEdge e in Edges)
                if (subgraph.Contains(e.Start) && subgraph.Contains(e.End))
                    subgraph.Edges.Add(e);

            // add edges to represent indirect relationships where 
            //  - node B is a descendent of node A in the full graph
            //  - A & B are both present in the subgraph
            //  - but not all nodes on the path from A to B are present in the subgraph.
            foreach (Node start in subgraph.Nodes)
                foreach (Node end in subgraph.Nodes)
                    if (this.ContainsPath(start, end) && !subgraph.ContainsPath(start, end))
                        subgraph.Edges.Add(new DirectedConnection(start, end));

            // the approach to adding indirect edges might add redundant edges 
            // depending on the order in which it finds them -- remove them here
            for (int i = subgraph.Edges.Count - 1; i >= 0; i--)
                if (subgraph.Edges[i] is DirectedConnection)
                {
                    DirectedConnection ie = (DirectedConnection)subgraph.Edges[i];
                    subgraph.Edges.Remove(ie);
                    if (!subgraph.ContainsPath(ie.Start, ie.End))
                        subgraph.Edges.Add(ie);
                }

            return subgraph;
        }

        // add a node's ancestors to a given graph
        private void AddAncestors(Node child, int radius, Graph context)
        {
            if (radius <= 0)
                return;
            foreach (DirectedEdge e in context.Edges)
            {
                if (e.End == child && !Contains(e.Start))
                {
                    AddNode(e.Start);
                    AddAncestors(e.Start, radius - 1, context);
                }
            }
        }

        // add a node's descendents to a given graph
        private void AddDescendants(Node parent, int radius, Graph context)
        {
            if (radius <= 0)
                return;
            foreach (DirectedEdge e in context.Edges)
            {
                if (e.Start == parent && !Contains(e.End))
                {
                    AddNode(e.End);
                    AddDescendants(e.End, radius - 1, context);
                }
            }
        }

        // return true if this graph contains a path between two specified nodes
        private bool ContainsPath(Node start, Node end)
        {
            var key = new DirectedEdge(start, end);

            // return cached value (if cached)
            if (pathCache.ContainsKey(key))
                return pathCache[key];

            // else calculate and cache value
            bool containsPath = false;
            foreach (DirectedEdge e in Edges)
                if (e.Start == start && (e.End == end || ContainsPath(e.End, end)))
                {
                    containsPath = true;
                    break;
                }

            pathCache.Add(key, containsPath);
            return containsPath;
        }

        // return true if this graph contains a specified node
        private bool Contains(Node node)
        {
            foreach (Node n in Nodes)
                if (n == node)
                    return true;
            return false;
        }

        // add a node to the graph, ensuring that it is unqiuely identified by its Id
        internal void AddNode(Node node)
        {
            foreach (string id in nodes.Keys)
                if (id == node.Name)
                    throw new Exception("Node Id " + id + " is already present");
            nodes.Add(node.Name, node);
        }

        // add an edge to the graph between two nodes spcified by their Id values.
        // Id validity isn't checked here but is enforced in the DirectedEdge constructor (which requires non-null arguments).
        internal void AddEdge(string startId, string endId)
        {
            // find the start node from its Id
            Node start = null;
            foreach (Node n in Nodes)
                if (n.Name == startId)
                    start = n;
            if (start == null)
                throw new Exception($"Node {startId} not found");

            // find the end node from its Id
            Node end = null;
            foreach (Node n in Nodes)
                if (n.Name == endId)
                    end = n;
            if (end == null)
                throw new Exception($"Node {endId} not found");

            // add an edge from start -> end
            Edges.Add(new DirectedEdge(start, end));
        }

        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();

            foreach (Node n in Nodes)
                sb.AppendLine(n.ToString());
            foreach (DirectedEdge n in Edges)
                sb.AppendLine(n.ToString());

            return sb.ToString();
        }
    }
}