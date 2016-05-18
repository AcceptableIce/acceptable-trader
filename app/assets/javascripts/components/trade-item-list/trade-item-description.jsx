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
				if(linkedItem) {
					linkedItemBody = (
						<span>
							<a href={"http://www.boardgamegeek.com/" + linkedItem.type + "/" + linkedItem.id} target="_blank">
								{linkedItem.name} 
								{linkedItem.year_published > 0 ? " (" + linkedItem.year_published + ")" : null}
							
							</a>
							{linkedItem.statistics && linkedItem.statistics.ranks && linkedItem.statistics.ranks.length > 0 ? 
								<span className="linked-item-data">Rank: {linkedItem.statistics.ranks[0].value}</span> : null}
							{linkedItem.statistics && linkedItem.statistics.average > 0 ? 
								<span className="linked-item-data">Rating: {Number(linkedItem.statistics.average).toFixed(2)}</span> : null}
						</span>
					);
				} else {
					linkedItemBody = "Linked item not found. (ID: " + matches[2] + ")";
				}
				descriptionComponents.push(<div key={matches[2]} className="linked-item sweetener">{linkedItemBody}</div>);
			} else {
				descriptionComponents.push(parts[index]);
			}
		}
		console.log(descriptionComponents);
		return descriptionComponents;
	},
	render: function() {
		return (
			<span>{this.state.description}</span>
		);
	}
});