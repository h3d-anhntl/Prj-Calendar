package model
{
	import net.fproject.model.AbstractModel;
	
	[RemoteClass(alias="FPhongban")]
	public class Phongban extends AbstractModel
	{
		
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var tenPhongBan:String;
		
		[Bindable]
		public var ngayTao:Date;
		
		[Bindable]
		public var ghiChu:String;
		
		public function Phongban()
		{
			super();
		}
	}
}