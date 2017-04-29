package service
{		
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;

	[RemoteObject(destination="schedule-server", modelClass="model.Phongban", uri="/phong-bans")]
	public class PhongBanService extends ActiveService
	{
		private static var _servicePB:PhongBanService;
		
		public static function getInstance():PhongBanService
		{
			if(_servicePB == null)
			{
				_servicePB = new PhongBanService;
			}
			return _servicePB;
		}
		
		public function getPhongBan():ActiveDataProvider
		{
			var criteria:DbCriteria = new DbCriteria(
				{
					condition: "@findAllCondition"
				});
			return this.createDataProvider(criteria) as ActiveDataProvider;
		}
	}
}