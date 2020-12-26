/** Worklist UI component driver for the tiled layout
 * 
 *  This object is responsible for binding/unbinding tile-specific events
 *  as well as compiling the appropriate handlebars template and executing
 *  it on demand.
 */

	function  scrollWorklistCards (workListContents, driver){
		// Register infinite scroll now that we know what our filters look like.
		workListContents.infinitescroll({
			behavior: 'ap',
			loading: {
				finishedMsg: "No more  items to display.",
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
			pixelsFromNavToBottom: 100,
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
				var options = driver.prepareDataForDisplay(json.response.docs[i]);
				ap.WorkItemList.options.worklistEntries.workItem[numCurrentWorkItems+i] = options;
			}
			
			/*
			 * Re-cache the elements, call bindEvents so the newly added 
			 */
			ap.WorkItemList.cacheElements();
			ap.WorkItemList.render();
			driver.bindEvents();
		}.bind(this));
	}
	
	function WorkItemList_Tiles() {
		this.initialized = false;	
		this.infiniteScrollInitialized = false;
		
		this.init = function() {
			this.cacheElements();
			this.type = "tiles";
			this.initialized = true;
		};
		
		this.cacheElements = function() {
						
			var template =  $('#work_list_tiles_container_template').html();
			
			ap.WorkItemList.templates['worklistTilesTemplate'] = Handlebars.compile(template);
			
			var  entityTemplate = Handlebars.compile( $('#work_list_tiles_template').html() );
			Handlebars.registerPartial("list_tiles", entityTemplate );
		};
		
		this.bindEvents = function() {
			this.unbindEvents();
			var contents = ap.WorkItemList.$worklistContents;
			ap.WorkItemList.clicks = 0;
			// Click on a work item -> select the work item and request actions if needed
			//We are using click event to trigger both click and double click to avoid triggering click event twice for double click
			contents.on( 'click', 'div', function(e) {
				ap.consoleInfo("Target=" + e.target.id);
				e.stopPropagation();
				ap.WorkItemList.clicks++;
				ap.consoleInfo("clicks = " + ap.WorkItemList.clicks);
				if(ap.WorkItemList.clicks === 1){
					ap.WorkItemList.clickTimer = setTimeout(function() {
						ap.WorkItemList.clicks = 0;
						ap.WorkItemList.selectWorkItem.call(this, e);
				    }.bind(this), 300);
				}else{
					clearTimeout(ap.WorkItemList.clickTimer);
					ap.WorkItemList.selectWorkItem.call(this, e);
					ap.WorkItemList.LaunchSelectedWorkItem.call(this, e);
					ap.WorkItemList.clicks = 0;
				}
			});   // table row work item
			
			contents.on('click','button#work_item_actions_secondary',function(e){
				e.stopPropagation();
				ap.consoleInfo("Target=" + e.target.id);
				$('#work_item_actions_secondary').dropdown('toggle');
				e.preventDefault();
			});
			
			// Click on a work item action button -> execute the appropriate action
			contents.on( 'click', 'span.work_list_action', ap.WorkItemList.performWorkItemAction);

			// Double-click on a work item -> execute default action: open work item
			contents.on( 'dblclick', 'div', function(e) { 
				e.preventDefault();
			} );
		};
		this.unbindEvents = function() {
			var contents = ap.WorkItemList.$worklistContents;

			// Click on a work item -> select the work item and request actions if needed
			contents.off( 'click ', 'div'); // tile work item
			
			contents.off( 'click', 'button#work_item_actions_secondary');
			
			// Click on a work item action button -> execute the appropriate action
			contents.off( 'click', 'span.work_list_action');

			// Double-click on a work item -> execute default action
			contents.off( 'dblclick', 'div');
		};
		this.renderHtml = function(dataModel) {
			return ap.WorkItemList.templates['worklistTilesTemplate'](dataModel);
		};
		
		this.initializeInfiniteScroll = function() {
			var workListContents = $('#work_list_contents');
			
			if(workListContents.infinitescroll) {
				workListContents.infinitescroll('destroy');
				workListContents.data('infinitescroll', null);
			}
			
			scrollWorklistCards(workListContents, this);
		
			this.infiniteScrollInitialized = true;
		};
		
		this.prepareDataForDisplay = function(data) {
			var entity = {
				id: data.id,
				complete_percent: data.complete_percent,
				creator_id: data.creator_id,
				entity_name: data.entity_name,
				lob: data.lob,
				lob_desc: data.lob_desc,
				owner_group_id: data.owner_group_id,
				owner_id: data.owner_id,
				status: data.status,
				transaction_id: data.transaction_id,
				transaction_type: data.transaction_type,
				user_group_id: data.user_group_id,
				workitem_status: data.workitem_status,
				account_id: data.account_id
			};
			
			// Effective date
			var effectiveDateParts = data.effective_date.substring(0,10).split('-');
			entity.effective_date = effectiveDateParts[1] + "-" + effectiveDateParts[2] + "-" + effectiveDateParts[0];
			
			// Last update time
			var lastUpdate = data.last_update_time.replace('Z', '');
			var lastUpateParts = lastUpdate.substring(0,10).split('-');
			entity.last_update_time = lastUpateParts[1] + "-" + lastUpateParts[2] + "-" + lastUpateParts[0] +  " " + lastUpdate.substring(11);
			
			if(data.status) {
				entity.after_title = ap.statusCodes[data.status].after_title;
			}
			if(data.transaction_id && ap.WorkItemList.options.WIPMetaData.transaction_data[data.transaction_id]) {
				entity.transaction_type = ap.WorkItemList.options.WIPMetaData.transaction_data[data.transaction_id]["title"];
			}
			entity.premium = "$" + parseInt(data.premium).toFixed(2);
			
			return entity;
		};
	}
	
	$(function (){
		ap.WorkItemList_Tiles = new WorkItemList_Tiles();
		ap.WorkItemList_Tiles.init();
		ap.WorkListDriver.push(ap.WorkItemList_Tiles);
				
	});


