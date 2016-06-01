var WantlistDuplicateProtection = React.createClass({
	getInitialState: function() {
		return {
			groupName: "",
			shortName: ""
		}
	},
	handleGroupNameInput: function(event) {
    this.setState({ groupName: event.target.value });
  },
  handleShortNameInput: function(event) {
    this.setState({ shortName: event.target.value });
  },
  addGroup: function() {
	  $.ajax({
			url: "/trades/" + this.props.wantlist.props.trade.id + "/groups",
				dataType: "json",
				cache: false,
				method: "post",
				data: {
					want_group: {
						name: this.state.groupName,
						short_name: this.state.shortName
					}
				},
				success: function(data) {
					console.log("Saved successfully");
					this.setState({ loading: false });
					this.props.wantlist.addGroup(data.item);
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString())
				}.bind(this)
		});
		this.setState({ groupName: "", shortName: "" });
  },
	render: function() {
		var groupList = this.props.groups.map(function(group) {
			return <div>{group.name}</div>
		});
		var groupForm = !this.props.locked ? (
			<span>
				<hr />
				<h5>Create a New Group</h5>
				<label>Full Name</label>
				<input type="text" value={this.state.groupName} onChange={this.handleGroupNameInput} />
				<label>Short Name</label>
				<input type="text" value={this.state.shortName} onChange={this.handleShortNameInput} />
				<p className="help-text">
					This should be a short code that the system can use as a reference. Taking the first couple letters
					from the name of the game, or an acronym usually work well.
				</p>
				<a className="button small" onClick={this.addGroup}>Add Group</a>
			</span>
		) : null;
		return (
			<div className={"callout wantlist-duplicate-protection " + (this.props.visible ? "" : "hidden")}>
				<h4>Duplicate Protection</h4>
				<p>
					Duplicate Protection allows you to divide your wants into subgroups, ensuring that you only receive at max one item
					from each group.
				</p>
				<p>
					<b>My Groups</b>
					{groupList}
				</p>
				{groupForm}
			</div>
		);
	}
});