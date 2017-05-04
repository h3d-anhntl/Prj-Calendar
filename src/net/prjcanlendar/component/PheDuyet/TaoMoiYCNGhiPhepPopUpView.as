package net.prjcanlendar.component.PheDuyet
{	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Alert;
	import spark.components.Button;
	import spark.components.ComboBox;
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
	import net.fproject.utils.DataUtil;
	
	import service.NghiPhepService;
	import service.NhanVienService;
	
	import untils.DataUntils;
	
	[EventHandling(event="initialize",handler="group1_creationCompleteHandler")]
	[EventHandling(event="creationComplete",handler="taomoi_creationCompleteHandler")]
	public class TaoMoiYCNGhiPhepPopUpView extends SkinnableComponent
	{
		public function TaoMoiYCNGhiPhepPopUpView()
		{
			Injector.inject(this);
			super();
		}
		
		public var closeFunction:Function;
		
		[Bindable]
		public var listNV:ArrayCollection = new ArrayCollection;
			
		[Bindable]
		public var ycNghi:Nghiphep;

		public function get nhanvienService():NhanVienService
		{
			return InstanceFactory.getInstance(NhanVienService);
		}
		
		public function get nghiphepService():NghiPhepService
		{
			return InstanceFactory.getInstance(NghiPhepService);
		}
		
		public function taomoi_creationCompleteHandler(event:FlexEvent):void
		{
			ChangeWatcher.watch(DataUntils.nhanviens , 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					listNV = DataUntils.nhanviens;
					if(listNV.length > 0 && cb_listNV && cb_listNV.selectedItem == null)
						cb_listNV.selectedItem = listNV.getItemAt(0);
						
				}
			);
		}
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			DataUntils.nhanviens = nhanvienService.getNhanVien() as ArrayCollection;
			listNV = new ArrayCollection;
			
			if (ycNghi && ycNghi.nhanVien)
				listNV.addItem(ycNghi.nhanVien);
			
			ChangeWatcher.watch(DataUntils.nhanviens , 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					for each (var nv:Nhanvien in DataUntils.nhanviens)
					{
						if (ycNghi && ycNghi.nhanVien && DataUtil.equalsByUid(nv,ycNghi.nhanVien) == false)
							listNV.addItem(nv);
							
					}
				}
			);
			
			
		}
		
		public function bt_luuYC_clickHandler(event:MouseEvent):void
		{
			ycNghi.nhanVien = cb_listNV.selectedItem as Nhanvien;
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
				if (closeFunction)
					closeFunction(ycNghi);
			}
		}
		
		public function bt_chapnhan_clickHandler(event:MouseEvent):void
		{
			ycNghi.nhanVien = cb_listNV.selectedItem as Nhanvien;
			if(ckbox_sang.selected)
				ycNghi.caNghi = "1";
			else if(ckbox_chieu.selected)
				ycNghi.caNghi = "2";
			else if(ckbox_cangay.selected)
				ycNghi.caNghi = "3";
			
			ycNghi.trangThai = "1";
			if(nghiphepService.save(ycNghi)){
				Alert.show("successful");
				PopUpManager.removePopUp(this);
			}
		}
		
		public function txt_close_clickHandler(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="txt_close_clickHandler")]
		public var txt_close:Label;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="listNV@")]
		[PropertyBinding(labelField="'tenVietTat'")]
		[PropertyBinding(selectedItem="ycNghi.nhanVien@")]
		public var cb_listNV:ComboBox;
		
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
		[EventHandling(event="click",handler="bt_luuYC_clickHandler")]
		public var bt_luuYC:Button;
		
		[SkinPart(required="true",type="static")]		
		[EventHandling(event="click",handler="bt_chapnhan_clickHandler")]
		public var bt_chapnhan:Button;
		
		[SkinPart(required="true",type="static")]		
		public var lblHoac:Label;
		
		
		[SkinPart(required="true",type="static")]		
		public var hgroupSubmit:HGroup;
		
		[SkinPart(required="true",type="static")]		
		public var hgroupRadio:VGroup;
	}
}