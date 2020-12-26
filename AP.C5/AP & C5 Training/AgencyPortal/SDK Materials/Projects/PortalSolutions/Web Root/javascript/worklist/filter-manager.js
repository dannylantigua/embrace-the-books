// Setup ap namespace if not already defined.
if(typeof(ap) == 'undefined') {
    var ap ={};
}

if (!Object.keys) {
	  Object.keys = (function () {
	    'use strict';
	    var hasOwnProperty = Object.prototype.hasOwnProperty,
	        hasDontEnumBug = !({toString: null}).propertyIsEnumerable('toString'),
	        dontEnums = [
	          'toString',
	          'toLocaleString',
	          'valueOf',
	          'hasOwnProperty',
	          'isPrototypeOf',
	          'propertyIsEnumerable',
	          'constructor'
	        ],
	        dontEnumsLength = dontEnums.length;

	    return function (obj) {
	      if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {
	        throw new TypeError('Object.keys called on non-object');
	      }

	      var result = [], prop, i;

	      for (prop in obj) {
	        if (hasOwnProperty.call(obj, prop)) {
	          result.push(prop);
	        }
	      }

	      if (hasDontEnumBug) {
	        for (i = 0; i < dontEnumsLength; i++) {
	          if (hasOwnProperty.call(obj, dontEnums[i])) {
	            result.push(dontEnums[i]);
	          }
	        }
	      }
	      return result;
	    };
	 }());
}

var FilterManager =  {
	
	/**
	 * Object that contains all filter terms.  This is divided up by the types of filtering that are employed by the application.
	 * For instance, the two top-level objects are "account" and "worklist" for the account and worklist filtering.  Within each
	 * top-level object can be other data structures that are needed to support filtering.
	 * Any new application of the FilterManager should create a new top-level object to house filter conditions specific to it.
	 * 
	 * This object is retrieved and stored from/to the database via the WorkItemFilteringServlet and WorkItemFilteringManager.
	 */
	filter: {
			account: {},
			worklist: {
				lob: [],
				work_item_status: [],
				transaction: [],
				entity_name: "",
				id: ""
			}
	},
	
	/**
	 * Perform any initialization work that needs to take place.  For the stock implementation, we
	 * just want to make sure filters are applied whenever the user types in the search box by binding
	 * a keyup event.
	 * 
	 * We also want to fetch the saved filters from the server.
	 * 
	 * This function accepts an options hash that contains all the values needed for intialization.
	 * 
	 * activeFiltersDivId 	- The id of the DOM element that will contain badges representing active filters.
	 * searchBoxId 			- The id of the DOM element that serves as the search box.
	 * entitiesList			- A list of entities that are to be filtered on.  In the case of accounts and work items, this is
	 * 							not relevant since we always pull from Solr.  However, in an attempt to support generic application,
	 * 							this list was added in case a static set of data is desired.
	 * filterType			- The type of filter we're working with (I know, not very helpful).  This attribute is used to
	 * 							indicate which top-level object within the filter object we should look into for filtering options.
	 * entityTemplateId		- The Handlebars template that will be used to render individual entities (i.e. tiles or rows for
	 * 							a worklist).
	 */
	initialize: function(options) {
		this.activeFiltersDisplay = jQuery('#' + options.activeFiltersDivId);
		
		this.searchBox = jQuery('#' + options.searchBoxId);
		
		this.filterBaseUrl = options.filterBaseUrl;
		
		this.entitiesList = options.entitiesList;
		
		this.filterType = options.filterType;
		
		this.entityTemplate = Handlebars.compile( $("#" + options.entityTemplateId).html() );
		
		this.searchBox.on('keyup', function() {
			this.filter.entity_name = this.searchBox.val();
			if(this.filter.entity_name.length > 2 || this.filter.entity_name.length == 0){
				this.applyFilters();
			}
		}.bind(this));
		this.filterData = ap.options.WIPMetaData.filterData;
		this.retrieveSavedFilters();
		
		if(options.quotebox && options.quotebox.length > 0){
			this.addFilter("work_item_status", options.quotebox);		
			setTimeout(function() {
				  this.applyFilters();
				this.renderActiveFilterIndicators(this.activeFiltersDisplay);
			 }.bind(this), 500);			
		}
	},
	
	/**
	 * 
	 */
	retrieveSavedFilters: function() {
				
			// Overwrite current filter settings with what we get back from the server, if filterData exists.
			if(!jQuery.isEmptyObject(this.filterData.active_filters)) {
				this.filter = this.filterData.active_filters;
			}
			
			// Populate the search bar with an existing entity name if we haven't selected one of the canned queries.
			if(this.searchBox.val() == "" && this.filter[this.filterType] !== undefined) {
				this.searchBox.val(this.filter[this.filterType].entity_name);
			}
			
			// Apply the filters to each work item.
			this.applyFilters();
			ap.consoleInfo("Retrieved filter with criteria " + JSON.stringify(this.filterData.active_filters));
			
			/*
			 * Iterates over the available filter options and populates dropdowns with the options.
			 */
			for(var k in this.filterData) {
				if(!this.hasAssociatedFilter(k)) {
					continue;
				}
				
				// Get a reference to a filter dropdown.  The naming convention is "filter_<filter name>", so make
				// sure that the key for a set of filter options produced by WorkItemFilteringManager matches the
				// name of the filter on the client-side.
				var dropdown = $('#filter_' + k);
				
				// Iterate through options for this particular filter and create entries in the dropdown.
				// Each entry is configured with onclick events that trigger filterOnSelection so filtering
				// takes place immediately.  A call to renderActiveFilterIndicators is also made so a badge
				// is displayed to indicate that the filter is active.
				if( !(this.filterData[k] instanceof Object))
					continue;
				var reverseMap = {};
				for(var rKey in this.filterData[k]) {
					reverseMap[this.filterData[k][rKey]] = rKey;
				}
				
				var keysObjects = Object.keys(reverseMap).sort();
				for(var i = 0; i< keysObjects.length;  i++){
					var key = reverseMap[keysObjects[i]];
					dropdown.append('<li class="' + k + '-' + key + '"><a id="filter_' + k + '_'+ key + '" href="#" onclick="ap.filterManager.filterOnSelection(\'' + k + '\', \'' + key + '\');ap.filterManager.renderActiveFilterIndicators(ap.filterManager.activeFiltersDisplay);"><span class="swatch"></span><i class="fa lob-icon"></i>' + this.filterData[k][key] + '</a></li>');
				}
			}
			this.renderActiveFilterIndicators(this.activeFiltersDisplay);
				
	},
	
	/**
	 * Based on the current contents of the filter, draw all the filter indicators into
	 * the provided container.
	 * 
	 * This function should be overridden by any features looking to implement this for their own use. 
	 * 
	 * @param container		A JQuery-wrapped div element.
	 */
	renderActiveFilterIndicators: function(container) {
		container.empty();
		
		if(this.filter[this.filterType] === undefined){
			return;
		}
		if(this.filter[this.filterType].lob.length == 0 && 
				this.filter[this.filterType].work_item_status.length == 0 && 
				this.filter[this.filterType].transaction.length == 0 && 
				this.filter[this.filterType].id == "") {
			container.append("<span class='filter-button showing-all'>" + ap.core_prompts['label.Account.ShowingAllWorkItems'] + "</span>");
			return;
		}
		
		for(var i=0; i<this.filter[this.filterType].lob.length; i++) {
			var badgeId = "filterbadge_" + this.filter[this.filterType].lob[i];
			var badgeValue = this.filterData["lob"][this.filter[this.filterType].lob[i]];
			container.append("<div id='" + badgeId + "' class='filter-button'>" + "<button class='close filter-close' onclick='ap.filterManager.removeFilter(\"lob\"," + i + ", \"" + badgeId + "\");'><i class=\"fa\"></i></button>" + badgeValue + "</div>");
		}
		
		for(var i=0; i<this.filter[this.filterType].work_item_status.length; i++) {
			var badgeId = "filterbadge_" + this.filter[this.filterType].work_item_status[i];
			var badgeValue = this.filterData["work_item_status"][this.filter[this.filterType].work_item_status[i]];
			container.append("<div id='" + badgeId + "' class='filter-button'>" + "<button class='close filter-close' onclick='ap.filterManager.removeFilter(\"work_item_status\"," + i + ", \"" + badgeId + "\");'><i class=\"fa\"></i></button>" + badgeValue + "</div>");
		}
		
		for(var i=0; i<this.filter[this.filterType].transaction.length; i++) {
			var badgeId = "filterbadge_" + this.filter[this.filterType].transaction[i];
			var badgeValue = this.filterData["transaction"][this.filter[this.filterType].transaction[i]];
			container.append("<div id='" + badgeId + "' class='filter-button'>" + "<button class='close filter-close' onclick='ap.filterManager.removeFilter(\"transaction\"," + i + ", \"" + badgeId + "\");'><i class=\"fa\"></i></button>" + badgeValue + "</div>");
		}
		
		this.customRenderActiveFilterIndicators(container);
	},
	
	/**
	 * Custom hookpoint for rendering active filters.
	 */
	customRenderActiveFilterIndicators: function(container) {
		// Do nothing by default.  This is a hookpoint for delivery teams.
	},
	
	/**
	 * Removes a filter criterion and also deletes the badge representing it on the UI.
	 * 
	 * @param filterItem
	 * @param index
	 * @param badgeId
	 */
	removeFilter: function(filterItem, index, badgeId) {
		this.removeActiveFilter(filterItem, this.filter[this.filterType][filterItem][index]);
		this.renderActiveFilterIndicators(this.activeFiltersDisplay);
	},
	
	/**
	 * remove selected filter
	 * @param type		The type of filter that is being used (i.e. LOB, Work Item Status, Transaction).
	 * @param value		The specific value for the filter type (i.e. LOB - INPROGRESS).
	 */
	removeActiveFilter: function(type, value) {
	
		var itemIndex = -1;		
		if(this.filter[this.filterType][type] == undefined) {
			this.filter[this.filterType][type] = [];
		}
		
		for(var i=0; i<this.filter[this.filterType][type].length; i++) {
			if(this.filter[this.filterType][type][i] == value) {	
				itemIndex = i;
			}
		}
		
		if(itemIndex > -1) {
			this.filter[this.filterType][type].splice(itemIndex, 1);
			this.applyFilters();
		}
	},
	/**
	 * Runs each entity through available filters to determine which
	 * should be shown and which should be hidden.
	 * 
	 * In this implementation (worklist) we forego this and go right to Solr
	 * to fetch the work items to render.
	 */
	applyFilters: function() {
		ap.WorkItemList.fetchWorkItems();
	},
	
	/**
	 * Hookpoint to perform any actions on an entity that passes filtering.  Worklist does not use this.
	 * 
	 * @param entity	The entity that passes filtering.
	 */
	actOnEntityThatPassedFiltering: function(entity) {
		
	},
	
	/**
	 * Hookpoint to perform any actions on an entity that fails filtering.  Worklist does not use this.
	 * 
	 * @param entity	The entity that fails filtering.
	 */
	actOnEntityThatFailedFiltering: function(entity) {
		
	},
	
	/**
	 * Function where filtering criteria is applied to the passed-in entity.
	 * 
	 * @param entity		The entity to apply filtering criteria to.
	 * @returns				True, if the entity passes filtering.  False, otherwise.
	 */
	applyFilterCriteria: function(entity) {
		return true;
	},
	
	/**
	 * Edits the filter object to add or remove the selected filter based on whether the filter item is already active.  Once
	 * the filter object has been edited, the filters are applied to the entities (or, in the case of the worklist, Solr is
	 * called.) and the modified filter object is saved to the database.
	 * 
	 * @param type		The type of filter that is being used (i.e. LOB, Work Item Status, Transaction).
	 * @param value		The specific value for the filter type (i.e. LOB - INPROGRESS).
	 */
	filterOnSelection: function(type, value) {
		/*
		 * Are we already filtering on the specified value?
		 */
		var hasItem = false;
		if(this.filter[this.filterType][type] == undefined) {
			this.filter[this.filterType][type] = [];
		}
		
		for(var i=0; i<this.filter[this.filterType][type].length; i++) {
			if(this.filter[this.filterType][type][i] == value) {
				hasItem = true;
				itemIndex = i;
			}
		}

		if(!hasItem){
			this.filter[this.filterType][type].splice(0,0,value);
			this.applyFilters();
		}
	},
	
	/**
	 * Edits the filter object to add or remove the selected filter based on whether the filter item is already active.  
	 * 
	 * @param type		The type of filter that is being used (i.e. LOB, Work Item Status, Transaction).
	 * @param value		The specific value for the filter type (i.e. LOB - INPROGRESS).
	 */
	addFilter : function (type, value){
		/*
		 * Are we already filtering on the specified value?
		 */
		if(this.filter[this.filterType][type] == undefined) {
			this.filter[this.filterType][type] = [];
		}
		
		for(var i=0; i<this.filter[this.filterType][type].length; i++) {
			if(this.filter[this.filterType][type][i] == value) {
				return;
			}
		}
		
		this.filter[this.filterType][type].splice(0,0,value);
	},
	
	/**
	 * Provides a check for certain elements within the filtering object from the database that can be ignored.
	 */
	hasAssociatedFilter: function(filterName) {
		if(filterName == "active_filters" || filterName == "entity_name" || filterName == "id") {
			return false;
		}
		
		return true;
	},
	
	/**
	 * apply sorting order
	 * @param sortby sort criteria
	 */
	applySort: function(sortby){
		
		var sortresults = $('#sortresults');
		if(null != sortresults){
			sortresults.val(sortby);	
			this.applyFilters();
		}		
	}
};

/*
 * Add an unconfigured, non-functioning instance to the ap object.  It will be up to the
 * developer to configure it with the proper settings prior to use.
 */
ap.filterManager = FilterManager;
