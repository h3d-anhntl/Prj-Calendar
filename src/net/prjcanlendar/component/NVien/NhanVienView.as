package net.prjcanlendar.component.NVien
{
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import model.Nhanvien;
	
	import net.fproject.di.Injector;
	import net.prjcanlendar.component.NVien.skin.NhanVienAvatar;
	import net.prjcanlendar.event.StatesEvents;

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
		
		[Bindable]
		public var nv:model.Nhanvien = new model.Nhanvien;
		
		[Bindable]
		public var listNV1:ArrayCollection;
		
		public function group1_creationCompleteHandler(event:FlexEvent):void
		{
			if(listNVA.selectedItem)
			nv = listNVA.selectedItem as Nhanvien;
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
		
		[Bindable]
		public var selectedNV:Nhanvien = new Nhanvien;
		
		public function listNVA_clickHandler(event:MouseEvent):void
		{
			selectedNV = listNVA.selectedItem as Nhanvien;
			var selectNV:StatesEvents= new StatesEvents("clickBt","selecedNV");
			this.dispatchEvent(selectNV);
		}
		
		[SkinPart(required="true",type="static")]
		[EventHandling(event="change",handler="onButtonBarChange")]	
		public var nhanVienHeader:NhanVienHeader;
		
		[SkinPart(required="true",type="static")]		
		[PropertyBinding(employees="listNV1@")]
		public var nvtable:NhanVienTable;
		
		[Bindable]
		public var nhanVienAvatar:ClassFactory = new ClassFactory(NhanVienAvatar);
		
		[SkinPart(required="true",type="static")]
		[PropertyBinding(itemRenderer="nhanVienAvatar")]
		[PropertyBinding(dataProvider="listNV1@")]
		[EventHandling(event="click",handler="listNVA_clickHandler")]	
		public var listNVA:CustomGridLayout;
	}
}