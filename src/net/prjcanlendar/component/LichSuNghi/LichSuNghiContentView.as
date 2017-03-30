package net.prjcanlendar.component.LichSuNghi
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import model.YCNghiPhep;
	
	import net.fproject.di.Injector;
	import net.prjcanlendar.component.form.FormYCNghiPhep;
	import net.prjcanlendar.component.form.XemYCNghiPopup;

	[EventHandling(event="creationComplete",handler="module_creationCompleteHandler")]
	public class LichSuNghiContentView extends SkinnableComponent
	{
		public function LichSuNghiContentView()
		{
			Injector.inject(this);
			super();
		}
		
		[Bindable]
		public var dbAvand:ArrayCollection;
		
		public function module_creationCompleteHandler(event:FlexEvent):void
		{
			//gc.source = dbAvand;
			dbAvand = new ArrayCollection([new model.YCNghiPhep("Nghỉ phép", "Nguyễn Văn An", "Nghỉ ốm",
				'03-08-2017', '03-09-2017',"Đã được phê duyệt"),
				new model.YCNghiPhep("Nghỉ phép", "Chu Văn Minh", "Nghỉ ốm",
					'03-08-2017', '03-09-2017',"Đã được phê duyệt"),
				new model.YCNghiPhep("Nghỉ phép bù", "Đinh Thị Hương", "Nghỉ ốm",
					'03-08-2017', '03-09-2017',"Đã được phê duyệt"),
				new model.YCNghiPhep("Nghỉ phép", "Nguyễn Văn An", "Nghỉ ốm",
					'03-08-2017', '03-09-2017',"Đã được phê duyệt")]);
		}
		
		public function myADG_clickHandler(event:MouseEvent):void
		{
			var popup:IFlexDisplayObject = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),XemYCNghiPopup,true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function button1_clickHandler(event:MouseEvent):void
		{
			var popup:IFlexDisplayObject = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),FormYCNghiPhep,true);
			PopUpManager.centerPopUp(popup);
		}
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="button1_clickHandler")]
		public var btTaoMoiYCN:Button;
		
		[SkinPart(required="true")]
		public var btXoaYcN:Button;
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="click",handler="myADG_clickHandler")]
		[PropertyBinding(dataProvider="dbAvand@")]
		public var myADG:AdvancedDataGrid;
	}
}