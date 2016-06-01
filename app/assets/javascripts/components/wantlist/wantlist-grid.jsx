var WantlistGrid = React.createClass({
	getInitialState: function() {
		var selectionGrid = [];
		for(var wantIndex in this.props.wants) {
			var want = this.props.wants[wantIndex];
			var row = []
			for(var itemIndex in this.props.items) {
				var item = this.props.items[itemIndex];
				if(item.is_group && !want.is_group) {
					row.push(item.want_links.indexOf(want.id) !== -1)
				} else if(item.is_group && want.is_group) {
					row.push(false);
				} else {
					row.push(want.want_values.indexOf(item.id) !== -1)
				}
			}
			selectionGrid.push(row);
		}
		return {
			selectionGrid: selectionGrid,
			wants: this.props.wants,
			loading: false,
			showSaveConfirmation: false
		};
	},
	toggleSelection: function(row, column) {
		var selectionGrid = this.state.selectionGrid;
		selectionGrid[row][column] = !selectionGrid[row][column];
		this.setState({ selectionGrid: selectionGrid });
	},
	saveList: function() {
		var compiledSelectionGrid = [];
		for(var wantIndex in this.state.wants) {
			var want = this.state.wants[wantIndex];
			var row = { id: want.id, items: [], is_group: want.is_group }
			for(var itemIndex in this.props.items) {
				var item = this.props.items[itemIndex];
				row.items.push({ id: item.id, state: this.state.selectionGrid[wantIndex][itemIndex], is_group: item.is_group });
			}
			compiledSelectionGrid.push(row);
		}
		
		this.setState({ loading: true });
		
		$.ajax({
			url: "/trades/" + this.props.trade.id + "/save_wantlist",
				dataType: "json",
				cache: false,
				method: "post",
				data: {
					grid: compiledSelectionGrid
				},
				success: function(data) {
					console.log("Saved successfully");
					this.setState({ loading: false, showSaveConfirmation: true });
					var component = this;
					setTimeout(function() { 
						component.setState({ showSaveConfirmation: false });
					}, 5000);
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString())
				}.bind(this)
		});
	},
	finalizeList: function() {
		if(!this.props.locked) this.saveList();
		
		$.ajax({
			url: "/trades/" + this.props.trade.id + "/confirm_wants",
				dataType: "json",
				cache: false,
				method: "post",
				data: {},
				success: function(data) {
					if(data.status === 0) {
						this.props.parent.setState({ confirmed: null });
					} else {
						this.props.parent.setState({ confirmed: { updated_at: "a few moments ago" } });
					}
				}.bind(this),
				error: function(xhr, status, error) {
					console.error(status, error.toString());
					this.props.parent.setState({ confirmed: { updated_at: this.state.updated_at + ". (An error occurred while saving.)"} });
				}.bind(this)
		});

	},
	removeRow: function(index) {
		var row = this.state.wants[index];
		var selectionGrid = this.state.selectionGrid;
		selectionGrid.splice(index, 1);
		
		var wants = this.state.wants
		wants.splice(index, 1);
		this.setState({ selectionGrid: selectionGrid, wants: wants });
	},
	render: function() {
		var self_reference = this;
		var items = this.props.items;
		var selectionGrid = this.state.selectionGrid;
		var trade = this.props.trade;
		var toggleSelection = this.toggleSelection;
		var removeRow = this.removeRow;
		var headers = this.props.items.map(function(item) {
			return <WantlistHeader key={item.is_group ? item.name : item.id} item={item} />
 		});
		var wants = this.state.wants.map(function(item, index) {
			return <WantlistRow 
				key={index} data={item} items={items} selectionRow={selectionGrid[index]} trade={trade} 
				index={index} toggle={toggleSelection} wantlist={self_reference} removeRow={function() { removeRow(index); } }
				/>
		});
		var buttons = [];
		if(!this.props.wants_due) {
			if(this.props.parent.props.offers_due) {
				buttons.push(
					<a key="submit" className={"button large wantlist-submit " + (this.props.parent.state.confirmed ? "warning" : "success") } onClick={this.finalizeList}>
						{ this.props.parent.state.confirmed ? "Unfinalize" : "Save and Finalize" }
					</a>
				);
				if(!this.props.parent.state.confirmed) {
					buttons.push(
						<a key="save" className="button large info wantlist-submit " onClick={this.saveList}>
							{this.state.loading ? "Saving..." : "Just Save"}
						</a>
					);
				}
			} else {
				buttons.push(
					<a key="save" className="button large info wantlist-submit " onClick={this.saveList}>
						{this.state.loading ? "Saving..." : "Save Wantlist"}
					</a>	
				);
			}
		} else {
			buttons.push(
				<a key="submit" className="button large info wantlist-submit" disabled>
					Wants deadline has passed.
				</a>
			);
		}
		return (
			<div className="wantlist-grid">
				<table className="wantlist">
					<thead>
						<tr>
							<th></th>
							{headers}
						</tr>
					</thead>
					<tbody>
						{wants}
					</tbody>
				</table>
				{ buttons }
				{ this.props.locked ? <div className="wantlist-curtain"><div className="wantlist-curtain-text">Wantlist is locked.</div></div> : null }
				{ this.state.showSaveConfirmation ? <div className="callout success save-confirmation">Wants saved.</div> : null}
			</div>
		);
	}
});	