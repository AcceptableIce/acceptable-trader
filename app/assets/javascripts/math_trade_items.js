$(function() {
	var defRaw = $(".bgg-search").attr("value") 
	var defValue = defRaw ? JSON.parse(defRaw) : null;
	$(".bgg-search").select2({
		ajax: {
			url: "/bgg/search_items",
			dataType: "json",
			delay: 250,
			data: function(params) {
				return {
					query: params.term,
					page: params.page || 1
				};
			},
			processResults: function(data, params) {
				params.page = params.page || 0;
				return {
					results: data.items,
					pagination: {
						more: (params.page + 1) * 250 < data.total
					}
				}
			},
			cache: true
		},
		escapeMarkup: function(markup) { return markup; },
		minimumInputLength: 4,
		templateResult: formatResult,
		templateSelection: formatSelection
	});
	
	try {
		$(".bgg-search").data('select2').trigger('select', { data: defValue });
	} catch(e) {}
		
	
	function formatResult(item) {
		if(!item.loading) {
			return item.name + (item.year_published ? " (" + item.year_published + ")" : "");
		} else {
			return "Loading...";
		}
	}
	
	function formatSelection(item) {
		return item.name + (item.year_published ? " (" + item.year_published + ")" : "");
	}
});