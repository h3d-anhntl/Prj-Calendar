package net.prjcanlendar.component.YCNGhiPhep.skin.components.recurrence
{
  import net.fproject.calendar.recurrence.RRule;
  
  public interface IRecurrenceRuleEditor
  {
    
    function get recurrenceRule():RRule;
    
    function set recurrenceRule(value:RRule):void;
    
    function reset():void;
    
    function isValid():Boolean;
    
  }
}
