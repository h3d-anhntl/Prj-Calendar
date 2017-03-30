package net.prjcanlendar.component.PheDuyet
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.YCNghiPhep;
	
	import net.fproject.di.Injector;
	import net.prjcanlendar.component.form.FormPheDuyetPopup;
	import net.prjcanlendar.component.form.FormYCNghiPhepAdmin;

	public class PheDuyetContentView extends SkinnableComponent
	{
		public function PheDuyetContentView()
		{
			Injector.inject(this);
		}
		
		[Bindable]
		public var dbAvandPD:ArrayCollection = new ArrayCollection([new model.YCNghiPhep("Nghỉ phép", "Nguyễn Văn An", "Nghỉ ốm",
			'03-08-2017', '03-09-2017',"Chưa được chấp nhận"),
			new model.YCNghiPhep("Nghỉ phép", "Chu Văn Minh", "Nghỉ ốm",
				'03-08-2017', '03-09-2017',"Chưa được chấp nhận"),
			new model.YCNghiPhep("Nghỉ phép bù", "Đinh Thị Hương", "Nghỉ ốm",
				'03-08-2017', '03-09-2017',"Chưa được chấp nhận"),
			new model.YCNghiPhep("Nghỉ phép", "Nguyễn Văn An", "Nghỉ ốm",
				'03-08-2017', '03-09-2017',"Chưa được chấp nhận")]);
		
		public function myADGPD_clickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var popup:IFlexDisplayObject = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),FormPheDuyetPopup,true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function btATaoMoiYCN_clickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var popup:IFlexDisplayObject = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),FormYCNghiPhepAdmin,true);
			PopUpManager.centerPopUp(popup);
		}
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btATaoMoiYCN_clickHandler")]
		public var btATaoMoiYCN:Button;
		
		[SkinPart(required="true")]
		public var btAChapNhan:Button;
		
		[SkinPart(required="true")]
		public var btATuChoi:Button;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="myADGPD_clickHandler")]
		[PropertyBinding(dataProvider="dbAvandPD@")]
		public var myADGPD:AdvancedDataGrid;
		
		
	}
}