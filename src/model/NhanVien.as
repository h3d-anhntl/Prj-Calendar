package model
{
	
	import net.fproject.model.AbstractModel;

	[RemoteClass(alias="FNhanvien")]
	public class Nhanvien extends AbstractModel
	{
		
		[Bindable]
		public var id:int;
		
		[Bindable]
		public var hoVaTen:String;
		
		[Bindable]
		public var tenVietTat:String;
		
		[Bindable]
		public var avatar:String;
		
		[Bindable]
		public var email:String;
		
		[Bindable]
		public var facebook:String;
		
		[Bindable]
		public var diaChi:String;
		
		[Bindable]
		public var gioiTinh:int;
		
		[Bindable]
		public var soDienThoai:String;
		
		[Bindable]
		public var ngaySinh:Date;
		
		[Bindable]
		public var cmtnd:String;
		
		[Bindable]
		public var sotkNganHang:String;
		
		[Bindable]
		public var ttHonNhan:Tinhtranghonnhan;
		
		private var _ttHonNhanId:String;

		[Bindable]
		public function get ttHonNhanId():String
		{
			return ttHonNhan ? ttHonNhan.id : _ttHonNhanId;
		}

		public function set ttHonNhanId(value:String):void
		{
			_ttHonNhanId = value;
		}

		
		[Bindable]
		public var phongBan:Phongban;
		
		private var _phongBanId:String;

		[Bindable]
		public function get phongBanId():String
		{
			return phongBan ? phongBan.id : _phongBanId;
		}

		public function set phongBanId(value:String):void
		{
			_phongBanId = value;
		}

		
		[Bindable]
		public var chucVu:Chucvu;
		
		private var _chucVuId:String;

		[Bindable]
		public function get chucVuId():String
		{
			return chucVu ? chucVu.id : _chucVuId;
		}

		public function set chucVuId(value:String):void
		{
			_chucVuId = value;
		}

		
		/*[Bindable]
		public var ngayTao:Date;
		
		[Bindable]
		public var ngayCapNhat:Date;*/
		
		[Bindable]
		public var ghiChu:String;
		
		[Bindable]
		public var lichcongtacs:Array;
		
		[Bindable]
		public var nghipheps:Array;
		
		
		[Bindable]
		public var stt:int;
		
		public function Nhanvien()
		{
		}
		
		
		/*public function get deCodeAvatar():Loader
		{
			var loaderDe:Loader = new Loader();
			var base64Dec:Base64Decoder = new Base64Decoder();
			var byteArr:ByteArray = new ByteArray();
			if(avatar != null || avatar != ""){
				
				base64Dec.decode(avatar);
				
				byteArr= base64Dec.toByteArray();
				loaderDe.loadBytes(byteArr);
			}
			return avatar ? loaderDe : null;
		}*/
	}
}