package net.prjcanlendar.component.YCNGhiPhep.skin.components.recurrence
{
  import net.fproject.calendar.recurrence.RRule;
  
  import flash.events.MouseEvent;
  
  import mx.core.UIComponent;
  
  import spark.components.Group;
  import spark.components.Label;
  
  public class Util
  {
    public function Util()
    {
    }
    
    /**
     * Validates that a string that is representing a integer.
     * 
     * @param s The string to parse and validate.
     * @param nonNeg Whether negative values are valid or not.
     * 
     * @return The integer.
     */  
    public static function validateInt(s:String, nonNeg:Boolean=false):int {
      if (s == "-") {
        s = "-1";
      }
      
      var i:int = parseInt(s);
      if (nonNeg && i < 0 ) {
        i = 1;
      }
      
      return i;
    }
    
    /**
     * Checks that the properties of the specified recurrence rule are at their default value.
     * The properties listed in the exceptions array are not tested.
     * 
     * @param r The recurrence rule.
     * @param exceptions The list of properties to not test.
     * 
     * @return <code>true</code> if the properties are at set to their default value.  
     *
     */ 
    public static function checkDefaults(r:RRule, exceptions:Array):Boolean {
      var keys:Array = ["freq", "until", "count", "interval", "byDay", "byMonth", 
                        "byMonthDay", "byWeekNo", "byYearDay", "bySetPos",
                        "byHour", "byMinute", "byMinute", "bySecond", "weekStart"];
      var expectedResult:Array = [RRule.DAILY, null, 0, 1, [], [], [], [], [], [], [], [], [], [], null];
      
      for (var i:uint=0; i<keys.length; i++) {
        
        if (exceptions.indexOf(keys[i]) == -1) {
          
          var ok:Boolean = true;
          
          if (expectedResult[i] != null && expectedResult[i] is Array) {
            ok = r[keys[i]].length == 0
          } else { 
            ok = r[keys[i]] == expectedResult[i];
          }                 
          
          if (!ok) {
            trace("check default failed:", keys[i], "value:", r[keys[i]], "expected", expectedResult[i]);
            return false;
          } 
        } 
      }
      
      return true;                
    }
    
    /**
     * Creates an user interface according to the format string.
     * 
     * <p>
     * This method is used to internationalize user interfaces that has a set of input components 
     * (combos, text inputs...) with some text before/after/between.
     * </p>
     * 
     * <p>
     * The UI is built in the following way:
     * <ul>
     *   <li>The string is separated in several tokens using the '|' delimiter.</li>
     *   <li>If a token starts with '$', the component of the root component that have the 
     *       ID (minus the '$') of this token is inserted.</li>
     *   <li>If not, a Label component is inserted to represent the token text.</li>
     * </ul> 
     * </p>
     * 
     * @param root The object that contains the component to put in the container.
     * @param container The container of the UI components.
     * @param format The format string.
     * @param textClickHandler The event handler registered on a mouse click on a created Label component.
     * 
     */  
    public static function buildUI(root:UIComponent, container:Group, format:String, textClickHandler:Function):void {

      container.removeAllElements();
        
      var elts:Array = format.split("|");
      
      for each (var elt:String in elts) {
        if (elt != "") {
          if (elt.charAt(0) == "$") {
            
            var comp:UIComponent = root[elt.substr(1)] as UIComponent;
            container.addElement(comp);
            
          } else {
            
            if (elt == " ") {
              
              /*var spacer:Rect = new Rect();
              spacer.width = 10;
              //spacer.setActualSize(8, 10);              
              container.addElement(spacer);    */                       
              
            } else {
            
              var label:Label = new Label();
              label.setStyle("paddingBottom", 0);
              label.text = elt;
              if (textClickHandler != null) {
                label.addEventListener(MouseEvent.CLICK, textClickHandler);
              }
              container.addElement(label);
            }
          }
        }
      }
      //container.invalidateSize();
      //container.invalidateProperties();
      //container.invalidateDisplayList();
      //container.validateSize(true);
      //LayoutManager.getInstance().validateClient(container);
    }

  }
}
