/*
 * This is an opportunity to override some methods in the base class 
 * for the purposes of supporting searching in Account Management.
 */

/**
 * Constructs a Solr query string that is compatible with the account index.
 * 
 * @param query			An existing query to build from, or undefined if we want to use the search box contents.
 * @returns {String}	The final query string to be sent to Solr.
 */
SearchManager.constructSolrQuery = function(query) {
	var query = "";
	
	/*
	 * Add sort parameter
	 */
	var $sortField = $('#sortresults');
	if($sortField.length && $.trim($sortField.val()).length > 0){
		query += '&sort=' + $.trim($sortField.val());
	}
	else {
		query += '&sort=last_update_time desc';
	}
	var searchBoxParam = this.getSearchBoxContents();
	if(searchBoxParam == "") {
		searchBoxParam = "*";
	}
	
	var qParam = "entity_name_search:" + searchBoxParam;
	
	if(ap.filterManager.filter[ap.filterManager.filterType] !== undefined && ap.filterManager.filter[ap.filterManager.filterType].type !== undefined
			&& ap.filterManager.filter[ap.filterManager.filterType].type.length > 0) {
		qParam += " AND account_type:(" + ap.filterManager.filter[ap.filterManager.filterType].type.join(" OR ") + ")";
	}
	
	/* Advanced search fields */
	var $accountNumber = $('#accountNumber');
	if($accountNumber.length && $.trim($accountNumber.val()).length > 0){
		qParam += ' AND id:' + encodeURIComponent($.trim($accountNumber.val()));
	}
		
	var $city = $('#city');
	if($city.length && $.trim($city.val()).length > 0){
		qParam += ' AND city:' + encodeURIComponent('"' + $.trim($city.val()) + '"');
	}
	
	var $state = $('#state');
	if($state.length && $.trim($state.val()).length > 0){
		qParam += ' AND state_prov_cd:' + encodeURIComponent($.trim($state.val()));
	}
	
	var $postal_code = $('#zip');
	if($postal_code.length && $.trim($postal_code.val()).length > 0){
		qParam += ' AND postal_code:' + encodeURIComponent($.trim($postal_code.val()));
	}
			
	return qParam + "&" + query;
};

SearchManager.renderSolrData = ap.accountSearchMgr.renderSolrData;

SearchManager.validateAdvancedQuery = function(){
	
	var $msg = $('#error_msg_advanced_search');
	$msg.html("");
	$msg.hide();
	
//	var $accountNumber = $('#accountNumber');
//	if($accountNumber.length){
//		var $parent = $accountNumber.parent();
//		$parent.removeClass("problemFieldRow has-error");
//		var length = $.trim($accountNumber.val()).length;
//		if(length > 0 && length != 4){
//			$msg.html("Number should be an exact match.").show(); 
//			$parent.addClass("problemFieldRow has-error");
//			return false;
//		}
//	}
	var $city = $('#city');
	if($city.length){
		var $parent = $city.parent();
		$parent.removeClass("problemFieldRow has-error");
		var length = $.trim($city.val()).length;
		if(length > 0 && length < 3){
			$msg.html("Please provide at least 3 characters.").show(); 
			$parent.addClass("problemFieldRow has-error");
			return false;
		}
	}
			
	var $postal_code = $('#zip');
	if($postal_code.length){
		var $parent = $postal_code.parent();
		$parent.removeClass("problemFieldRow has-error");
		var val = $.trim($postal_code.val());
		if(val.length > 0){
			val = val.replace('-', '');
			if( val.length < 3 || $.isNumeric(val) == false ){
				$msg.html("Please provide at least 3 numeric digits.").show(); 
				$parent.addClass("problemFieldRow has-error");
				return false;
			}
		}
	}
	
	return true;
};


