package model
{
	public class YCNghiPhep
	{
		[Bindable]
		public var id:String;
		
		[Bindable]
		public var nhanvienid:String;
		
		[Bindable]
		public var lydo:String;
		
		[Bindable]
		public var loainghiid:String;
		
		[Bindable]
		public var tungay:String;
		
		[Bindable]
		public var soNgay:String;
		
		[Bindable]
		public var toingay:String;
		
		[Bindable]
		public var canghi:String;
		
		[Bindable]
		public var trangthai:String;
		
		[Bindable]
		public var ngaytao:Date;
		
		public function YCNghiPhep(nhanvienid:String, lydo:String, tungay:String, 
								   toingay:String, trangthai:String, soNgay:String)
		{
			this.nhanvienid = nhanvienid;
			this.lydo = lydo;
			this.tungay = tungay;
			this.toingay = toingay;
			this.trangthai = trangthai;
			this.soNgay = soNgay;
		}
	}
}