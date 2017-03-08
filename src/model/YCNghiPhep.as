package model
{
	public class YCNghiPhep
	{
		public var id:String;
		public var nhanvienid:String;
		public var lydo:String;
		public var loainghiid:String;
		public var tungay:String;
		public var toingay:String;
		public var canghi:String;
		public var trangthai:String;
		public var ngaytao:Date;
		public function YCNghiPhep(loainghiid:String,nhanvienid:String, lydo:String, tungay:String, 
								   toingay:String, trangthai:String)
		{
			this.loainghiid = loainghiid;
			this.nhanvienid = nhanvienid;
			this.lydo = lydo;
			this.tungay = tungay;
			this.toingay = toingay;
			this.trangthai = trangthai;
		}
	}
}