var TradeItemDescription = React.createClass({
	getInitialState: function() {
		return {
			description: ""
		}
	},
	componentDidMount: function() {
		this.setState({ description: this.parseDescription() });
	},
	parseDescription: function() {
		var linkedItems = this.props.linked_items;
		var itemTagSplitRegex = /(\[item=.*?\])/gi;
		var itemTagRegex = /\[item(=(.*?))?\]/i;
		var parts = this.props.description.split(itemTagSplitRegex);
		var descriptionComponents = [];
		for(var index in parts) {
			var componentForItem = null;
			var matches = parts[index].match(itemTagRegex);
			if(matches) {
				var linkedItem = linkedItems[matches[2]];
				var linkedItemBody = "";
				var linkedItemClass = "";
				if(linkedItem) {
					var rank_data = linkedItem && linkedItem.ranks ? linkedItem.ranks.filter(function(x) { return x.name == "boardgame"; }) : [];
					linkedItemBody = (
						<span>
							<a href={"http://www.boardgamegeek.com/" + linkedItem.item_type + "/" + linkedItem.id} target="_blank">
								{linkedItem.name} 
								{linkedItem.year_published > 0 ? " (" + linkedItem.year_published + ")" : null}
							
							</a>
							{rank_data.length > 0 && rank_data[0].value > 0 ? 
								<span className="linked-item-data">Rank: {rank_data[0].value}</span> : null}
							{linkedItem.average > 0 ? 
								<span className="linked-item-data">Rating: {Number(linkedItem.average).toFixed(2)}</span> : null}
						</span>
					);
					
					if(linkedItem.collection) {
						for(var key in linkedItem.collection) {
							if(linkedItem.collection[key] && linkedItemClass === "") linkedItemClass = key;
						}
					}
				} else {
					linkedItemBody = "Linked item not found. (ID: " + matches[2] + ")";
				}
				
				descriptionComponents.push(<div key={matches[2]} className={"linked-item sweetener " + linkedItemClass}>{linkedItemBody}</div>);
			} else {
				descriptionComponents.push(parts[index]);
			}
		}
		return descriptionComponents;
	},
	render: function() {
		return (
			<span>{this.state.description}</span>
		);
	}
});