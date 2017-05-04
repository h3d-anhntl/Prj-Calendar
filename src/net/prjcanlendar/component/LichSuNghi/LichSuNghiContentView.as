package net.prjcanlendar.component.LichSuNghi
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.Nghiphep;
	import model.Nhanvien;
	
	import net.fproject.core.TimeUnit;
	import net.fproject.di.Injector;
	import net.fproject.di.InstanceFactory;
	
	import service.NghiPhepService;
	import service.NhanVienService;
	
	import untils.DataUntils;

	[EventHandling(event="initialize",handler="module_creationCompleteHandler")]
	public class LichSuNghiContentView extends SkinnableComponent
	{
		public function LichSuNghiContentView()
		{
			Injector.inject(this);
			super();
		}
		
		[Bindable]
		public var dbAvand:ArrayCollection = new ArrayCollection;
		
		[Bindable]
		public var nhanVien:Nhanvien = new Nhanvien;
		
		public function get nhanvienService():NhanVienService
		{
			return InstanceFactory.getInstance(NhanVienService);
		}
		
		public function get nghiphepService():NghiPhepService
		{
			return InstanceFactory.getInstance(NghiPhepService);
		}
		
		public function module_creationCompleteHandler(event:FlexEvent):void
		{			
			DataUntils.nghipheps = nghiphepService.getNghiPhep() as ArrayCollection;
			ChangeWatcher.watch(DataUntils.nghipheps , 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					for each(var np:Nghiphep in DataUntils.nghipheps)
					{
						if(np.trangThai == "1" && np.nhanVien.email == "anhntl@projectkit.net" && np.status == 1)
						{							
							dbAvand.addItem(np);
							nhanVien = np.nhanVien;
						}
					}
				}
			);
			
		}
		
		public function myADGPD_doubleClickHandler(event:MouseEvent):void
		{
			var popup:TaoMoiYCNghiPhepCNPopup = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),TaoMoiYCNghiPhepCNPopup,true) as TaoMoiYCNghiPhepCNPopup;
			popup.ycNghi = myADG.selectedItem as Nghiphep;
			popup.btGui.visible = false;
			popup.lblHoac.visible = false;
			popup.hgroupRadio.enabled = false;
			PopUpManager.centerPopUp(popup);
		}
		
		public function btTaoMoiYCN_clickHandler(event:MouseEvent):void
		{
			var popup:TaoMoiYCNghiPhepCNPopup = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),TaoMoiYCNghiPhepCNPopup,true) as TaoMoiYCNghiPhepCNPopup;
			popup.ycNghi = new Nghiphep;
			popup.nv = nhanVien;
			PopUpManager.centerPopUp(popup);
		}
		
		public function soNgayLabelFunction(item:Object, column:AdvancedDataGridColumn):String
		{
			var nghiPhep:Nghiphep;
			nghiPhep = item as Nghiphep;
			return (nghiPhep && nghiPhep.toiNgay && nghiPhep.tuNgay) ? 
				String((nghiPhep.toiNgay.time  - nghiPhep.tuNgay.time) / TimeUnit.DAY.milliseconds + 1): "0";
		}
		
		public function tuNgayLabelFunction(item:Object, column:AdvancedDataGridColumn):String
		{
			var nghiPhep:Nghiphep;
			nghiPhep = item as Nghiphep;
			return nghiPhep && nghiPhep.tuNgay ?
				nghiPhep.tuNgay.getDate() + " - " + int(nghiPhep.tuNgay.getMonth() + 1) + " - " + nghiPhep.tuNgay.getFullYear(): "";
		}
		
		public function toiNgayLabelFunction(item:Object, column:AdvancedDataGridColumn):String
		{
			var nghiPhep:Nghiphep;
			nghiPhep = item as Nghiphep;
			return nghiPhep && nghiPhep.toiNgay ?
				nghiPhep.toiNgay.getDate() + " - " + int(nghiPhep.toiNgay.getMonth() + 1) + " - " + nghiPhep.toiNgay.getFullYear(): "";
		}
		
		public function myADGPD_clickHandler(event:MouseEvent):void
		{
			if(myADG.selectedItem)
			{				
				btXoaYcN.enabled = true;
			}
		}
		
		public function btXoaYcN_clickHandler(event:MouseEvent):void
		{
			if(myADG.selectedItem)
			{				
				var nghiPhep:Nghiphep = myADG.selectedItem as Nghiphep;
				nghiPhep.status = 0;
				if(nghiphepService.save(nghiPhep))
					dbAvand.removeItem(nghiPhep);
			}
		}
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btTaoMoiYCN_clickHandler")]
		public var btTaoMoiYCN:Button;
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btXoaYcN_clickHandler")]
		public var btXoaYcN:Button;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(labelFunction="tuNgayLabelFunction")]
		public var tuNgay:AdvancedDataGridColumn;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(labelFunction="toiNgayLabelFunction")]
		public var toiNgay:AdvancedDataGridColumn;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(labelFunction="soNgayLabelFunction")]
		public var soNgay:AdvancedDataGridColumn;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="dbAvand@")]
		[EventHandling(event="doubleClick",handler="myADGPD_doubleClickHandler")]
		[EventHandling(event="click",handler="myADGPD_clickHandler")]
		public var myADG:AdvancedDataGrid;
	}
}