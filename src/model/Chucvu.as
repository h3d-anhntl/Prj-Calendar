package model
{
	import net.fproject.model.AbstractModel;

	[RemoteClass(alias="FChucvu")]
	public class Chucvu extends AbstractModel
	{
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var tenChucVu:String;
		
		[Bindable]
		public var ngayTao:String;
		
		[Bindable]
		public var ghiChu:String;
		
		public function Chucvu()
		{
		}
	}
}