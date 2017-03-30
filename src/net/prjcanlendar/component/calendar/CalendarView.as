package net.prjcanlendar.component.calendar
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import model.CalendarItem;
	
	import net.fproject.calendar.WeekDay;
	import net.fproject.calendar.WorkCalendar;
	import net.fproject.calendar.WorkShift;
	import net.fproject.calendar.components.Calendar;
	import net.fproject.calendar.components.DateInterval;
	import net.fproject.calendar.events.CalendarEvent;
	import net.fproject.core.TimeUnit;
	import net.fproject.di.Injector;
	import net.fproject.ui.buttonBar.ButtonBar;
	import net.fproject.ui.toolbar.supportClasses.ToolbarButton;
	import net.fproject.utils.DateTimeUtil;
	
	public class CalendarView extends SkinnableComponent
	{
		public function CalendarView()
		{
			super();
			Injector.inject(this);
			
			
			workCalendar = new WorkCalendar("Custom");
			var workingTimes:Vector.<WorkShift> = new Vector.<WorkShift>(1);
			workingTimes[0] = WorkShift.create(0, DateTimeUtil.getTime(24));
			
			var dayoff:WeekDay = new WeekDay();
			dayoff.isWorking = false;
			dayoff.dayOfWeek = 0;
			
			var dayoff6:WeekDay = new WeekDay();
			dayoff6.isWorking = false;
			dayoff6.dayOfWeek = 6;
			
			workCalendar.weekDays[0] = dayoff;
			for (var i:int = 1; i < 6; i++)
			{
				workCalendar.setWeekDayWorkShifts(i, workingTimes);
			}
			workCalendar.weekDays[6] = dayoff6;
		}
		
		[Bindable]
		public var resourceCollection:ArrayCollection;
		
		[Bindable]
		public var workCalendar:WorkCalendar;
		
		public function calendarControl_creationComplete(event:FlexEvent):void
		{
			var source:Array = new Array;
			var now:Date = new Date;
			var finish:Date = new Date(now.time + TimeUnit.HOUR.milliseconds);
			
			source.push(createNewEvent(now,finish,"newItem",calendarControl.timeRangeSelectionCalendar)); 
			resourceCollection =  new ArrayCollection(source);
		}
		
		public function todayButton_clickHandler(event:MouseEvent):void
		{
			calendarControl.referenceDate = new Date();
			calendarControl.dateInterval = DateInterval.DAY; 
		}
		
		public function prevButton_clickHandler(event:MouseEvent):void
		{
			calendarControl.previousRange();
		}
		
		public function nextButton_clickHandler(event:MouseEvent):void
		{
			calendarControl.nextRange();
		}
		
		public function dateIntervalButtonBar_changeHandler(event:IndexChangeEvent):void
		{
			if (calendarControl.referenceDate == null) {          
				calendarControl.referenceDate = calendarControl.endDate;              
			}
			if (event.newIndex != -1) {
				calendarControl.dateInterval = dateIntervalButtonBar.dataProvider.getItemAt(event.newIndex).value.toString();
			}
		}
		
		public function calendarControl_visibleTimeRangeChangedHandler(event:CalendarEvent):void
		{
			// TODO Auto-generated method stub
			var e:Date = calendarControl.calendar.dateAddByTimeUnit(calendarControl.renderData.endDisplayedDate, TimeUnit.DAY, 1);
			rangeLabel.text = calendarControl.getTimeRangeLabel(null, calendarControl.renderData.startDisplayedDate, e);
			
			// Update the date interval button bar
			var dateInterval:String = calendarControl.renderData.dateInterval;
			
			/*if (dateInterval == DateInterval.DAY)
				dateIntervalButtonBar.selectedIndex = 0;*/
			if (dateInterval == DateInterval.WEEK)
				dateIntervalButtonBar.selectedIndex = 0;
			else if (dateInterval == DateInterval.MONTH)
				dateIntervalButtonBar.selectedIndex = 1;
			
			/*if (_dateChooserHandler == null)
			{
			_dateChooserHandler = new DateChooserHandler(
			calendarControl, monthsPanel.leftDateChooser, monthsPanel.rightDateChooser);
			}*/
			
			var duration:int = calendarControl.calendar.getDays(event.startTime, event.endTime);
			calendarControl.setStyle("showDataGroupDuringScrollAnimation", duration <= 2);
		}
		
		public function calendarGrid_doubleClick(event:MouseEvent):void
		{
			createNewEventFromSelection(calendarControl.timeRangeSelection);
		}
		
		private function createNewEventFromSelection(selection:Vector.<Date>, summary:String=null, 
													 minimalDuration:Boolean=false):void 
		{                
			if (selection != null) {
				var startTime:Date = selection[0] as Date;
				var endTime:Date = selection[1] as Date;
				
				if (minimalDuration) {                                    
					var nextStartTime:Date = calendarControl.calendar.dateAddByTimeUnit(startTime, TimeUnit.HOUR, 1);
					
					if (endTime < nextStartTime) {
						endTime = nextStartTime;
					}
				}
				calendarControl.timeRangeSelection = null;
				
				resourceCollection.addItem(createNewEvent(startTime, endTime, summary, calendarControl.timeRangeSelectionCalendar));
			} 
		}
		
		private function createNewEvent(startTime:Date, endTime:Date, label:String=null, calendar:Object=null):CalendarItem 
		{
			
			if (label == null) {
				label = "New Resource";
			}
			
			var calendarId:String
			
			var addedItem:CalendarItem = new CalendarItem();
			addedItem.startTime = startTime;
			addedItem.endTime = endTime;
			addedItem.label = label;
			
			return addedItem;
		}
		
		[SkinPart(required="true",type="static")]
		public var rangeLabel:Label;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="nextButton_clickHandler")]
		public var nextButton:ToolbarButton;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="todayButton_clickHandler")]
		public var todayButton:ToolbarButton;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="prevButton_clickHandler")]
		public var prevButton:ToolbarButton;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="change",handler="dateIntervalButtonBar_changeHandler")]
		public var dateIntervalButtonBar:ButtonBar;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="mx.events.FlexEvent.CREATION_COMPLETE", handler="calendarControl_creationComplete")]
		[EventHandling(dispatcher="grid",event="doubleClick",handler="calendarGrid_doubleClick")]
		[EventHandling(event="visibleTimeRangeChanged",handler="calendarControl_visibleTimeRangeChangedHandler")]
		[PropertyBinding(dataProvider="resourceCollection@",workCalendar="workCalendar@")]
		public var calendarControl:Calendar;
	}
}