package model
{
	import net.fproject.model.AbstractModel;
	
	[RemoteClass(alias="FTinhtranghonnhan")]
	public class Tinhtranghonnhan extends AbstractModel
	{
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var tinhtranghonnhan:String;
		
		[Bindable]
		public var ngayTao:Date;
		
		[Bindable]
		public var ghiChu:String;
		
		public function Tinhtranghonnhan()
		{
			
		}
	}
}