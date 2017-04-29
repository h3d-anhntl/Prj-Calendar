package model
{
	import net.fproject.model.AbstractModel;
	
	[RemoteClass(alias="FLichcongtac")]
	public class Lichcongtac extends AbstractModel
	{
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var nhanVienId:int;
		
		[Bindable]
		public var lichCongTac:String;
		
		[Bindable]
		public var ngayCapNhat:Date;
		
		[Bindable]
		public var ngayTao:Date;
		
		[Bindable]
		public var ghiChu:String;
		
		public function Lichcongtac()
		{
			super();
		}
	}
}