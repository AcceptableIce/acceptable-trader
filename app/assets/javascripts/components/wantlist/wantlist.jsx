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
	submitWants: function() {
		$.ajax({
			url: "/trades/" + this.props.trade.id + "/confirm_wants",
				dataType: "json",
				cache: false,
				method: "post",
				data: {},
				success: function(data) {
					console.log("Saved successfully");
					this.setState({ confirmed: { created_at: "a few moments ago" } });
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString());
					this.setState({ confirmed: { created_at: this.state.createdAt + ". (An error occurred while saving.)"} });
				}.bind(this)
		});
	},
	render: function() {
		var created_at = null;
		if(this.state.confirmed) {
			created_at = this.state.confirmed.created_at;
			if(this.state.confirmed.created_at != "a few moments ago") {
				created_at = created_at.replace("T", " ").split(".")[0];
			}
		}
		return (
			<div className="wantlist-container">
				<p>
					{this.state.confirmed ? "Wants last submitted " + created_at + "." : ""}
				</p>
				<a className="button small info" onClick={this.toggleMode}>
					{this.state.grid ? "Show Summary" : "Show Grid"}
				</a>
				<a className="button small info" onClick={this.toggleDuplicateProtection}>
					{this.state.showDuplicateProtection ? "Hide" : "Show"} Duplicate Protection
				</a>
				{
				this.props.offers_due && this.props.status == "active" ? 
				<a className="button small info" onClick={this.submitWants}>
					{this.state.confirmed ? "Resubmit Wantlist" : "Submit Wantlist"}
				</a>
				:
				null
				}
				<WantlistDuplicateProtection items={this.props.items} groups={this.state.groups} wantlist={this} visible={this.state.showDuplicateProtection} wants_due={this.props.wants_due}/>
				{this.state.grid ? 
				<WantlistGrid trade={this.props.trade} wants={this.getWants()} items={this.getItems()} wants_due={this.props.wants_due} />
				:
				<WantlistSummary trade={this.props.trade} wants={this.getWants()} items={this.getItems()} />}
			</div>
		)
	}
})