namespace FireFive.SprockitViz.PipelineGraph
{
  /*
   * Size class
   * Copyright (c) 2018-2019 Richard Swinbank (richard@richardswinbank.net) 
   * http://richardswinbank.net/
   *
   * Wrapper class for a width/height pair.
   */
  public class Size
  {
    public int Width { get; set; }

    public int Height { get; set; }

    public static Size Empty
    {
      get
      {
        return new Size() { Width = 0, Height = 0 };
      }
    }

    public override string ToString()
    {
      return "Width = " + Width + ", Height = " + Height;
    }
  }
}