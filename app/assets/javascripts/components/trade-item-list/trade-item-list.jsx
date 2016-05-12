var TradeItemList = React.createClass({
		getInitialState: function() {
			return {
				items: [],
				user_items: [],
				sort: "name",
				sort_direction: "asc",
				status: "loading",
				error: null
			}
		},
		fetchItems: function() {
			var filter_string = this.props.filter ? "&filter=" + this.props.filter : "";
			$.ajax({
				url: "/trades/" + this.props.trade.id + "/retrieve_items?user=" + this.props.user_id + filter_string,
				dataType: "json",
				cache: false,
				success: function(data) {
					this.setState({ items: data, status: "loaded" });
					this.setUserItems();
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString())
					this.setState({ status: "error", error: error.toString() })
				}.bind(this)
			});
		},
		setUserItems: function() {
			var current_user_id = this.props.user_id;
			this.setState({ user_items: this.state.items.filter(function(x) { return x.user_id == current_user_id }) });
		},
		onSort: function(selection, order) {
			var selectionMethods =  {
				"Position": function(x) { return x.position; },
				"Name": function(x) { return x.alt_name ? x.alt_name : x.bgg_item_data.name; },
				"Rank": function(x) { 
					return x.bgg_item_data && x.bgg_item_data.statistics.rank.value != 0 ? x.bgg_item_data.statistics.rank.value : Number.MAX_VALUE;
				},
				"Rating": function(x) {
					return x.bgg_item_data && x.bgg_item_data.statistics.average != 0 ? x.bgg_item_data.statistics.average : Number.MAX_VALUE;
				},
				"Poster": function(x) {
					return x.bgg_user_data.name;
				}
			}
			
			var selectionMethod = selectionMethods[selection];
			var items = this.state.items;
			items.sort(function(x, y) {
				if(order == "asc") {
					return selectionMethod(x) < selectionMethod(y);
				} else {
					return selectionMethod(x) > selectionMethod(y);
				}
			});
			this.setState({ items: items });
		},
		componentDidMount: function() {
			this.fetchItems();
		},
		render: function() {
			var self_reference = this;
			var trade_items = this.state.items.map(function(item) {
				return (
					<TradeItem data={item} key={item.position} list={self_reference}></TradeItem>
				);
			});
			if(this.state.status == "loaded") {
				return(
					<div class="trade-item-list">
						<TradeItemSort onSelection={this.onSort} />
						<div className="trade-item-list-items">
							{trade_items}
						</div>
					</div>
				);
			} else if(this.state.status == "loading") {
				return (<span>Loading...</span>);
			} else if(this.state.status == "error") {
				return (<span>An error occured: {this.state.error}</span>);
			}
		}
});