var TradeItemList = React.createClass({
		getInitialState: function() {
			return {
				items: [],
				user_items: [],
				sort: "name",
				sort_direction: "asc",
				newFilter: false,
				status: "loading",
				error: null,
				missingItems: 0,
				missingItemsThatBelongToMe: 0,
				newItems: 0
			}
		},
		fetchItems: function() {
			var userId = this.props.user_id;
			var filter_string = this.props.filter ? "&filter=" + this.props.filter : "";
			$.ajax({
				url: "/trades/" + this.props.trade.id + "/retrieve_items?user=" + this.props.user_id + filter_string,
				dataType: "json",
				cache: false,
				success: function(data) {
					var missingItems = 0;
					var missingItemsThatBelongToMe = 0;
					var newItems = 0;
					
					for(var i = 0; i < data.length; i++) {
						var item = data[i];
						
						if(item.bgg_item_data == null && item.bgg_item_id != -1) {
							missingItems += 1;
							data.splice(i, 1);
							i -= 1;
							
							if(item.user_id == userId) {
								missingItemsThatBelongToMe += 1;
							}
						}
						if(item.seen == false) {
							newItems += 1;
						}
					}
					data.forEach(function(item) { item.show = true; });
					this.setState({ items: data, status: "loaded", missingItems: missingItems, missingItemsThatBelongToMe: missingItemsThatBelongToMe, newItems: newItems });
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
		filterNew: function(newFilterOn) {
			var newItems = this.state.items.map(function(item) {
				item.show = !newFilterOn || !item.seen;
				return item;
			});
			this.setState({ items: newItems });
		},
		toggleNewFilter: function() {
			var filterState = !this.state.newFilter;
			this.setState({ newFilter: filterState });
			this.filterNew(filterState);
		},
		componentDidMount: function() {
			this.fetchItems();
		},
		render: function() {
			var self_reference = this;
			var trade_items = this.state.items.map(function(item) {
					return item && item.show ? (<TradeItem data={item} key={item.position} list={self_reference} />) : false;
			});
			
			if(this.state.status == "loaded") {
				return(
					<div class="trade-item-list">
						{ this.state.missingItems > 0 ? this.state.missingItems + " item(s) are still being processed.&nbsp;" : null}
						{ this.state.missingItemsThatBelongToMe > 0 ? "Of those, " + this.state.missingItemsThatBelongToMe + " belong to you." : null }
						<TradeItemSort onSelection={this.onSort} />
						{ this.state.newItems > 0 ? 
							<div className="callout warning">
								<span>{this.state.newItems == 1 ? "There is 1 new item." : "There are " + this.state.newItems + " new items." }</span>
								<a className="button small new-filter-toggle" onClick={this.toggleNewFilter}>{this.state.newFilter ? "Show all" : "Show only new"}</a>
							</div>
							: null
						}
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