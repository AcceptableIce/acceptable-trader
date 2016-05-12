var WantlistRow = React.createClass({
	handleClick: function(index) {
		this.props.toggle(this.props.index, index);
	},
	render: function() {
		var selectionRow = this.props.selectionRow;
		var handleClick = this.handleClick
		var itemBoxes = this.props.items.map(function(x, index) {
			return (
				<td key={index} onClick={function() { handleClick(index) } }>{selectionRow[index] ? <i className="fi-check"></i> : null}</td>
			);
		});
		return (
			<tr>
				<td className="wantlist-row-name">
					<a href={"/trades/" + this.props.trade.id + "/items/" + this.props.data.item_id}>
						{this.props.data.alt_name ? this.props.data.alt_name : this.props.data.bgg_item_data.name }
					</a>
					<a className="button tiny alert wantlist-row-remove" onClick={this.props.removeRow}>Remove</a>
				</td>
				{itemBoxes}
			</tr>
		);
	}
});