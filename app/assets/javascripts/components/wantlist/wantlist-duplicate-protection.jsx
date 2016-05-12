var WantlistDuplicateProtection = React.createClass({
	getInitialState: function() {
		return {
			groupName: ""
		}
	},
	handleGroupInput: function(event) {
    this.setState({ groupName: event.target.value });
  },
  addGroup: function() {
	  $.ajax({
			url: "/trades/" + this.props.wantlist.props.trade.id + "/groups",
				dataType: "json",
				cache: false,
				method: "post",
				data: {
					want_group: {
						name: this.state.groupName
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
		this.setState({ groupName: "" });
  },
	render: function() {
		var groupList = this.props.groups.map(function(group) {
			return <div>{group.name}</div>
		});
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
				<hr />
				<h5>Create a New Group</h5>
				<input type="text" value={this.state.groupName} onChange={this.handleGroupInput} />
				<a className="button small" onClick={this.addGroup}>Add Group</a>
			</div>
		);
	}
});