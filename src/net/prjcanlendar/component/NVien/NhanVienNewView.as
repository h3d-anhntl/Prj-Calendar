package net.prjcanlendar.component.NVien
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.utils.Base64Encoder;
	
	import spark.components.Alert;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.Nhanvien;
	
	import net.fproject.di.Injector;
	import net.fproject.di.InstanceFactory;
	import net.prjcanlendar.event.StatesEvents;
	
	import service.NhanVienService;
	
	import untils.DataUntils;
	
	[EventHandling(event="creationComplete",handler="group1_creationCompleteHandler")]
	public class NhanVienNewView extends SkinnableComponent
	{
		public function NhanVienNewView()
		{
			Injector.inject(this);
		}
		
		public function get nhanvienService():NhanVienService
		{
			return InstanceFactory.getInstance(NhanVienService);
		}
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			addEventListener("clickBt",saveNhanVien_clickHandler);
		}
		
		
		public function saveNhanVien_clickHandler(e:StatesEvents):void
		{
			
			if(e.idBt == "btLuuNV")
			{
				if(nvNew.userDetail.avatar == "" || nvNew.userDetail.avatar == null)
				{
					var jpgencode:JPEGEncoder = new JPEGEncoder(100);
					if(nvNew.bitmapData != null){
						var mybyte:ByteArray = jpgencode.encode(nvNew.bitmapData);
						
						//Encode
						var enc:Base64Encoder = new Base64Encoder();   
						enc.encodeBytes(mybyte);
						
						if(mybyte != null)
							nvNew.userDetail.avatar = enc.drain();
					}
					else{
						nvNew.userDetail.avatar = "";
					}
				}
				
				
				if(nhanvienService.save(nvNew.userDetail)){
					DataUntils.nhanviens = new ArrayCollection;
					DataUntils.nhanviens = nhanvienService.getNhanVien() as ArrayCollection;
					ChangeWatcher.watch(DataUntils.nhanviens, 'paginationResult',
						function (e:PropertyChangeEvent):void
						{
							/*listnv = new ArrayCollection();*/
							/*listnv = DataUntils.nhanviens;*/
							var st:int = 0;
							for each( var i:Nhanvien in DataUntils.nhanviens )
							{
								st += 1;
								i.stt = st;
							}
						}
					);
					Alert.show("Save successful");
				}
			}
		}
		
		[Bindable]
		public var user:Nhanvien;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(userDetail="user@")]
		public var nvNew:NhanVienNewCotentView
		
		[SkinPart(required="true",type="static")]
		public var nvHeader:NhanVienNewHeader
	}
}