package service
{
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;

	[RemoteObject( destination="schedule-server", modelClass="model.Lichcongtac", uri="lich-cong-tacs")]
	public class LichCongTacService extends ActiveService
	{
		private static var _serviceLCT:LichCongTacService;
		
		public static function getInstance():LichCongTacService
		{
			if(_serviceLCT == null)
			{
				_serviceLCT = new LichCongTacService;
			}
			return _serviceLCT;
		}
		
		public function getLichCongTac():ActiveDataProvider
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