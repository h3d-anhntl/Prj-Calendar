package model
{
	public class TaiKhoan
	{
		public var id:String;
		public var taikhoan:String;
		public var matkhau:String;
		public var nhanvienid:String;
		public var phanquyen:String;
		public var ngaytao:Date;
		public var ghichu:String;
		public function TaiKhoan(id:String, taikhoan:String, matkhau:String, phanquyen:String, nhanvienid:String)
		{
			this.id = id;
			this.taikhoan = taikhoan;
			this.matkhau = matkhau;
			this.phanquyen = phanquyen;
			this.nhanvienid = nhanvienid;
		}
	}
}