/** Worklist UI component driver for the table layout
 * 
 *  This object is responsible for binding/unbinding table-specific events
 *  as well as compiling the appropriate handlebars template and executing
 *  it on demand.
 */
$(document).ready(function() {
	
	function scrollWorklistTable (workListContents, driver){
		// Register infinite scroll now that we know what our filters look like.
		workListContents.infinitescroll({
			behavior: 'ap',
			loading: {
				finishedMsg: "No more items to display.",
				msgText: "",
				img: "assets/img/indicator_medium.gif"
			},
			state: {
				isDuringAjax: false,
		        isInvalidPage: false,
		        isDestroyed: false,
		        isDone: false, // For when it goes all the way through the archive.
		        isPaused: false,
		        currPage: ap.initialWorklistSize/ap.workListFetchSize
		    },
			navSelector: '#results_nav',
			nextSelector: '#results_nav_next',
			itemSelector: '#work_list_contents .worklist-item',
			dataType: 'json',
			appendCallback: false,
			loadingText: "Loading...",
			donetext: "There are no more items to load.",
			pixelsFromNavToBottom: 400,
			debug: true,
			_showdonemsg_ap: function() {
				return;
			},
			path: function(pageNum) {
				// Use a global variable to keep track of the "page number" we are on.
				// The page number in this case is just our offset for paging.  Since an
				// infinite scroll instance is initialized for each work list we can't rely
				// on the pageNum variable passed into the function, since it will be
				// behind after using one work list and switching to another (which will
				// lead to duplicate work items being displayed).
				if(!ap.infiniteScrollOffset) {
					ap.infiniteScrollOffset = ap.initialWorklistSize/ap.workListFetchSize;
				}
				else {
					ap.infiniteScrollOffset++;
				}
				
				var finalQuery = ap.searchManager.constructSolrQuery();
				var startRow = ap.infiniteScrollOffset*ap.workListFetchSize;

				// Looks like the filter criteria changed since our last fetch.  Reset the paging since we're working with a new dataset.
				if(ap.lastSolrQuery != finalQuery) {
					startRow = ap.initialWorklistSize;
					ap.lastSolrQuery = finalQuery;
					ap.infiniteScrollOffset = ap.initialWorklistSize/ap.workListFetchSize;
				}
				return ap.options.WIPMetaData.solr_select_url + "?q=" + finalQuery + 
						"&wt=json&sort=last_update_time+desc&start=" + startRow + "&rows=" + ap.workListFetchSize + "&index_type=" + ap.searchManager.indexType;
			}
		}, function(json, opts) {
			/* 
			 * Determine the number of work items currently displayed (using a loop because IE8 doesn't support Object.keys()).
			 */
			var numCurrentWorkItems = 0;
			for(var key in ap.WorkItemList.options.worklistEntries.workItem) {
				numCurrentWorkItems++;
			}
			
			/*
			 * Iterate through the results, create a compatible work item object, and add
			 * it to the existing list of work items.
			 */
			for(var i=0; i<json.response.docs.length; i++) {
				var _options = driver.prepareDataForDisplay(json.response.docs[i]);
				ap.WorkItemList.options.worklistEntries.workItem[numCurrentWorkItems+i] =_options;
			}
			
			/*
			 * Re-cache the elements, call bindEvents so the newly added 
			 */
			ap.WorkItemList.cacheElements();
			ap.WorkItemList.render();
			driver.bindEvents();
		}.bind(this));		
	}
	
	function WorkItemList_Table() {
		this.initialized = false;
		
		this.infiniteScrollInitialized = false;

		this.init = function() {
			this.cacheElements();
			this.type = "table";
			this.initialized = true;
			this.entityTemplate = Handlebars.compile( $('#work_list_table_template').html() );
			
		};
		
		this.cacheElements = function() {
			ap.WorkItemList.templates['worklistTableTemplate'] = 
				Handlebars.compile( $('#work_list_table_template').html());
		};
		
		this.bindEvents = function() {
	
			var contents = ap.WorkItemList.$worklistContents;

			// Click on a work item -> select the work item and request actions if needed
			contents.on( 'click', 'tr', function(e) {
			    setTimeout(function() {
			        var dblclick = parseInt($(this).data('double'), 10);
			        if (dblclick > 0) {
			            $(this).data('double', dblclick-1);
			            return false;
			        } else {
			        	ap.WorkItemList.selectWorkItem.call(this, e);
			        	e.stopPropagation();
			        }
			    }.bind(this), 300);
			});   // table row work item

			// Click on a work item action button -> execute the appropriate action
			contents.off( 'click', 'span.work_list_action', ap.WorkItemList.performWorkItemAction );
			contents.on( 'click', 'span.work_list_action', ap.WorkItemList.performWorkItemAction );

			// Double-click on a work item -> execute default action
			contents.on( 'dblclick', 'tr', function(e) {
			    $(this).data('double', 2);
			    ap.WorkItemList.selectWorkItem.call(this, e);
			    ap.WorkItemList.open.call(this, e);
			    e.stopPropagation();
			} );
		};
		
		this.unbindEvents = function() {
			var contents = ap.WorkItemList.$worklistContents;

			// Click on a work item -> select the work item and request actions if needed
			contents.off( 'click', 'tr', ap.WorkItemList.selectWorkItem);   // table row work item

			// Click on a work item action button -> execute the appropriate action
			contents.off( 'click', 'span.work_list_action', ap.WorkItemList.performWorkItemAction );

			// Double-click on a work item -> execute default action
			contents.off( 'dblclick', 'tr', ap.WorkItemList.open );
		};
		
		this.renderHtml = function(dataModel) {
			return ap.WorkItemList.templates['worklistTableTemplate'](dataModel);
		};
		
		this.initializeInfiniteScroll = function() {
			var workListContents = $('#work_list_contents');
			
			// When toggling between work list views, we need to destroy the infinitescroll
			// that gets attached to the work_list_contents DOM element.  If we don't, it
			// won't re-initialize and will stay registered to the previous view.
			if(workListContents.infinitescroll) {
				workListContents.infinitescroll('destroy');
				workListContents.data('infinitescroll', null);
			}			
			scrollWorklistTable(workListContents, this);			
			this.infiniteScrollInitialized = true;
		};
		
		this.prepareDataForDisplay = function(data) {
			var entity = {};
			for(var key in data) {
				entity[key] = data[key];
			}
			
			// Effective date			
			var effectiveDateParts = data.effective_date.substring(0,10).split('-');
			entity.effective_date = effectiveDateParts[1] + "-" + effectiveDateParts[2] + "-" + effectiveDateParts[0];
	
			
			// Last update time
			//2014-09-10T13:39:15Z
			var lastUpdate = data.last_update_time.replace('Z', '');
			var lastUpateParts = lastUpdate.substring(0,10).split('-');
			entity.last_update_time = lastUpateParts[1] + "-" + lastUpateParts[2] + "-" + lastUpateParts[0] +  " " + lastUpdate.substring(11);
			
			if(data.status) {
				entity.after_title = ap.statusCodes[data.status].after_title;
			}
			if(data.transaction_id && ap.options.WIPMetaData.transaction_data[data.transaction_id]) {
				entity.transaction_type = ap.options.WIPMetaData.transaction_data[data.transaction_id]["title"];
			}
			entity.premium = "$" + parseInt(data.premium).toFixed(2);
			
			return entity;
		};
		
		this.sortedColumnName = "";
		
		this.sort = function(element, columnName) {
			if(this.sortedColumnName != columnName){
				ap.filterManager.applySort(columnName +' asc');
				this.sortedColumnName = columnName;
			}
			else if(this.sortedColumnName == columnName){
				ap.filterManager.applySort(columnName +' desc');
				this.sortedColumnName = "";
			}
			
		};
	};
	
	ap.WorkItemList_Table = new WorkItemList_Table();
	ap.WorkItemList_Table.init();
	ap.WorkListDriver = [];
	ap.WorkListDriver.push(ap.WorkItemList_Table);
	
});
