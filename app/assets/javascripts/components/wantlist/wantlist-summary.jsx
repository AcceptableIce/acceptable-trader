var WantlistSummary = React.createClass({
	render: function() {
		var items = this.props.items;
		var trade = this.props.trade;
		var list =  this.props.wants.map(function(want) {
			var itemList = items.map(function(item) {
				console.log(item.id, want.want_values);
				if(want.want_values.indexOf(item.id) !== -1) {
					return (
						<div className="wantlist-summary-item">
							<a href={"/trades/" + trade.id + "/items/" + item.id} >{item.alt_name ? item.alt_name : item.bgg_item_data.name}</a>
						</div>
					);
				} else {
					return null;
				}
			});
			itemList.unshift(<h4>{want.alt_name ? want.alt_name : want.bgg_item_data.name }</h4>);
			return itemList;
		});
		console.log(list);
		return (
			<div>{list}</div>
		);
	}
});