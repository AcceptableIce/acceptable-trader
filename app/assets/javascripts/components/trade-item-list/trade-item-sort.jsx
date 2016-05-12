var TradeItemSort = React.createClass({
	getInitialState: function() {
		return {
			selected: this.getOptions()[0],
			order: "asc"
		};
	},
	getOptions: function() {
		return [ "Position", "Name", "Rank", "Rating", "Poster"	];
	},
	selectSort: function(event) {
		var newState = event.currentTarget.attributes["data-selection"].value;
		var newOrder = this.state.order;
		if(newState == this.state.selected) {
			newOrder = newOrder == "asc" ? "desc" : "asc";
		} else {
			newOrder = "asc";
		}
		this.setState({ selected: newState , order: newOrder });
		this.props.onSelection(newState, newOrder);
	},
	render: function() {
		var selected = this.state.selected;
		var order = this.state.order;
		var onClick = this.selectSort;
		var optionList = this.getOptions().map(function(x) {
			var arrow = null;
			if(selected == x) {
				if(order == "asc") {
					arrow = (<span className="arrow up"></span>);
				} else {
					arrow = (<span className="arrow down"></span>	);
				}
			}
			return (<li onClick={onClick} data-selection={x} key={x}><a href="#">{x} {arrow}</a></li>);
		});
		return (
			<nav className="trade-item-list-sort">
				<b>Sort:</b>
			  <ul className="breadcrumbs trade-item-list-sort-options">
			    {optionList}
				</ul>
			</nav>
		);
	}
});