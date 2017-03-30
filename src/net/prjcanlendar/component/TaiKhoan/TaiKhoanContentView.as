package net.prjcanlendar.component.TaiKhoan
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
	
	import model.TaiKhoan;
	
	import net.fproject.di.Injector;
	import net.prjcanlendar.component.form.FormTaoTaiKhoanPopup;

	public class TaiKhoanContentView extends SkinnableComponent
	{
		public function TaiKhoanContentView()
		{
			Injector.inject(this);
		}
		
		[Bindable]
		public var dbTaikhoan:ArrayCollection = new ArrayCollection([
			new TaiKhoan("Nguyễn Văn Thanh","thanhnv","a12345","user","thanhnv@gmail.com"),
			new TaiKhoan("Nguyễn Thị Hương","huongnt","a12345","user","huongnt@gmail.com"),
			new TaiKhoan("Phùng Văn Hà","hapv","a12345","user","hapv@gmail.com"),
			new TaiKhoan("Đỗ Văn Tú","tudv","a12345","user","tudvv@gmail.com"),
			new TaiKhoan("Nguyễn Vân Anh","anhnv","a12345","user","anhnv@gmail.com")
		]);
		
		public function btTaoMoiTK_clickHandler(event:MouseEvent):void
		{
			var popup:IFlexDisplayObject = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication),FormTaoTaiKhoanPopup,true);
			PopUpManager.centerPopUp(popup);
		}
		
		[SkinPart(required="true")]
		[EventHandling(event="click",handler="btTaoMoiTK_clickHandler")]
		public var btTaoMoiTK:Button;
		
		[SkinPart(required="true")]
		public var btXoaTK:Button;
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(dataProvider="dbTaikhoan@")]
		public var myADGTK:AdvancedDataGrid;
	}
}