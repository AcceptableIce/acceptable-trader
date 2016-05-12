var WantlistSummary = React.createClass({
	render: function() {
		var items = this.props.items;
		var trade = this.props.trade;
		var list =  this.props.wants.map(function(want) {
			var itemList = items.map(function(item) {
				if(item.is_group) {
					
				}
				if(!item.is_group && want.want_values.indexOf(item.id) !== -1) {
					return (
						<div className="wantlist-summary-item">
							<a href={"/trades/" + trade.id + "/items/" + item.id} >{item.alt_name ? item.alt_name : item.bgg_item_data.name}</a>
						</div>
					);
				} else if (item.is_group && item.want_links.indexOf(want.id) !== -1) {
					return <div className="wantlist-summary-group">{item.name} (Group)</div>
				} else {
					return null;
				}
			});
			itemList.unshift(<h4>{want.is_group ? want.name + " (Group)" : (want.alt_name ? want.alt_name : want.bgg_item_data.name) }</h4>);
			return itemList;
		});
		console.log(list);
		return (
			<div>{list}</div>
		);
	}
});