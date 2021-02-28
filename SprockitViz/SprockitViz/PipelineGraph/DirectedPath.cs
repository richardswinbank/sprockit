using System.Collections.Generic;

namespace FireFive.SprockitViz.PipelineGraph
{
   /*
   * DirectedPath class
   * Copyright (c) 2018-2021 Richard Swinbank (richard@richardswinbank.net) 
   * http://richardswinbank.net/
   *
   * Class representing an path as an ordered sequence of nodes.
   */

   class DirectedPath : List<Node>
   {
      // create a new path containing a single node
      public DirectedPath(Node n) : base()
      {
         Add(n);
      }

      // add a new node at the *start* of this bpath
      internal DirectedPath Prefix(Node n)
      {
         Insert(0, n);
         return this;
      }
   }
}
