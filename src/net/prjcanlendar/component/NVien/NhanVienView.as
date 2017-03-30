package net.prjcanlendar.component.NVien
{
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import net.fproject.di.Injector;
	import net.prjcanlendar.component.NVien.skin.NhanVienAvatar;

	[EventHandling(event="creationComplete",handler="group1_creationCompleteHandler")]
	//[Style(name="skin", type="Class", inherit="no", states="nhanVienTable,nhanVienListAvatar")]
	/*[PropertyBinding(currentState="nhanVienListAvatar")]*/
	public class NhanVienView extends SkinnableComponent
	{
		public function NhanVienView()
		{
			Injector.inject(this);
			super();
			var button:Button;
		}
		
		import model.NhanVien;
		
		[Bindable]
		public var nv:model.NhanVien = new model.NhanVien;
		
		[Bindable]
		public var listNV1:ArrayCollection;
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			listNV1 = new ArrayCollection;
			nv.hovaten = "Huong";
			listNV1.addItem(nv);
			listNV1.addItem(nv);
			listNV1.addItem(nv);
			listNV1.addItem(nv);
			listNV1.addItem(nv);
		}
		
		private var _isNhanVienTable:Boolean;
		
		
		
		public function onButtonBarChange(e:IndexChangeEvent):void
		{
			_isNhanVienTable = e.newIndex == 1;
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			var s:String = _isNhanVienTable ? "nhanVienTable" : "nhanVienListAvatar";
			return s;
		}
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="change",handler="onButtonBarChange")]	
		public var nhanVienHeader:NhanVienHeader;
		
		[SkinPart(required="true",type="static")]
		public var nvtable:NhanVienTable;
		
		[Bindable]
		public var nhanVienAvatar:ClassFactory = new ClassFactory(NhanVienAvatar);
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(itemRenderer="nhanVienAvatar")]
		[PropertyBinding(dataProvider="listNV1@")]
		public var listNVA:CustomGridLayout;
	}
}