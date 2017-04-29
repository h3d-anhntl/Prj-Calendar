package net.prjcanlendar.component.YCNGhiPhep.skin.components
{
  import flash.events.Event;
  
  public class DrillDownEvent extends Event
  {
    public static const DRILL_DOWN:String = "drillDown";
    
    public function DrillDownEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, date:Date=null)
    {
      super(type, bubbles, cancelable);
    }
    
    private var _date:Date;

    public function get date():Date
    {
      return _date;
    }
    
  }
}
