package service
{
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;
	
	[RemoteObject(destination="schedule-server", modelClass="model.Nhanvien", uri="/nhan-viens")]
	public class NhanVienService extends ActiveService
	{
		private static var _serviceNV:NhanVienService;
		
		public static function getInstance():NhanVienService
		{
			if(_serviceNV == null)
			{
				_serviceNV = new NhanVienService;
			}
			return _serviceNV;
		}
		
		public function getNhanVien():ActiveDataProvider
		{
			var criteria:DbCriteria = new DbCriteria(
				{
					condition: "@findAllCondition"
				}
			);
			return this.createDataProvider(criteria) as ActiveDataProvider;
		}
	}
}