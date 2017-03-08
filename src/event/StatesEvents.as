package event
{
	import flash.events.Event;

	public class StatesEvents extends Event
	{
		public var idBt:String;
		public function StatesEvents( type:String, idBt:String)
		{
			super(type, true);
			this.idBt = idBt;
		}
	}
}