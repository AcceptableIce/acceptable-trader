var WantlistHeader = React.createClass({
	render: function() {
		var altName = this.props.item.alt_name;
		var itemName = this.props.item.is_group ? this.props.item.name : (altName ? altName : this.props.item.bgg_item_data.name);
		return (
			<th className={this.props.item.is_group ? "wantlist-header-group" : ""}>
				<div>
					<span>
						{itemName}					
					</span>
				</div>
			</th>
		);
	}
});