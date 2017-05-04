package net.prjcanlendar.component.LichSuNghi
{
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Alert;
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.RadioButton;
	import spark.components.TextArea;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.Nghiphep;
	import model.Nhanvien;
	
	import net.fproject.di.Injector;
	import net.fproject.di.InstanceFactory;
	
	import service.NghiPhepService;
	import service.NhanVienService;
	
	public class TaoMoiYCNghiPhepCNPopup extends SkinnableComponent
	{
		public function TaoMoiYCNghiPhepCNPopup()
		{
			Injector.inject(this);
			super();
		}
		
		[Bindable]
		public var ycNghi:Nghiphep;
		
		[Bindable]
		public var nv:Nhanvien;
		
		public function btHuy_clickHandler(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function get nhanvienService():NhanVienService
		{
			return InstanceFactory.getInstance(NhanVienService);
		}
		
		public function get nghiphepService():NghiPhepService
		{
			return InstanceFactory.getInstance(NghiPhepService);
		}
		
		public function btGui_clickHandler(event:MouseEvent):void
		{
			/*var nv:Nhanvien = new Nhanvien;
			ChangeWatcher.watch(DataUntils.nhanviens , 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					for each (var nv:Nhanvien in DataUntils.nhanviens)
					{
						if (nv.email == "anhntl@projectkit.net")
							ycNghi.nhanVien = nv;
						
					}
				}
			);*/
			ycNghi.nhanVien = nv;
			if(ckbox_sang.selected)
				ycNghi.caNghi = "1";
			else if(ckbox_chieu.selected)
				ycNghi.caNghi = "2";
			else if(ckbox_cangay.selected)
				ycNghi.caNghi = "3";
			
			ycNghi.trangThai = "0";
			if(nghiphepService.save(ycNghi)){
				Alert.show("successful");
				PopUpManager.removePopUp(this);
			}
		}
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(selectedDate="ycNghi.tuNgay@")]
		public var df_tungay:DateField;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(selectedDate="ycNghi.toiNgay@")]
		public var df_toingay:DateField;
		
		[SkinPart(required="true",type="static")]
		public var ckbox_sang:RadioButton;
		
		[SkinPart(required="true",type="static")]
		public var ckbox_chieu:RadioButton;
		
		[SkinPart(required="true",type="static")]
		public var ckbox_cangay:RadioButton;
		
		[SkinPart(required="true",type="static")]		
		[PropertyBinding(text="ycNghi.lydo")]
		public var txtar_lydo:TextArea;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="btGui_clickHandler")]
		public var btGui:Button;
		
		[SkinPart(required="true",type="static")]		
		[EventHandling(event="click",handler="btHuy_clickHandler")]
		public var btHuy:Button;
		
		[SkinPart(required="true",type="static")]		
		public var lblHoac:Label;
		
		[SkinPart(required="true",type="static")]		
		public var hgroupRadio:VGroup;
	}
}