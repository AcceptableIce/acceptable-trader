var Wantlist = React.createClass({
	getInitialState: function() {
		return {
			grid: true,
			showDuplicateProtection: true,
			groups: this.props.groups,
			showDuplicateProtection: false
		};
	},
	toggleMode: function() {
		this.setState({ grid: !this.state.grid });
	},
	getItems: function() {
		return this.props.items.concat(this.state.groups);
	},
	getWants: function() {
		return this.props.wants.concat(this.state.groups);
	},
	addGroup: function(item) {
		var groups = this.state.groups;
		item.is_group = true;
		groups.push(item);
		this.setState({ groups: groups });
	},
	toggleDuplicateProtection: function() {
		this.setState({ showDuplicateProtection: !this.state.showDuplicateProtection });
	},
	render: function() {
		return (
			<div className="wantlist-container">
				<a className="button small info" onClick={this.toggleMode}>
					{this.state.grid ? "Show Summary" : "Show Grid"}
				</a>
				<a className="button small info" onClick={this.toggleDuplicateProtection}>
					{this.state.showDuplicateProtection ? "Hide" : "Show"} Duplicate Protection
				</a>
				<WantlistDuplicateProtection items={this.props.items} groups={this.state.groups} wantlist={this} visible={this.state.showDuplicateProtection} wants_due={this.props.wants_due}/>
				{this.state.grid ? 
				<WantlistGrid trade={this.props.trade} wants={this.getWants()} items={this.getItems()} wants_due={this.props.wants_due} />
				:
				<WantlistSummary trade={this.props.trade} wants={this.getWants()} items={this.getItems()} />}
			</div>
		)
	}
})