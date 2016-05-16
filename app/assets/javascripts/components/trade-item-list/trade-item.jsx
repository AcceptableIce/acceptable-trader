var TradeItem = React.createClass({
		getInitialState: function() {
			return {
				showAdd: false,
				showQuickAdd: this.props.data.want_data === null,
				want_data: this.props.data.want_data
			};
		},
		getStatusItems: function() {
			var status_items = [];
			var collection_name_map = {
				own: "Owned",
				prev_owned: "Previously Owned",
				for_trade: "For Trade",
				want: "Want in Trade",
				want_to_play: "Want to Play",
				want_to_buy: "Want to Buy",
				wishlist: "Wishlist",
				preordered: "Preordered",
			}
			status_items = this.getStatus().map(function(key) {
				var class_name = "collection-tag " + key;
				return (
					<div className={class_name} key={key}>{collection_name_map[key]}</div>
				);
			});
			
			return status_items;
		},
		getStatus: function() {
			var collection = this.props.data.bgg_item_data && this.props.data.bgg_item_data.collection;
			if(collection != null) {
				var accepted_keys = Object.keys(collection).filter(function(key) { return collection[key] === true });
				return accepted_keys
			} else {
				return [];
			}
		},
		onShowAddRequest: function() {
			this.setState({ showAdd: !this.state.showAdd });
		},
		onQuickAdd: function() {
			this.setState({ showQuickAdd: false });
			$.ajax({
				url: "/trades/" + this.props.list.props.trade.id + "/wants",
				method: "post",
				dataType: "json",
				cache: false,
				data: {
					math_trade_want: {
						math_trade_item_id: this.props.data.id
					}
				},
				success: function(data) {
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString());
				}.bind(this)
			});
		},
		render: function() {
			var background_class = "trade-item " + (this.getStatus().length > 0 ? this.getStatus()[0] : "");
			var item_data = this.props.data.bgg_item_data;
			var user_data = this.props.data.bgg_user_data;
			var user_link = "http://www.boardgamegeek.com/user/" + user_data.name;
			var item_type =  item_data ? {"boardgame": "Board Game", "rpgitem": "RPG Item", "videogame": "Video Game"}[item_data.type] : "";
			var altname = this.props.data.alt_name;
			var item_link = "/trades/" + this.props.list.props.trade.id + "/items/" + this.props.data.id;
			var metadata = item_data ? (
				<div className="trade-item-metadata">
					{item_type} / {item_data.min_players}-{item_data.max_players} players /&nbsp;
					{item_data.playing_time} minutes / <b>Trade</b>, Want, <b>Wish</b>:&nbsp;
					{item_data.statistics.trading},&nbsp;
					{item_data.statistics.wanting},&nbsp;
					{item_data.statistics.wishing}
				</div>
			) : null;
			
			var statistics = item_data ? (
				<span>
					Rank: {item_data.statistics.rank.value == 0 ? "N/A" : item_data.statistics.rank.value}<br/>
					Rating: {item_data.statistics.average == 0 ? "N/A" : Number(item_data.statistics.average).toFixed(2)}<br/>
					Bayes: {item_data.statistics.bayes == 0 ? "N/A" : Number(item_data.statistics.bayes).toFixed(2)}
				</span>
			) : null;
			
			var addButtons = this.props.data.user_id !== this.props.list.props.user_id ? (
				<span>
					<div className="button info small"onClick={this.onShowAddRequest}>
						{this.state.showAdd ? "Close" : (this.state.want_data ? "Add (" + this.state.want_data.length + ")" : "Add") }
					</div>
					{this.state.showQuickAdd ? <div className="button hollow info small" onClick={this.onQuickAdd}>Quick<br/>Add</div> : null}
				</span>
			) : 
			(
				<span>
					<a className="button success small" href={item_link + "/edit"}>Edit</a>
				</span>
			);
			
			return (
				<div className={background_class}>
					<div className="trade-item-options">
						{addButtons}
					</div>
					<div className="trade-item-body">
						<div className="trade-item-title">
							{this.props.data.position}.&nbsp;
							<a href={item_link}>{altname ? altname : (item_data ? item_data.name : "Data missing")}</a> {item_data ? "(" + item_data.year_published + ")" : ""}
							{this.getStatusItems()}
						</div>
						<div className="trade-item-user">
							Posted by <a href={user_link} target="_blank">{user_data.name}</a>
							&nbsp;(Trade Rating: {user_data.trade_rating})
						</div>
						{metadata}
						<div className="trade-item-description">
							<TradeItemDescription description={this.props.data.description} linked_items={this.props.data.linked_items} />
						</div>
					</div>
					<div className="trade-item-rank">
						{statistics}
					</div>
					{this.state.showAdd ? <TradeItemAdd item={this} /> : null }
				</div>
			);
		}
});
