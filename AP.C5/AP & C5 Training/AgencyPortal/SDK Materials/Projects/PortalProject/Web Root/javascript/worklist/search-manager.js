var SearchManager = {
	/**
	 * Perform any initialization tasks that need to occur.
	 * 
	 * The passed-in options map contains the following:
	 * filterManager 			- A reference to a FilterManager.
	 * searchBoxId 				- The id of the DOM element representing the search box (if applicable).
	 * solrUrl					- The URL used to query Solr.
	 * indexType 				- The name of the Solr index that is being used.
	 * bloodhoundOpts 			- Options for the Bloodhound engine.  This is optional.
	 * typeaheadConfig			- A map of options for the typeahead component.  This is optional.
	 * typeaheadSourceConfig	- Configuration to determine the source of the data.  This is optional.
	 */
	initialize: function(options) {
		this.filterManager = options.filterManager;
		
		this.searchBox = $('#' + options.searchBoxId);
		
		this.solrUrl = options.solrUrl;
		
		this.indexType = options.indexType;
		
		this.autoSuggestCount = ap.options.autoSuggestCount;
		
		//setup typehead if it s has not beet set up 
		if(options.typeHeadSetup != 'true'){ 
			// The search manager utilizes the Bloodhound engine to perform data retrieval 
			var bloodhoundOpts;
			if(options.bloodhoundOpts) {
				bloodhoundOpts = options.bloodhoundOpts;
			}
			else {
				bloodhoundOpts = {
						datumTokenizer: function(d) {
							return [d.value];
						},
						queryTokenizer: Bloodhound.tokenizers.whitespace,
			            minLength: 3,
						remote: {
							url: this.solrUrl,
							replace: function(url, query) {
								var finalQuery = this.constructSolrQuery(query);
								return url + "?q=" + finalQuery + "&wt=json&hl=true&sort=last_update_time desc&index_type=" + this.indexType;
							}.bind(this),
							filter: function(parsedResponse) {
								var arr = this.renderSolrData(parsedResponse); 
								return arr;
							}.bind(this)
						}
				};
			}
			if(this.autoSuggestCount){
				bloodhoundOpts['limit'] = this.autoSuggestCount;
			}else{
				bloodhoundOpts['limit'] = -1;
			}
				
			
			this.suggestionEngine = new Bloodhound(bloodhoundOpts);

			this.suggestionEngine.initialize();

			var typeaheadConfig = options.typeaheadConfig || {
				minLength: 3,
				highlight: true
			};
			var typeaheadSourceConfig = options.typeaheadSourceConfig || {
				source: this.suggestionEngine.ttAdapter(),
				templates: {
					suggestion: Handlebars.compile('{{worklistitems}}')
				}
			};
			var typeaheadSelectedFunction = options.typeaheadSelectedFunction || function(event, suggestion, datasetName) {
				this.searchBox.typeahead('val', this.filterManager.filter.entity_name);
				this.typeaheadAutocomplete(suggestion);
			};
			var typeaheadAutoSelectedFunction = options.typeaheadAutoSelectedFunction || function(event, suggestion, datasetName) {};

			this.searchBox.typeahead(typeaheadConfig, typeaheadSourceConfig)
			.on('typeahead:selected', typeaheadSelectedFunction.bind(this))
			.on('typeahead:autoselected', typeaheadAutoSelectedFunction);
		}
		Handlebars.registerHelper('worklistitems', function() {
			if(this.open == false){
				return new Handlebars.SafeString("<p class='not-owned'>" + this.value + "</p>");
			}else{
				return new Handlebars.SafeString("<p class='owned'>" + this.value + "</p>");
			}
		});
	},
	
	/**
	 * The method used to return selected item. Accepts a single argument, the item and has the scope 
	 * of the typeahead instance.
	 * 
	 * @param item
	 * @returns
	 */
	typeaheadAutocomplete: function(suggestion) {
		// If the user clicks on the "XX others" entry, just ignore it.
		var item = suggestion.value;
		if(item.search(/^\d* other(s)?$/) != -1) {
			return;
		}
		
		if(suggestion.open == false){
			return;
		}
			
		// Parse out the entity name so we can return it for display on the search bar.
		var entityName = suggestion.name;
		
		// Parse out the work item id and LOB so we can plug them into the FrontServlet URL.
		var workItemId = suggestion.workitemid;
		
		/*
		 * Send the user to the transaction.
		 */
		window.location = "LaunchWorkItem?WORKITEMID=" + workItemId + "&action=Open&openmode=editMode&WorkListType=WorkItemsView";
		
		return entityName;
	},
	
	/**
	 * Convenience method to retrieve the contents of the search box.
	 * 
	 * @returns		A string representing the contents of the search box.
	 */
	getSearchBoxContents: function() {
		return this.searchBox.val();
	},
	
	/**
	 * Populates the search box with the query passed in and triggers a keyup event on the
	 * search box so the typeahead functionality is engaged.
	 * 
	 * @param query		The value to write into the search box.
	 */
	populateSearchBox: function(query) {
		this.searchBox.typeahead('val', query);
	},
	/**
	 * Creates a Solr query based on the current filter configuration.
	 */
	constructSolrQuery: function(query) {
		var final_query = query || this.getSearchBoxContents();
		
		if(final_query == "") {
			final_query = "*";
		}
		final_query = "entity_name_search:" + final_query;
		
		// We don't want delete work items or ones that haven't advanced past the first page
		final_query += " AND -status:55 AND commit_flag:1";
		
		// Add constraint for the account id if it exists
		if(ap.accountId != undefined && ap.accountId != "") {
			final_query += " AND account_id:" + ap.accountId;
		}
		
		var filter = this.filterManager.filter[this.filterManager.filterType];
		if(filter !== undefined){
			var criteria = [filter.lob, filter.work_item_status, filter.transaction];
			var criteriaLabels = ["lob", "workitem_status", "transaction_type"];
			for(var i=0; i<criteria.length; i++) {
				if(criteria[i].length > 0) {
					final_query += " AND (";
					for(var j=0; j<criteria[i].length; j++) {
						if(j>0) {
							final_query += " OR ";
						}
						
						final_query += criteriaLabels[i] + ":" + criteria[i][j];
					}
					final_query += ")";
				}
			}
		}
		
		var advancedQuery = this.constructAdvancedSearchQuery();
		if(advancedQuery.length > 0){
			final_query += advancedQuery;
		}
		
		var $sortField = $('#sortresults');
		if($sortField.length && $.trim($sortField.val()).length > 0){
			final_query += '&sort=' + $.trim($sortField.val());
		}else {
			final_query += '&sort=last_update_time desc';
		}
		return final_query;
	},
	
	/**
	 * Called by the Typeahead component to determine how results will be displayed to the user.
	 * 
	 * @param data		The response from the datasource queried (in our case, Solr).  This will be a JSON object.
	 * @returns			An array of strings.  Each will represent an item in the dropdown.
	 */
	renderSolrData: function(data) {
		if(data.responseHeader.status == 1) {
			ap.consoleInfo(data.responseHeader.description);
		}
		
		var arr = [];
		var count = 0;
		
		// Iterate through each of the Solr results, keeping only the first four that we get.
		// All others will be ignored and we'll inform the user that there are <result size> - 4
		// more results available.
		jQuery.each(data.response.docs, function(index, doc) {
			if(count == 4) {
				return;
			}
			var encodedName = ap.htmlEncode(doc.entity_name);
			arr.push({
				workitemid: doc.id,
				name: encodedName,
				value: encodedName + " (" + doc.id + " - " + doc.lob + ")",
				open: (doc.open_mode=='N')?false:true
			});
			count++;
		});
		
		// The last entry is an indicator of how many more search hits there are if
		// there are more than 4 total.
		if(data.response.docs.length > 4) {
			ap.consoleInfo("Found " + data.response.docs.length + " solr hits.");
			
			if(data.response.docs.length == 5) {
				arr.push({value: data.response.docs.length-4 + " other"});
			}
			else {
				arr.push({value: data.response.docs.length-4 + " others"});
			}
		}
		
		return arr;
	},
	
	initializeAdvancedSearch: function(){
		
		$('#start_date').parent().datepicker({
			format: "mm-dd-yyyy",
			autoclose: true,
			todayHighlight: true}
		).on('show', function(e) {
	        $('.datepicker').click(function () { return false; });
	    });
		
		$('#end_date').parent().datepicker({
			format: "mm-dd-yyyy",
			autoclose: true,
			todayHighlight: true}
		).on('show', function(e) {
	        $('.datepicker').click(function () { return false; });
	    });
		
		var val =  $('#date_operator').val();
		if(val == 'between'){
			$('#end_date_div').show();
		}else{
			$('#end_date_div').hide();
		}
		
		$('#date_operator').bind('change', function(){
			var val = $(this).val();
			if(val == 'between'){
				$('#end_date_div').show();
			}else{
				$('#end_date_div').hide();
				$('#end_date').val('');
			}		
		});
	},
	
	validateAndFetchWorkItems : function(){
		if(this.validateAdvancedQuery()){
			this.fetchWorkItems();
			if($('#worklist_advanced_search_div').length){
				$('#worklist_advanced_search_div').removeClass('open');
			}
		}
	},
	
	validateAdvancedQuery : function(){
//		var $msg = $('#workitem_error_msg_advanced_search');
//		$msg.html("");
//		$msg.hide();
//		
//		var $workItemId = $('#workItemId');
//		if($workItemId.length){
//			var $parent = $workItemId.parent();
//			$parent.removeClass("problemFieldRow has-error");
//			var length = $.trim($workItemId.val()).length;
//			if(length > 0 && length != 4){
//				$msg.html("Number should be an exact match.").show(); 
//				$parent.addClass("problemFieldRow has-error");
//				return false;
//			}
//		}
		return true;
	},
	
	fetchWorkItems : function(){
		
		var query = this.constructAdvancedSearchQuery();		
		if(query.length > 0 || this.paramEmpty()){
			ap.WorkItemList.fetchWorkItems();
		}
		
	},
	
	paramEmpty : function (){
	
		if($('#workItemId').length > 0 && $.trim($('#workItemId').val()).length >  0){
			 return false;
		}
		
		if($('#start_date').length > 0){	
			var startdate = $.trim($('#start_date').val());
			if(startdate.length > 0){
				return false;
			}
		}
		
		if($('#end_date').length > 0){	
			var enddate = $.trim($('#end_date').val());
			if(enddate.length > 0){
				return false;
			}
		}
		
		return true;
	},
	
	constructAdvancedSearchQuery : function(){
		
		var qParam = '';
		var workItemId = $('#workItemId');
		if(workItemId.length > 0 && $.trim(workItemId.val()).length > 0){
			qParam += ' AND id:' + encodeURIComponent($.trim(workItemId.val()));
		}
	
		if($('#start_date').length > 0){	
			var startdate = $.trim($('#start_date').val());
			var fromDate = this.getDateString(startdate);
			if(fromDate.length > 0){
				fromDate = encodeURIComponent(fromDate);				
				var range = '';
				var op = $('#date_operator').val();
				if(op == 'after'){
					range =  '{' + fromDate+ ' TO *}';
				}else if(op == 'before'){
					range =  '{* TO ' + fromDate + '}';
				}else if(op== 'on'){
					range =  '"' + fromDate +  '"';
				}else if($('#end_date').length > 0){
					var endDate = this.getDateString($('#end_date').val());
					if(endDate.length > 0){
						var toDate = encodeURIComponent(endDate);
						range = '[' + fromDate + ' TO ' +  toDate +  ']';
					}else{
						return qParam;
					}			
				}
				if(range.length > 0){
					qParam += ' AND effective_date:' + range;
				}
			}
		}
		return qParam;
	},
	
	getDateString : function (value){
		var dateFormat = "MM-dd-yyyy";
		if (value.length != dateFormat.length) {
			return '';
		}
		var delimiter = '-';
		if ( dateFormat.indexOf('/') > -1 ) {
			delimiter = '/';
		}
		var slashPos = -1;
		var slashPos2 = -1;
		while ((slashPos = dateFormat.indexOf(delimiter, slashPos + 1)) > -1 ) {
			slashPos2 = value.indexOf(delimiter, slashPos2 + 1);
			if (slashPos2 != slashPos) {
			      return '';
			}
		}

		var month = this.getDatePart(value, dateFormat, 'MM');
		if (month.search(/[^0-9]/) > -1){
			return '';
		}
		var day = this.getDatePart(value, dateFormat, 'dd');
		if (day.search(/[^0-9]/) > -1){
			return '';
		}
		var year = this.getDatePart(value, dateFormat, 'yyyy');
		if (year.search(/[^0-9]/) > -1){
			return '';
		}
		var dateString =  (year + '-' + month + '-' + day + 'T00:00:00Z');
		month = month - 1;
		var dteDate = new Date(year,month,day);
		if((day==dteDate.getDate()) && (month==dteDate.getMonth()) && (year==dteDate.getFullYear())){
			return dateString;
		}	
		return '';		
	},

	getDatePart : function (value, dataFormat, part){
		var partStart = dataFormat.indexOf(part);
		return new String(value.substr(partStart, part.length));
	},
	
	/**
	 * Helper function to get the value from an input field. 
	 * @param fieldObject The HTML element from which to get the value.
	 * @returns Value entered in the HTML element. 
	 */
	getFieldValue: function(fieldObject){
		var fieldValue = "";
		if(fieldObject != null && fieldObject != undefined){
			fieldValue = fieldObject.val();
		}
		return fieldValue; 
	}

};
