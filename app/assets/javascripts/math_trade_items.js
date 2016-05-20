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
						more: (params.page + 1) * 30 < data.total
					}
				}
			},
			cache: true
		},
		escapeMarkup: function(markup) { return markup; },
		minimumInputLength: 2,
		templateResult: formatResult,
		templateSelection: formatSelection
	});
	
	try {
		$(".bgg-search").data('select2').trigger('select', { data: defValue });
	} catch(e) {}
		
	
	function formatResult(item) {
		return item.name + (item.year_published ? " (" + item.year_published + ")" : "");
	}
	
	function formatSelection(item) {
		if(item) {
			return item.name + (item.year_published ? " (" + item.year_published + ")" : "");
		} else {
			return "";
		}
	}
});