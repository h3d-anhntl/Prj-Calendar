package net.prjcanlendar.component.NVien
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;
	
	import spark.components.HGroup;
	import spark.components.List;
	import spark.events.IndexChangeEvent;
	
	public class CustomGridLayout extends HGroup
	{
		private var _selectedItem:Object;

		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			if (value != _selectedItem)
			{
				_selectedItem = value;
				if (dataProvider)
					selectedIndex = dataProvider.getItemIndex(value);
			}
			
		}

		private var _selectedIndex:int = -1;

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (value != _selectedIndex)
			{
				_selectedIndex = value;
				if (dataProvider)
					selectedItem = dataProvider.getItemAt(_selectedIndex);
			}
		}

		
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
			removeListEventListener();
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
			addListEventListener();
		}
		
		protected function removeListEventListener():void
		{
			if (columnDic == null)
				return;
			var index:int = 0;
			var list:List;
			for (index = 0; index < col; index ++)
			{
				if (columnDic[index] === undefined)
					continue;
				list = columnDic[index] as List;
				list.removeEventListener('click',onListClick);
				list.removeEventListener('change',onListChange);
				
			}
		}
		
		protected function removeOtherSelected(currentList:List):void
		{
			if (columnDic == null)
				return;
			var index:int = 0;
			var list:List;
			for (index = 0; index < col; index ++)
			{
				if (columnDic[index] === undefined)
					continue;
				list = columnDic[index] as List;
				if (list !== currentList){
					list.selectedIndex = -1;
					list.selectedItems = null;
				}
					
			}
		}
		
		protected function addListEventListener():void
		{
			var index:int = 0;
			var list:List;
			for (index = 0; index < col; index ++)
			{
				list = columnDic[index] as List;
				list.addEventListener('click',onListClick);
				list.addEventListener('change',onListChange);
			}
		}
		
		protected function onListChange(event:IndexChangeEvent):void
		{
			var list:List = event.currentTarget as List;
			removeOtherSelected(list);

			if(event.oldIndex)
				return;
			var oldItem:Object = list.dataProvider.getItemAt(event.oldIndex);
			var newItem:Object = list.dataProvider.getItemAt(event.newIndex);
			var oldIndex:int = dataProvider.getItemIndex(oldItem);
			var newIndex:int = dataProvider.getItemIndex(newItem);
			selectedIndex = newIndex;
			var event:IndexChangeEvent = new IndexChangeEvent(event.type,event.bubbles,event.cancelable,-1,newIndex);
			dispatchEvent(event);
		}
		
		protected function onListClick(event:MouseEvent):void
		{
			var list:List = event.currentTarget as List;
			selectedIndex = dataProvider ? dataProvider.getItemIndex(list.selectedItem) : -1;
			//selectedItem = list.selectedItem;
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK,event.bubbles, event.cancelable);
			dispatchEvent(event);
		}
	}
}