package model
{
	import net.fproject.model.AbstractModel;
	
	[RemoteClass(alias="FNghiphep")]
	public class Nghiphep extends AbstractModel
	{
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var nhanVienId:int;
		
		[Bindable]
		public var lydo:String;
		
		[Bindable]
		public var loaiNghiId:int;
		
		[Bindable]
		public var tuNgay:Date;
		
		[Bindable]
		public var toiNgay:Date;
		
		[Bindable]
		public var caNghi:int;
		
		[Bindable]
		public var trangThai:int;
		
		[Bindable]
		public var ngayTao:Date;
		
		public function Nghiphep()
		{
			super();
		}
	}
}