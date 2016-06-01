var Wantlist = React.createClass({
	getInitialState: function() {
		return {
			grid: true,
			showDuplicateProtection: true,
			groups: this.props.groups,
			showDuplicateProtection: false,
			confirmed: this.props.confirmed
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
		var updated_at = null;
		if(this.props.offers_due) {
			if(this.state.confirmed) {
				updated_at = this.state.confirmed.updated_at;
				if(this.state.confirmed.updated_at != "a few moments ago") {
					updated_at = updated_at.replace("T", " ").split(".")[0];
				}
				updated_at = "Wants submitted " + updated_at + ".";
			} else {
				updated_at = "<b>You have not submitted your wants.</b>"
			}
		}
		return (
			<div className="wantlist-container">
				<p dangerouslySetInnerHTML={ { __html: updated_at ? updated_at : "" } }>
				</p>
				<a className="button small info" onClick={this.toggleMode}>
					{this.state.grid ? "Show Summary" : "Show Grid"}
				</a>
				<a className="button small info" onClick={this.toggleDuplicateProtection}>
					{this.state.showDuplicateProtection ? "Hide" : "Show"} Duplicate Protection
				</a>
				
				<WantlistDuplicateProtection items={this.props.items} groups={this.state.groups} wantlist={this} visible={this.state.showDuplicateProtection} locked={this.props.wants_due || this.state.confirmed}/>
				{this.state.grid ? 
				<WantlistGrid trade={this.props.trade} wants={this.getWants()} items={this.getItems()} wants_due={this.props.wants_due} locked={this.state.confirmed} parent={this} />
				:
				<WantlistSummary trade={this.props.trade} wants={this.getWants()} items={this.getItems()} />}
			</div>
		)
	}
})