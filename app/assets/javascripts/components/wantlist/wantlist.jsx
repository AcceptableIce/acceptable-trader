var Wantlist = React.createClass({
	getInitialState: function() {
		return {
			grid: true
		};
	},
	toggleMode: function() {
		this.setState({ grid: !this.state.grid });
	},
	render: function() {
		return (
			<div class="wantlist-container">
				<a className="button small info" onClick={this.toggleMode}>
					{this.state.grid ? "Show Summary" : "Show Grid"}
				</a>
				{this.state.grid ? 
				<WantlistGrid trade={this.props.trade} wants={this.props.wants} items={this.props.items} />
				:
				<WantlistSummary trade={this.props.trade} wants={this.props.wants} items={this.props.items} />}
			</div>
		)
	}
})