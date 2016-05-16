var TradeItemAdd = React.createClass({
	getInitialState: function() {
		var toggles = {}
		var want_data = this.props.item.state.want_data;
		console.log(want_data);
		var user_items = this.props.item.props.list.state.user_items;
		for(var key in user_items) {
			var item = user_items[key];
			toggles[item.id] = want_data && want_data.indexOf(item.id) !== -1 ? "on" : "off";
		}
		
 		return {
			toggles: toggles
		}
	},
	handleToggle: function(event) {
		var toggles = this.state.toggles;
		var currentValue = toggles[event.target.attributes["data-id"].value];	
		toggles[event.target.attributes["data-id"].value] = currentValue === "on" ? "off" : "on";
		this.setState({ toggles: toggles });
	},
	onConfirm: function(event) {
		var close_action = this.props.item.onShowAddRequest
		var user_items = this.props.item.props.list.state.user_items; 
		var allowed_items = [];
		for(var key in this.state.toggles) {
			if(this.state.toggles[key] === "on") {
				allowed_items.push(Number(key))
			}
		}
		this.props.item.setState({ want_data: allowed_items });
		$.ajax({
			url: "/trades/" + this.props.item.props.list.props.trade.id + "/wants",
			method: "post",
			dataType: "json",
			cache: false,
			data: {
				math_trade_want: {
					math_trade_item_id: this.props.item.props.data.id
				},
				allowed_items: allowed_items
			},
			success: function(data) {
				console.log(data);
				close_action();
			}.bind(this),
			error: function(xhr, status, error) {
				console.error(status, error.toString());
			}.bind(this)
		});
	},
	render: function() {
		var state = this.state;
		var item = this.props.item.props.data;
		var list = this.props.item.props.list;
		var handleToggle = this.handleToggle;
		var background_class = "trade-item-add-foreground " + (this.props.item.getStatus().length > 0 ? this.props.item.getStatus()[0] : "");
		var list_elements = list.state.user_items.map(function(item) {
			return (
				<div className="trade-item-add-option" key={item.id}>
					<input type="checkbox" checked={state.toggles[item.id] === "on"} onChange={handleToggle} data-id={item.id}/> 
					<span className="trade-item-add-option-text">{item.alt_name ? item.alt_name : item.bgg_item_data.name}</span>
				</div>
			);
		});
		return (
			<div className="trade-item-add">
			<div className={background_class}>
				<div className="trade-item-add-name">Add <b>{item.alt_name ? item.alt_name : item.bgg_item_data.name}</b> to your wantlist:</div>
				{list_elements}
				<div className="button small success trade-item-add-confirm" onClick={this.onConfirm}>Add to Wantlist</div>
			</div>
			</div>
		);
	}
});