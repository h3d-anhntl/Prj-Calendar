package service
{
	import net.fproject.active.ActiveDataProvider;
	import net.fproject.active.ActiveService;
	import net.fproject.active.DbCriteria;

	[RemoteObject(destination="schedule-server", modelClass="model.NghiPhep", uri="/nghi-pheps")]
	public class NghiPhepService extends ActiveService
	{
		private static var _serviceNP:NghiPhepService;
		
		public static function getInstance():NghiPhepService
		{
			if(_serviceNP == null)
			{
				_serviceNP = new NghiPhepService;
			}
			return _serviceNP;
		}
		
		public function getNghiPhep():ActiveDataProvider
		{
			var criteria:DbCriteria = new DbCriteria(
				{
					condition: "@findAllCondition"
				});
			return this.createDataProvider(criteria) as ActiveDataProvider;
		}
	}
}