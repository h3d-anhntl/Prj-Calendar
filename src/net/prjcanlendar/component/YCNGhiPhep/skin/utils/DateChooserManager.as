///////////////////////////////////////////////////////////////////////////////
// Licensed Materials - Property of IBM
// 5724-Y31,5724-Z78
// © Copyright IBM Corporation 2007, 2013. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
///////////////////////////////////////////////////////////////////////////////
package net.prjcanlendar.component.YCNGhiPhep.skin.utils
{
  import mx.controls.DateChooser;
  import mx.events.CalendarLayoutChangeEvent;
  import mx.events.DateChooserEvent;
  
  import net.fproject.calendar.components.Calendar;
  import net.fproject.calendar.components.DateInterval;
  import net.fproject.calendar.events.CalendarEvent;
  import net.fproject.core.TimeUnit;
  import net.fproject.utils.GregorianCalendar;
  /**
   * Manages the synchronization between the Calendar and the DateChoosers.
   */  
  public class DateChooserManager
  {
        
    private var _calendar:Calendar;
    private var _dateChooser1:DateChooser;
    private var _dateChooser2:DateChooser;
    
    public function DateChooserManager(calendar:Calendar, dateChooser1:DateChooser, dateChooser2:DateChooser) {
      _calendar = calendar;
      
      _dateChooser1 = dateChooser1;
      _dateChooser2 = dateChooser2;
      
      if (calendar.renderData != null) {
      
        _dateChooser1.selectedRanges = [{rangeStart:calendar.renderData.startDisplayedDate, rangeEnd: calendar.renderData.endDisplayedDate}];
        _dateChooser2.selectedRanges = [{rangeStart:calendar.renderData.startDisplayedDate, rangeEnd: calendar.renderData.endDisplayedDate}];
        
        _dateChooser1.displayedMonth = calendar.renderData.startDisplayedDate.month;
        _dateChooser1.displayedYear = calendar.renderData.startDisplayedDate.fullYear;      
          
        var nextYear:Boolean = calendar.renderData.startDisplayedDate.month == 11;
          
        if (nextYear) {
          _dateChooser2.displayedMonth = 0;        
          _dateChooser2.displayedYear =  calendar.renderData.startDisplayedDate.fullYear + 1;
        } else {
          _dateChooser2.displayedMonth = calendar.renderData.startDisplayedDate.month + 1;        
          _dateChooser2.displayedYear =  calendar.renderData.startDisplayedDate.fullYear;            
        }
      }
            
      
      initListeners();   
    }
    
    private function initListeners():void {
      _calendar.addEventListener(CalendarEvent.VISIBLE_TIME_RANGE_CHANGED, calendar_visibleTimeRangeChanged);
      _dateChooser1.addEventListener(DateChooserEvent.SCROLL, dateChooserScrolled); 
      _dateChooser2.addEventListener(DateChooserEvent.SCROLL, dateChooserScrolled2);
      _dateChooser1.addEventListener(CalendarLayoutChangeEvent.CHANGE, dateChooserHandler);
      _dateChooser2.addEventListener(CalendarLayoutChangeEvent.CHANGE, dateChooserHandler);
    }
    
    /**
     * Listener of date range changes to synchronize the date chooser.
     */  
    private function calendar_visibleTimeRangeChanged(event:CalendarEvent):void {
      
      var s:Date = event.startTime;
      var e:Date = event.endTime;
      
      var ranges:Array = [{ rangeStart: s, rangeEnd: e }]; 
              
      _dateChooser1.selectedRanges = ranges;
      _dateChooser2.selectedRanges = ranges;        
      
      //The length of a range cannot exceed 42 days on 2 months
              
      if ((_dateChooser1.displayedMonth == s.month && _dateChooser1.displayedYear == s.fullYear) || 
          (_dateChooser2.displayedMonth == s.month && _dateChooser2.displayedYear == s.fullYear && 
           _dateChooser2.displayedMonth == e.month && _dateChooser2.displayedYear == e.fullYear)) {
        //noop
      } else {
        
        _dateChooser1.displayedMonth = event.startTime.month;
        _dateChooser1.displayedYear =  event.startTime.fullYear;
        
        var nextYear:Boolean = event.startTime.month == 11;
        
        if (nextYear) {
          _dateChooser2.displayedMonth = 0;        
          _dateChooser2.displayedYear =  event.startTime.fullYear + 1;
        } else {
          _dateChooser2.displayedMonth = event.startTime.month + 1;        
          _dateChooser2.displayedYear =  event.startTime.fullYear;            
        }                    
      }
                                       
    }
    
    /**
     * Listener of scrolled data chooser event.
     */   
    private function dateChooserScrolled2(event:DateChooserEvent):void {
      
      if (_dateChooser2.displayedMonth == 0) {
        _dateChooser1.displayedMonth = 11;
        _dateChooser1.displayedYear = _dateChooser2.displayedYear - 1;
      } else {
        _dateChooser1.displayedMonth = _dateChooser2.displayedMonth - 1;
        _dateChooser1.displayedYear = _dateChooser2.displayedYear;           
      }
      
      dateChooserScrolledImpl();       
    }
    
    /**
     * Listener of scrolled data chooser event.
     */
    private function dateChooserScrolled(event:DateChooserEvent):void {
      if (_dateChooser1.displayedMonth == 11) {
        _dateChooser2.displayedMonth = 0;
        _dateChooser2.displayedYear = _dateChooser1.displayedYear + 1  
      } else {       
        _dateChooser2.displayedMonth = _dateChooser1.displayedMonth + 1;
        _dateChooser2.displayedYear = _dateChooser1.displayedYear;
      }        
      dateChooserScrolledImpl();
    }
    
    /**
     * Listener of scrolled data chooser event.
     */
    private function dateChooserScrolledImpl():void {
                     
      var calendar:GregorianCalendar = _calendar.calendar;
      
      //if the calendar is in date mode
      _calendar.referenceDate = null;
      
      switch (_calendar.renderData.dateInterval) {
        case DateInterval.DAY:
          //show the first day if the month
          _calendar.startDate = new Date(_dateChooser1.displayedYear, _dateChooser1.displayedMonth);
          _calendar.endDate = _calendar.startDate;           
          break;
        case DateInterval.WEEK:
          //show the a range from the first day of month and that lasts the current duration.
          var d:Number = _calendar.renderData.endDisplayedDate.time - _calendar.renderData.startDisplayedDate.time;
          _calendar.startDate = new Date(_dateChooser1.displayedYear, _dateChooser1.displayedMonth);
          _calendar.endDate = new Date(_calendar.startDate.time + d);           
          break;
        case DateInterval.MONTH:
          //show the current month
          _calendar.startDate = new Date(_dateChooser1.displayedYear, _dateChooser1.displayedMonth);
          //compute the last day of the month
          var date:Date = calendar.dateAddByTimeUnit(_calendar.startDate, TimeUnit.MONTH, 1);
          date = calendar.dateAddByTimeUnit(date, TimeUnit.DAY, -1, true); 
          _calendar.endDate = date;            
          break;
      }
    }
    
    /**
     * Listener of time range selection on a data chooser.
     */         
    private function dateChooserHandler(e:CalendarLayoutChangeEvent):void {
      var dch:DateChooser = e.currentTarget as DateChooser;
      var dc2:DateChooser = dch == _dateChooser1 ? _dateChooser2 : _dateChooser1;
      
      dc2.selectedRanges = [];
      
      var r:Object = dch.selectedRanges[0];
      if (r == null) {
        return;
      }
                               
      _calendar.referenceDate = null;
      _calendar.startDate = r.rangeStart;
      _calendar.endDate = r.rangeEnd;                                 
    }          


  }
}
