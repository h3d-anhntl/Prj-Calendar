package net.prjcanlendar.component.NVien
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;
	
	import spark.components.HGroup;
	import spark.components.List;
	
	public class CustomGridLayout extends HGroup
	{
		private var _col:Number = 1;

		public function get col():Number
		{
			return _col;
		}

		public function set col(value:Number):void
		{
			_col = value;
			updateLayout();
		}

		private var _dataProvider:ArrayCollection;

		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ArrayCollection):void
		{
			if (_dataProvider)
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
			_dataProvider = value;
			if (_dataProvider)
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
			updateLayout();
		}
		
		public var itemRenderer:IFactory;
		public var border:String;

		public var list:List;
		public function CustomGridLayout()
		{
			updateLayout();
		}
		
		protected function onDataProviderChange(e:CollectionEvent):void
		{
			updateLayout();
		}
		
		private var columnDic:Dictionary;
		protected function updateLayout():void
		{
			
			this.removeAllElements();
			
			if (isNaN(col) || col < 1)
				return;
			if (dataProvider ==  null || dataProvider.length == 0)
				return;
			
			columnDic = new Dictionary;
			
			for (var i:int = 0; i < dataProvider.length; i +=col)
			{
				for (var j:int = 0; j < col; j++)
				{
					if (i + j >= dataProvider.length)
						return;
					if (i == 0)
					{
						var newColumn:List = new List;
						newColumn.dataProvider = new ArrayCollection;
						columnDic[j] = newColumn;
						newColumn.percentHeight = 100;
						newColumn.percentWidth = 100 / col;
						newColumn.itemRenderer = itemRenderer;
						newColumn.setStyle("borderVisible",border);
						
						this.addElement(newColumn);
					}
					var item:Object = dataProvider.getItemAt(i+j);
					List(columnDic[j]).dataProvider.addItem(item);
				}
			}
		}
	}
}