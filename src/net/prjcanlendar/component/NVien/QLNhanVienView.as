package net.prjcanlendar.component.NVien
{
	import spark.components.supportClasses.SkinnableComponent;
	
	import net.fproject.di.Injector;
	
	public class QLNhanVienView extends SkinnableComponent
	{
		public function QLNhanVienView()
		{
			Injector.inject(this);
			super();
		}
		
		[SkinPart(required="true",type="static")]
		/*[PropertyBinding(itemRenderer="nhanVienAvatar")]
		[PropertyBinding(dataProvider="listNV1@")]*/
		public var nhanvienbt:NhanVienView;
		
		[SkinPart(required="true",type="static")]
		/*[PropertyBinding(itemRenderer="nhanVienAvatar")]
		[PropertyBinding(dataProvider="listNV1@")]*/
		public var nhanviennewbt:NhanVienNewView;
	}
}