package event
{
	import flash.events.Event;

	public class StatesEvents extends Event
	{
		private var _idBt:String;

		public function get idBt():String
		{
			return _idBt;
		}

		public function StatesEvents( type:String, idBt:String)
		{
			super(type, true);
			this._idBt = idBt;
		}
		
		override public function clone():Event
		{
			return new StatesEvents(this.type,this.idBt);
		}
		
	}
}