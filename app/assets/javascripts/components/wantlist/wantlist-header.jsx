var WantlistHeader = React.createClass({
	render: function() {
		return (
			<th><div><span>{this.props.item.alt_name ? this.props.item.alt_name : this.props.item.bgg_item_data.name}</span></div></th>
		);
	}
});