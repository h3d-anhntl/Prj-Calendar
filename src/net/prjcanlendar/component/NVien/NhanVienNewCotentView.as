package net.prjcanlendar.component.NVien
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.controls.MovieClipSWFLoader;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.Nhanvien;
	import model.Phongban;
	
	import net.fproject.di.Injector;
	import net.fproject.di.InstanceFactory;
	
	import service.ChucvuService;
	import service.NhanVienService;
	import service.PhongBanService;
	import service.TinhtranghnService;
	
	import untils.DataUntils;
	
	[EventHandling(event="creationComplete",handler="group1_creationCompleteHandler")]
	public class NhanVienNewCotentView extends SkinnableComponent
	{
		public function NhanVienNewCotentView()
		{
			Injector.inject(this);
		}
		
		[Bindable]
		public var dbPhongban:ArrayCollection;
		
		[Bindable]
		public var pb:Phongban;
		
		[Bindable]
		public var dbChucvu:ArrayCollection;
		
		[Bindable]
		public var dbTTHN:ArrayCollection;
		
		[Bindable]
		public var userDetail:Nhanvien;
		
		public function get phongbanService():PhongBanService
		{
			return InstanceFactory.getInstance(PhongBanService);
		}
		
		public function get chucvuService():ChucvuService
		{
			return InstanceFactory.getInstance(ChucvuService);
		}
		
		public function get tthnService():TinhtranghnService
		{
			return InstanceFactory.getInstance(TinhtranghnService);
		}
		
		public function get nhanvienService():NhanVienService
		{
			return InstanceFactory.getInstance(NhanVienService);
		}
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			userDetail = new Nhanvien;
			mc.addChild(loader);
			fr.addEventListener(Event.SELECT,onselect);
			fr.addEventListener(Event.COMPLETE,oncomplete);
			DataUntils.phongbans = phongbanService.getPhongBan() as ArrayCollection;
			DataUntils.chucvus = chucvuService.getChucVu() as ArrayCollection;
			DataUntils.tthns = tthnService.getTTHN() as ArrayCollection;
			
			ChangeWatcher.watch(DataUntils.phongbans,'paginationResult',
				function(e:PropertyChangeEvent):void
				{
					dbPhongban = DataUntils.phongbans;
				}
				);
			ChangeWatcher.watch(DataUntils.tthns, 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					dbTTHN = DataUntils.tthns;
				}
			);
			
			ChangeWatcher.watch(DataUntils.chucvus, 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					dbChucvu = DataUntils.chucvus;
				}
			);
				
		}
		
		public var loader:Loader = new Loader();
		public var fr:FileReference = new FileReference();
		
		public function bt_import_clickHandler(event:MouseEvent):void
		{
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			fr.browse([fileFilter]);
		}
		
		public function onselect(e:Event):void
		{
			fr.load();
		}
		
		public function oncomplete(e:Event):void
		{
			var byteArray:ByteArray = e.currentTarget["data"];
			loader.loadBytes(byteArray);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,mycomplete);
			
		}
		
		[Bindable]
		public var bitmapData:BitmapData;
		/*	private var smallBitmapData:BitmapData;*/
		public function mycomplete(e:Event):void
		{
			//Resize image
			bitmapData = new BitmapData(loader.width, loader.height);
			var oldHeight:Number = loader.height;
			
			var ratio:Number = loader.height / loader.width;
			loader.width = loader.width > loader.height ? mc.width : mc.width / ratio;
			loader.height = loader.width < loader.height ? mc.height : mc.height * ratio;
			
			/*loader.width *= ratio;
			loader.height *= ratio;*/
			
			var matrix:Matrix = new Matrix();
			matrix.scale(loader.height / oldHeight, loader.height / oldHeight);
			
			bitmapData.draw(loader,matrix, null, null, null, true);
			
			
			loader.x = (mc.width - loader.width) / 2;
			loader.y = (mc.height - loader.height) / 2;
			
			
		}
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="dbPhongban@")]
		[PropertyBinding(labelField="'tenPhongBan'")]
		[PropertyBinding(selectedItem="pb@")]
		public var phongban:ComboBox
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="dbChucvu@")]
		[PropertyBinding(labelField="'tenChucVu'")]
		public var cb_chucdanh:ComboBox
		
		[SkinPart(required="true",type="static")]		
		public var cb_gioitinh:ComboBox
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="dbTTHN@")]
		[PropertyBinding(labelField="'tinhtranghonnhan'")]
		public var cb_tinhtranghn:ComboBox
		
		[SkinPart(required="true",type="static")]
		public var tt_ttghichu:TextArea
		
		[SkinPart(required="true",type="static")]
		public var tt_tkghichu:TextArea
		
		[SkinPart(required="true",type="static")]
		public var df_ngaysinh:DateField
		
		[SkinPart(required="true",type="static")]
		public var txt_hovaten:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_tenviettat:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_email:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_dienthoai:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_cmtnd:TextInput
		
		[SkinPart(required="true",type="static")]	
		public var txt_sotknganhang:TextInput
		
		[SkinPart(required="true",type="static")]	
		public var txt_diachi:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_facebook:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_taikhoan:TextInput
		
		[SkinPart(required="true",type="static")]
		public var txt_matkhau:TextInput
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="bt_import_clickHandler")]
		public var bt_import:Button;
		
		[SkinPart(required="true",type="static")]
		public var mc:MovieClipSWFLoader;
		
		
	}
}