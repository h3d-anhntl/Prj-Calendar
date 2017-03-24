///////////////////////////////////////////////////////////////////////////////
//
// Licensed Source Code - Property of ProjectKit
//
// © Copyright ProjectKit 2010-present. All Rights Reserved.
//
///////////////////////////////////////////////////////////////////////////////
package model
{
	import net.fproject.model.AbstractModel;

	[RemoteClass(alias="FCalendarItem")]
	/**
	 * Represents a calendar event model.
	 */
	public class CalendarItem extends AbstractModel
	{
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var calendarId:String;
		
		[Bindable]
		public var userId:String;
		
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var description:String;
		
		[Bindable]
		public var startTime:Date;
		
		[Bindable]
		public var endTime:Date;
		
		[Bindable]
		public var recurring:Boolean;
		
		[Bindable]
		public var allDay:Boolean;
		
		[Bindable]
		public var rrules:String;
		
		[Bindable]
		public var exdates:String;
	}
}