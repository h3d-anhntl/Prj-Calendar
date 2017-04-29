package net.prjcanlendar.component.YCNGhiPhep.skin
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DateChooser;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ColorUtil;
	
	import spark.components.Alert;
	import spark.components.supportClasses.SkinnableComponent;
	
	import net.fproject.fproject_internal;
	import net.fproject.calendar.components.Calendar;
	import net.fproject.calendar.components.CalendarDisplayMode;
	import net.fproject.calendar.components.DateInterval;
	import net.fproject.calendar.components.supportClasses.CalendarColumnHeaderRendererBase;
	import net.fproject.calendar.components.supportClasses.CalendarRenderItem;
	import net.fproject.calendar.components.supportClasses.CalendarUtil;
	import net.fproject.calendar.events.CalendarEditingEvent;
	import net.fproject.calendar.events.CalendarEditingEventReason;
	import net.fproject.calendar.events.CalendarEvent;
	import net.fproject.calendar.recurrence.IRecurrenceInstance;
	import net.fproject.calendar.supportClasses.CalendarRenderData;
	import net.fproject.core.TimeUnit;
	import net.fproject.di.Injector;
	import net.fproject.utils.GregorianCalendar;
	import net.prjcanlendar.component.YCNGhiPhep.skin.components.EditingConfirmationPanel;
	import net.prjcanlendar.component.YCNGhiPhep.skin.components.RemoveConfirmationPanel;
	import net.prjcanlendar.component.YCNGhiPhep.skin.utils.DateChooserManager;

	public class CalenderBanTinSkinView extends SkinnableComponent
	{
		public function CalenderBanTinSkinView()
		{
			Injector.inject(this);
		}
		
		private var pastEventsColor:uint = 0xEEEEEE;
		private var _dateChooserManager:DateChooserManager;
		
		private var baseModel:Array = [        
			{ d:"1", s:"8",  e:"3",  key:"meeting",  calendar:"0"},
			{ d:"1", s:"12", e:"2",  key:"misc",     calendar:"1"},
			{ d:"1", s:"14", e:"2",  key:"meeting",  calendar:"0"},
			{ d:"1", s:"15", e:"3",  key:"training", calendar:"0"},
			{ d:"1", s:"20", e:"2",  key:"misc",     calendar:"1"},
			{ d:"2", s:"8",  e:"1",  key:"meeting",  calendar:"0"},
			{ d:"2", s:"9",  e:"1",  key:"meeting",  calendar:"0"},
			{ d:"2", s:"10", e:"2",  key:"meeting",  calendar:"1"},
			{ d:"2", s:"12", e:"2",  key:"misc",     calendar:"0"},
			{ d:"2", s:"14", e:"4",  key:"training", calendar:"0"},
			{ d:"3", s:"0",  e:"24", key:"misc",     calendar:"1"},
			{ d:"3", s:"8", e:"3",   key:"meeting",  calendar:"0"},
			{ d:"3", s:"13", e:"3",  key:"training", calendar:"0"},
			{ d:"4", s:"7",  e:"3",  key:"meeting",  calendar:"0"},
			{ d:"4", s:"12", e:"2",  key:"misc",     calendar:"0"},
			{ d:"4", s:"13", e:"3",  key:"meeting",  calendar:"1"},
			{ d:"4", s:"14", e:"3",  key:"training", calendar:"0"},
			{ d:"4", s:"19", e:"2",  key:"misc",     calendar:"0"},         
			{ d:"5", s:"9",  e:"3",  key:"meeting",  calendar:"1"},
			{ d:"5", s:"12", e:"2",  key:"misc",     calendar:"0"},         
			{ d:"5", s:"15", e:"3",  key:"training", calendar:"0"},
			{ d:"5", s:"20", e:"4",  key:"misc",     calendar:"0"}          
		];
		
		
		private function createDefaultModel():Array {
			
			var gCal:GregorianCalendar = new GregorianCalendar();
			var startOfWeek:Date = gCal.fproject_internal::floor(new Date(), TimeUnit.WEEK, 1);          
			var fdow:int = resourceManager.getInt('controls', 'firstDayOfWeek');
			
			for each (var evt:Object in baseModel) {
				var dayOfWeek:int = parseInt(evt.d) - fdow;          
				
				var startHour:int = parseInt(evt.s);
				var duration:int = parseInt(evt.e);
				
				var s:Date = gCal.dateAddByTimeUnit(startOfWeek, TimeUnit.DAY, dayOfWeek);                   
				s = gCal.dateAddByTimeUnit(s, TimeUnit.HOUR, startHour, true);
				
				var e:Date = gCal.dateAddByTimeUnit(s, TimeUnit.HOUR, duration);
				
				evt.startTime = s.toString();
				evt.endTime = e.toString();
				
				evt.label = resourceManager.getString("calendarsample", "model.summary." + evt.key);          
			}
			
			return baseModel;
		}
		
		
		
		protected function application_initializeHandler(event:FlexEvent):void
		{        
			calendarControl.dataProvider = new ArrayCollection(createDefaultModel());
			/*eventPropertiesPanel.calendar = calendarControl;       
			eventPropertiesPanel.calendars = calendars;
			calendarColorPicker1.selectedColor = calendars[0].color;
			calendarColorPicker2.selectedColor = calendars[1].color;
			pastEventsColorPicker.selectedColor = pastEventsColor;
			eventPropertiesPanel.addEventListener("createEvent", eventPanelCreateHandler);
			eventPropertiesPanel.addEventListener("deleteEvent", eventPanelDeleteHandler); */ 
		}
		
		private function eventPanelCreateHandler(event:Event):void {
			
			var e:Date; 
			if (calendarControl.timeRangeSelection != null) {
				e = calendarControl.calendar.dateAddByTimeUnit(calendarControl.renderData.endDisplayedDate, TimeUnit.DAY, 1);
			} 
			
			if (calendarControl.timeRangeSelection == null || (
				calendarControl.timeRangeSelection != null && 
				(calendarControl.timeRangeSelection[0] > e || 
					calendarControl.renderData.startDisplayedDate > calendarControl.timeRangeSelection[1]))) {             
				
				// create an event at the fist displayed date, at 8:00 am
				var startTime:Date = calendarControl.renderData.startDisplayedDate;
				startTime.hours = 8;
				
				// that lasts 1 hour
				var endTime:Date = calendarControl.calendar.dateAddByTimeUnit(startTime, TimeUnit.HOUR, 1);
				
				createNewEvent(startTime, endTime);
				
			} else {
				
				createNewEventFromSelection(calendarControl.timeRangeSelection);
				calendarControl.timeRangeSelection = null;          
			}                               
		}
		
		private function eventPanelDeleteHandler(event:Event):void {
			//if this option is available only one event is selected.
			deleteItem(calendarControl.selectedItems);        
		}
		
		/**
		 * This function is called by the calendar to give a color to the 
		 * item renderers.       
		 */  
		private function itemColorFunction(item:Object, selected:Boolean, hovered:Boolean):Object {
			
			var now:Date = new Date();
			var color:uint;
			var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(item);
			
			//if the item is in the past, return gray. 
			if (calItem.endTime < now) {
				color = pastEventsColor;
			} else {
				// use the calendar color.          
				color = calItem.calendar.color;        
			}
			
			// alter the color depending on the renderer state.
			var colorOffset:int = hovered ? (selected ? -20 : 20) : (selected ? -40 : 0);
			color = mx.utils.ColorUtil.adjustBrightness2(color, colorOffset);
			
			return color;
		}
		
		/**
		 * Returns the calendar associated with a data item.
		 */   
		private function calendarFunction(item:Object):Object {                
			for each (var calendar:Object in calendars) {
				if (calendar.identifier == item.calendar) {
					return calendar;            
				}
			}
			return null;
		}
		
		/**
		 * The function returns the color associated with a calendar.
		 */  
		private function calendarColorFunction(calendar:Object):uint {
			return calendar.color;
		}
		
		/**
		 * Applies the values computed during the editing of the data item.
		 *  
		 */  
		private function commitItemFunction(item:Object, propertyNames:Array, newStartTime:Date, newEndTime:Date, newCalendar:Object):void {
			
			if (propertyNames == null || propertyNames.indexOf("startTime") != -1) {
				item.startTime = newStartTime.toString();
			}
			
			if (propertyNames == null || propertyNames.indexOf("endTime") != -1) {
				item.endTime = newEndTime.toString();
			}         
			
			if (propertyNames == null || propertyNames.indexOf("calendar") != -1) {
				item.calendar = newCalendar == null ? null : newCalendar.identifier;
			}    
		}      
		
		protected function calendar1Checkbox_changeHandler(event:Event):void
		{
			_professionalCalendarVisible = event.target.selected;
			updateFilterFunction();        
		}
		
		
		protected function calendar2Checkbox_changeHandler(event:Event):void
		{
			_personalCalendarVisible = event.target.selected;
			updateFilterFunction();
		}
		
		private function updateFilterFunction():void {
			var dpAsCollection:ICollectionView = calendarControl.dataProvider as ICollectionView;
			if (_professionalCalendarVisible && _personalCalendarVisible) {
				dpAsCollection.filterFunction = null;  
			} else {
				dpAsCollection.filterFunction = calendarFilterFunction;
			}
			dpAsCollection.refresh();
		}
		
		private var _personalCalendarVisible:Boolean = true;
		private var _professionalCalendarVisible:Boolean = true;
		
		private function calendarFilterFunction(item:Object):Boolean {          
			return item.calendar == "0" && _professionalCalendarVisible ||
				item.calendar == "1" && _personalCalendarVisible;
		}
		
		/**
		 * Handler called when the item selection has changed.
		 */  
		protected function cal_changeHandler(event:CalendarEvent):void
		{        
			//				eventPropertiesPanel.calendarItem = calendarControl.selectedItem == null ? null : calendarControl.itemToRenderItem(calendarControl.selectedItem);
		}
		
		private var editingValues:Object;
		
		/**
		 * Handler called when the editing gesture of a data item begins.
		 * This function stores the values before any change.
		 */  
		private function cal_itemEditBeginHandler(event:CalendarEditingEvent):void
		{
			
			var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(event.item);
			
			editingValues = {
				oldStartTime: new Date(calItem.startTime.time),
				oldEndTime: new Date(calItem.endTime.time),
				calendar: calItem.calendar
			};
		}
		
		private var editingConfirmationPanel:EditingConfirmationPanel;
		
		/**
		 * Handler called whe the editing gesture has ended.
		 * <p>
		 * The implemented behavior is the following:
		 * <ul>
		 *   <li>If the edited item is an occurrence of a recurring event: display a confirmation dialog to decide whether edit the entire serie or create an exception event,</li>
		 *   <li>Otherwise, let the default event handler apply the changed.</li>
		 * </ul>
		 * </p>
		 */  
		private function cal_itemEditEndHandler(event:CalendarEditingEvent):void
		{
			
			if (event.reason == CalendarEditingEventReason.COMPLETED) {
				
				var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(event.item);
				
				if (!(event.triggerEvent is KeyboardEvent) && 
					(event.item is IRecurrenceInstance || calItem.calendar != editingValues.calendar)) {
					
					// cancel the default handler of this event in the Calendar.
					event.preventDefault();
					
					// suspend the editing as a dialog will be shown.            
					calendarControl.suspendEditing();
					
					// store the needed values to apply the changed when the 
					// choice will be made.
					editingValues.kind = calendarControl.editKind;
					editingValues.item = event.item;
					editingValues.newStartTime = new Date(calItem.startTime.time);
					editingValues.newEndTime = new Date(calItem.endTime.time);
					
					// Show the dialog.
					
					if (event.item is IRecurrenceInstance) {
						
						if (editingConfirmationPanel == null) {
							editingConfirmationPanel = new EditingConfirmationPanel();
							editingConfirmationPanel.addEventListener(CloseEvent.CLOSE, confirmationEditHandler);              
						}
						
						editingConfirmationPanel.reset();
						PopUpManager.addPopUp(editingConfirmationPanel, DisplayObject(FlexGlobals.topLevelApplication), true);            
						PopUpManager.centerPopUp(editingConfirmationPanel);            
						editingConfirmationPanel.okButton.setFocus();
						
					} else {
						
						var label:String = resourceManager.getString("calendarsample", "calendarsample.editing.reassign.dialog.label", 
							[calItem.label, calItem.calendar.label]);
						var title:String = resourceManager.getString("calendarsample", "calendarsample.editing.reassign.dialog.title"); 
						Alert.show(label, title, Alert.YES|Alert.NO, null, itemEditReassignConfirmationHandler, null, Alert.NO, moduleFactory);             
					}
					
				} else {         
					// updates the values in the event properties panel
					// the default handler will be called and will apply the changes. 
					//						eventPropertiesPanel.calendarItem = calItem;
				}
			}
		}
		
		private function itemEditReassignConfirmationHandler(event:CloseEvent):void {
			
			var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(editingValues.item);
			var calendar:Object = calItem.calendar;
			
			if (event.detail == Alert.NO) {
				calendar = editingValues.calendar;
			}
			
			calendarControl.applyItemEditEnd(editingValues.item, editingValues.kind, editingValues.oldStartTime,
				editingValues.newStartTime, editingValues.oldEndTime, editingValues.newEndTime, calendar);
			
			// trigger refresh
			calendarControl.dataProvider.itemUpdated(editingValues.item);
		}
		
		private var recurrenceIdCount:int;
		
		/**
		 * Handler called when the occurrence editing dialog is closed.
		 */ 
		private function confirmationEditHandler(event:CloseEvent):void
		{
			// hide dialog
			PopUpManager.removePopUp(editingConfirmationPanel);
			
			var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(editingValues.item);
			var baseItem:Object = IRecurrenceInstance(editingValues.item).item;
			
			var collection:ICollectionView = calendarControl.dataProvider as ICollectionView;
			
			// cancel button or the window close button was clicked.
			if (event.detail == Alert.CANCEL || event.detail == -1) {
				
				// by default the cancel would have been managed by the calendar
				// so explicitly call a refresh of the item
				calendarControl.dataProvider.itemUpdated(editingValues.item);       
				
			} else {
				
				if (editingConfirmationPanel.editSerie) {                   
					
					// apply changes on the recurring event                                                                                        
					calendarControl.applyItemEditEnd(editingValues.item, editingValues.kind, 
						editingValues.oldStartTime, editingValues.newStartTime,
						editingValues.oldEndTime, editingValues.newEndTime, 
						calItem.calendar);                   
					
				} else {
					
					if (!baseItem.hasOwnProperty("recurrenceId")) {              
						baseItem.recurrenceId = recurrenceIdCount.toString();
						recurrenceIdCount++;
					}
					
					// create an item in the data provider for this particular exception event.
					var newItem:Object = {
						startTime: editingValues.newStartTime.toString(),
							endTime: editingValues.newEndTime.toString(),
							label: calItem.label,
							description: baseItem.description == null ? "" : baseItem.description,
							calendar: calItem.calendar.identifier,
							// exception event has the same id than the recurring event
							recurrenceId: baseItem.recurrenceId,
							// the time of the occurrence to replace by this exception event.
							exdate: editingValues.oldStartTime.toString()
					};
					
					calendarControl.dataProvider.addItem(newItem);
					
					calendarControl.selectedItem = newItem;
					
					// an exception event has been added. We must update the 
					// association recurring event / exception events
					// to take this new exception event into account.   
					calendarControl.recurrenceDescriptor.invalidateExceptionEvents(baseItem);
					
					//						eventPropertiesPanel.calendarItem = calendarControl.itemToRenderItem(newItem);
				}
				
				// update the calendar after the changes.
				calendarControl.dataProvider.itemUpdated(baseItem);          
			}   
		}
		
		private var removeRecurrencePanel:net.prjcanlendar.component.YCNGhiPhep.skin.components.RemoveConfirmationPanel;
		
		/**
		 * Shows a panel to confirm the deletion of the selected event(s). 
		 */  
		private function deleteItem(items:Vector.<Object>):void {
			if (items != null && items.length == 1) {
				
				var theText:String;
				var theTitle:String;
				
				var item:Object = items[0];
				
				if (item is IRecurrenceInstance) {
					
					if (removeRecurrencePanel == null) {
						removeRecurrencePanel = new RemoveConfirmationPanel();
						removeRecurrencePanel.addEventListener(CloseEvent.CLOSE, confirmationRemoveHandler2);              
					}
					
					removeRecurrencePanel.reset()
					
					PopUpManager.addPopUp(removeRecurrencePanel, DisplayObject(FlexGlobals.topLevelApplication), true);            
					PopUpManager.centerPopUp(removeRecurrencePanel);
					
					removeRecurrencePanel.defaultButton = removeRecurrencePanel.okButton;
					removeRecurrencePanel.okButton.setFocus();
					
				} else {
					
					var itemToDelete:CalendarRenderItem = calendarControl.itemToRenderItem(items[0]);
					var s:String = itemToDelete.label;
					if (s == null) {
						s = "";
					}
					theText = resourceManager.getString("calendarsample", "calendarsample.delete.warning", [s]);
					theTitle = resourceManager.getString("calendarsample", "calendarsample.delete.title");          
					
					Alert.show(theText, theTitle, Alert.YES | Alert.NO, null, confirmationRemoveHandler, null, Alert.YES);
					
				}                                         
			} 
		}
		
		private function confirmationRemoveHandler2(event:CloseEvent):void {
			
			PopUpManager.removePopUp(removeRecurrencePanel);
			
			if (event.detail == Alert.CANCEL) {
				
				return;
			}                        
			
			var item:Object = calendarControl.selectedItems[0];
			var baseItem:Object = IRecurrenceInstance(item).item as Object; 
			
			if (removeRecurrencePanel.editSerie) {
				
				// to remove the entire serie, we just have to remove the recurring item
				// of the data provider.
				var index:int = calendarControl.dataProvider.getItemIndex(baseItem);
				if (index != -1) {            
					calendarControl.dataProvider.removeItemAt(index);
				}
				
			} else {
				
				// No need to remove a real item from the data provider
				// we just have to add a exception for this particular date.          
				var calItem:CalendarRenderItem = calendarControl.itemToRenderItem(item);                    
				addExceptionDate(baseItem, calItem.startTime);
				calendarControl.dataProvider.itemUpdated(baseItem);
			}            
			
			//				eventPropertiesPanel.calendarItem = null; 
		}
		
		/**
		 * Deletion confirmation panel close hanlder.
		 */  
		private function confirmationRemoveHandler(event:CloseEvent):void {
			
			if (event.detail == Alert.YES) {
				
				var item:Object = calendarControl.selectedItem;
				
				var index:int = calendarControl.dataProvider.getItemIndex(item);
				if (index != -1) {            
					calendarControl.dataProvider.removeItemAt(index);
				}            
				
				if (item.hasOwnProperty("exdate")) { // is an exception event
					var recItem:Object = findRecurringEvent(item.recurrenceId);
					if (recItem != null) {
						calendarControl.recurrenceDescriptor.invalidateExceptionEvents(recItem);
					}
				}                   
				//					eventPropertiesPanel.calendarItem = null;
			}
		}
		
		/**
		 * Iterates over the model to find the recurring item with the specified id 
		 * which is not itself recurrence exception.
		 */  
		private function findRecurringEvent(recurrenceId:String):Object {        
			var len:int = calendarControl.dataProvider.length;
			for (var i:int=0; i<len; i++) {
				var item:Object = calendarControl.dataProvider.getItemAt(i);
				if (item.hasOwnProperty("recurrenceId") && 
					item.recurrenceId == recurrenceId && 
					!item.hasOwnProperty("exdate")) {
					return item;
				}          
			}
			return null;               
		}  
		
		private function addExceptionDate(item:Object, date:Date):void {
			
			var exdates:String = item.exdates;
			var dates:Array = exdates == "" || exdates == null ? [] : exdates.split(",");      
			dates.push(date.toString());
			
			item.exdates = dates.join(",");        
		}
		
		private function createNewEvent(startTime:Date, endTime:Date, label:String=null, calendar:Object=null):void {
			
			if (label == null) {
				label = resourceManager.getString("calendarsample", "calendarsample.default.summary");
			}
			
			var calendarId:String
			
			/*if (calendar == null) {
			calendarId = calendar1Checkbox.selected ? calendars[0].identifier : calendars[1].identifier;
			} else {*/
			calendarId = calendar.identifier;
			/*}*/
			
			var addedItem:Object = {                                                             
				startTime: startTime.toString(),              
					endTime: endTime.toString(),
					label: label,
					description: "",
					calendar: calendarId
			};
			
			calendarControl.dataProvider.addItem(addedItem); 
			calendarControl.selectedItem = addedItem;
			
		}
		
		private function createNewEventFromSelection(selection:Vector.<Date>, summary:String=null, minimalDuration:Boolean=false):void {                
			
			if (selection != null) {
				var startTime:Date = selection[0] as Date;
				var endTime:Date = selection[1] as Date;
				
				if (minimalDuration) {                                    
					var endTime2:Date = calendarControl.calendar.dateAddByTimeUnit(startTime, TimeUnit.HOUR, 1);
					
					if (endTime < endTime2) {
						endTime = endTime2;
					}
				}
				calendarControl.timeRangeSelection = null;
				createNewEvent(startTime, endTime, summary, calendarControl.timeRangeSelectionCalendar);
			} 
		}
		
		private function cal_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DELETE) {
				deleteItem(calendarControl.selectedItems);
			} else if (event.keyCode == Keyboard.ENTER && 
				calendarControl.timeRangeSelection != null) {
				createNewEventFromSelection(calendarControl.timeRangeSelection);
			} else if (event.keyCode == Keyboard.CONTROL) {
				_ctrl = true;
			}
		}
		
		/*private function calendarColorPicker1_changeHandler(event:ColorPickerEvent):void 
		{
		calendars[0].color = calendarColorPicker1.selectedColor;
		refreshCalendarAfterColorChange();
		}
		
		private function calendarColorPicker2_changeHandler(event:ColorPickerEvent):void
		{
		calendars[1].color = calendarColorPicker2.selectedColor;  
		refreshCalendarAfterColorChange();
		}
		
		
		private function pastEventsColorPicker_changeHandler(event:ColorPickerEvent):void
		{
		pastEventsColor = pastEventsColorPicker.selectedColor;
		refreshCalendarAfterColorChange()
		}*/
		
		private function refreshCalendarAfterColorChange():void {
			// resetting the color forces the refresh of the components.
			calendarControl.dataDescriptor.calendarColorFunction = calendarColorFunction;
			calendarControl.grid.updateAllRenderers();
			calendarControl.subColumnHeader.updateAllRenderers();
		}
		
		protected function cal_timeRangeSelectionChangedHandler(event:CalendarEvent):void
		{
			if (_ctrl) {
				calendarControl.referenceDate = null;
				calendarControl.startDate = calendarControl.calendar.fproject_internal::floor(event.startTime, TimeUnit.DAY, 1);
				var isStartOfDay:Boolean = CalendarUtil.isStartOfDay(event.endTime);
				var end:Date;
				if (isStartOfDay) {
					end = calendarControl.calendar.dateAddByTimeUnit(event.endTime, TimeUnit.DAY, -1)
				} else {
					end = calendarControl.calendar.fproject_internal::floor(event.endTime, TimeUnit.DAY, 1);
				}            
				calendarControl.endDate = end
				calendarControl.timeRangeSelection = null;
			}
		}
		
		/*protected function multiColumnCheckBox_clickHandler(event:MouseEvent):void
		{
		calendarControl.calendars = multiColumnCheckBox.selected ? new ArrayList(calendars) : null;
		}*/
		
		
		protected function helpButton_clickHandler(event:MouseEvent):void
		{
		}
		
		private function helpPanel_closeHandler(event:Event):void {
		}
		
		protected function application_creationCompleteHandler(event:FlexEvent):void
		{
			calendarControl.grid.addEventListener(MouseEvent.DOUBLE_CLICK, grid_doubleClickhandler);        
			calendarControl.columnHeader.addEventListener(MouseEvent.MOUSE_DOWN, columnHeaderRenderer_mouseDownHeader);               
		}
		
		private var saveDateInterval:String;
		
		/**
		 * Handler called when a column header renderer is clicked.
		 */  
		private function columnHeaderRenderer_mouseDownHeader(event:MouseEvent):void {
			if(calendarControl.isAnimationPlaying) {
				return;
			}
			if (calendarControl.renderData.displayMode == CalendarDisplayMode.COLUMNS) {        
				var renderer:CalendarColumnHeaderRendererBase = event.target as CalendarColumnHeaderRendererBase;
				if (renderer != null) {
					// the render data of renderer contains the date represented by the column header.
					var renderData:CalendarRenderData = renderer.data as CalendarRenderData;
					calendarControl.referenceDate = renderData.startDate;          
					
					// test if the calendar is already displaying a day or not 
					if (calendarControl.calendar.getElapsedUnits(calendarControl.renderData.startDate, calendarControl.renderData.endDate, TimeUnit.DAY) > 1) {
						saveDateInterval = calendarControl.renderData.dateInterval;
						calendarControl.dateInterval = DateInterval.DAY;    
					} else {
						calendarControl.dateInterval = saveDateInterval == null ? DateInterval.WEEK : saveDateInterval;
					}                   
				}
			}
		}
		
		/**
		 * Creates a new event when the grid is double clicked.
		 */  
		private function grid_doubleClickhandler(event:MouseEvent):void {
			createNewEventFromSelection(calendarControl.timeRangeSelection);
		}
		
		
		protected function cal_visibleTimeRangeChangedHandler(event:CalendarEvent):void
		{
			if (_dateChooserManager == null) {
				_dateChooserManager = new DateChooserManager(calendarControl, dc, dc2);
			}
			
			var duration:int = calendarControl.calendar.getDays(event.startTime, event.endTime);
			calendarControl.setStyle("showDataGroupDuringScrollAnimation", duration <= 2);
		}
		
		private var _ctrl:Boolean = false;
		
		protected function cal_keyUpHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.CONTROL) {
				_ctrl = false;
			}
		}
		
		/**
		 * Method called when the user uses the mouse wheel and the current display mode is grid.
		 * <p>
		 * The behavior is overridden to always scroll of one week in month date interval. 
		 * </p>
		 */  
		private function gridMouseWheelFunction(delta:Number):void {
			
			var duration:int = calendarControl.calendar.getDays(calendarControl.renderData.startDisplayedDate, calendarControl.renderData.endDisplayedDate) + 1;
			
			if (calendarControl.referenceDate != null && calendarControl.dateInterval == DateInterval.MONTH || duration > 7) {
				var start:Date = calendarControl.calendar.dateAddByTimeUnit(calendarControl.renderData.startDisplayedDate, TimeUnit.WEEK, delta < 0 ? 1 : -1);
				var end:Date = calendarControl.calendar.dateAddByTimeUnit(calendarControl.renderData.endDisplayedDate, TimeUnit.WEEK, delta < 0 ? 1 : -1);
				calendarControl.referenceDate = null;
				calendarControl.startDate = start;
				calendarControl.endDate = end;
			} else {
				delta < 0 ? calendarControl.nextRange() : calendarControl.previousRange();
			}
		}
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="keyDown",handler="cal_keyDownHandler")]
		[EventHandling(event="keyUp",handler="cal_keyUpHandler")]
		[EventHandling(event="timeRangeSelectionChanged",handler="cal_timeRangeSelectionChangedHandler")]
		[EventHandling(event="visibleTimeRangeChanged",handler="cal_visibleTimeRangeChangedHandler")]
		[PropertyBinding(dataProvider="dbAvandPD@")]
		public var calendarControl:Calendar;
		
		[SkinPart(required="true",type="static")]
		public var dc:DateChooser;
		
		[SkinPart(required="true",type="static")]
		public var dc2:DateChooser;
	}
}