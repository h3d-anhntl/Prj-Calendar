package net.prjcanlendar.component.PheDuyet
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
	import model.YCNghiPhep;
	
	import net.fproject.core.TimeUnit;
	import net.fproject.di.Injector;
	import net.fproject.di.InstanceFactory;
	
	import service.NghiPhepService;
	
	import untils.DataUntils;
	
	[EventHandling(event="initialize",handler="group1_creationCompleteHandler")]
	public class PheDuyetContentView extends SkinnableComponent
	{
		public function PheDuyetContentView()
		{
			Injector.inject(this);
		}
		
		public function get nghiphepService():NghiPhepService
		{
			return InstanceFactory.getInstance(NghiPhepService);
		}
		
		[Bindable]
		public var dbAvandPD:ArrayCollection = new ArrayCollection;
		
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			DataUntils.nghipheps = nghiphepService.getNghiPhep() as ArrayCollection;
			ChangeWatcher.watch(DataUntils.nghipheps , 'paginationResult',
				function (e:PropertyChangeEvent):void
				{
					for each(var np:Nghiphep in DataUntils.nghipheps)
					{
						if(np.trangThai == "0")
							dbAvandPD.addItem(np);
					}
					/*dbAvandPD = DataUntils.nghipheps;*/
				}
			);
			
		}
		
		public function myADGPD_doubleClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var popup:TaoMoiYCNGhiPhepPopUpView = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),TaoMoiYCNGhiPhepPopUpView,true) as TaoMoiYCNGhiPhepPopUpView;
			popup.ycNghi = myADGPD.selectedItem as Nghiphep;
			popup.hgroupSubmit.visible = false;
			popup.hgroupRadio.enabled = false;
			PopUpManager.centerPopUp(popup);
		}
		
		public function myADGPD_clickHandler(event:MouseEvent):void
		{
			if(myADGPD.selectedItem)
			{				
				btAChapNhan.enabled = true;
				btATuChoi.enabled = true;
			}
		}
		
		public function btAChapNhan_clickHandler(event:MouseEvent):void
		{
			if(myADGPD.selectedItem)
			{				
				var np:Nghiphep = myADGPD.selectedItem as Nghiphep;
				np.trangThai = "1";
				np.status = 1;
				if(nghiphepService.save(np))
				{
					dbAvandPD.removeItem(np);
					btAChapNhan.enabled = false;
					btATuChoi.enabled = false;
				}
			}
		}
		
		public function btATuChoi_clickHandler(event:MouseEvent):void
		{
			if(myADGPD.selectedItem)
			{				
				var np:Nghiphep = myADGPD.selectedItem as Nghiphep;
				np.trangThai = "2";
				if(nghiphepService.save(np))
				{
					dbAvandPD.removeItem(np);
					btAChapNhan.enabled = false;
					btATuChoi.enabled = false;
				}
			}
		}
		
		
		public function btATaoMoiYCN_clickHandler(event:MouseEvent):void
		{
			var popup:TaoMoiYCNGhiPhepPopUpView = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),TaoMoiYCNGhiPhepPopUpView,true) as TaoMoiYCNGhiPhepPopUpView;
			popup.ycNghi = new Nghiphep;
			popup.closeFunction = taoMoiYCNghiCloseFunction;
			PopUpManager.centerPopUp(popup);
		}
		
		public function taoMoiYCNghiCloseFunction(yeuCauNghi:Nghiphep):void
		{
			dbAvandPD.addItem(yeuCauNghi);
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
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btATaoMoiYCN_clickHandler")]
		public var btATaoMoiYCN:Button;
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btAChapNhan_clickHandler")]
		public var btAChapNhan:Button;
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btATuChoi_clickHandler")]
		public var btATuChoi:Button;
		
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
		[EventHandling(event="doubleClick",handler="myADGPD_doubleClickHandler")]
		[EventHandling(event="click",handler="myADGPD_clickHandler")]
		[PropertyBinding(dataProvider="dbAvandPD@")]
		public var myADGPD:AdvancedDataGrid;
		
		
	}
}