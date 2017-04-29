package service
{
	
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;

	[RemoteObject(destination="schedule-server", modelClass="model.Tinhtranghonnhan", uri="/tinh-trang-hon-nhans")]
	public class TinhtranghnService extends ActiveService
	{
		private static var _serviceTTHN:TinhtranghnService;
		
		public static function getInstance():TinhtranghnService
		{
			if(_serviceTTHN == null)
			{
				_serviceTTHN = new TinhtranghnService;
			}
			return _serviceTTHN;
		}
		
		public function getTTHN():ActiveDataProvider
		{
			var criteria:DbCriteria = new DbCriteria(
				{
					condition: "@findAllCondition"
				});
			return this.createDataProvider(criteria) as ActiveDataProvider;
		}
	}
}