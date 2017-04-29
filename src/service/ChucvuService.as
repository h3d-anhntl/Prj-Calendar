package service
{
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;

	[RemoteObject( destination="schedule-server", modelClass="model.Chucvu", uri="chuc-vus")]
	public class ChucvuService extends ActiveService
	{
		private static var _serviceCV:ChucvuService;
		
		public static function getInstance():ChucvuService
		{
			if(_serviceCV == null)
			{
				_serviceCV = new ChucvuService;
			}
			return _serviceCV;
		}
		
		public function getChucVu():ActiveDataProvider
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