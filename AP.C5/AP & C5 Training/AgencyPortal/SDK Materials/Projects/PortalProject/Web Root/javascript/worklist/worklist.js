/** WorkItemList object is the central driver for the worklist page.  
 *  This object coordinates all server communication and execution of standard worklist events.
 *  
 *  this.activeWorkListDriver should be set to the desired javascript object that will 
 *  coordinate the UI-specific functions for the current layout.  This is intended to be
 *  extensible to allow the developer to display the data in any way possible.
 */

// Setup ap namespace if not already defined.
if(typeof(ap) == 'undefined') {
    var ap ={};
}

var WorkItemList = {
		
	init: function(options) {
		this.options = options;
		this.options.worklistEntries.workItem = {};
		this.workItems = options.worklistEntries.workItem;
		this.columns = options.WIPMetaData.columnMetaData.columns;
		this.csrfToken = options.csrfToken;
		this.selectedWorkItem = null;
		this.activeWorkListDriver = null;
		
		/**
		 * We keep track of the previous work list driver used to make determinations
		 * on whether we need to rewrite our cache of work item HTML and visibility
		 * flags.
		 * 
		 * Without this, there's no good way of knowing if we need to re-cache the HTML, so
		 * our only approaches are 1) always do it (inefficient when we're not changing views),
		 * or 2) never do it.  The second approach creates a bug where we'll always render
		 * the HTML of the first view loaded when deleting query terms.  
		 */
		this.previousWorkListDriver = null;
		this.templates = {};

		this.cacheElements();
		this.bindEvents();

		this.params = {'WorkListType': this.options.nameSpace};
	},
    
	bindEvents: function() {
		// Put generic worklist events in here
	},
	cacheElements: function() {
		this.$worklistContents = $('#work_list_contents');
	},
	render: function() {
		try {
			
			this.$worklistContents.html( this.activeWorkListDriver.renderHtml( this.options ) );

			this.$worklistContents.find('.no-account').each(function () {
		           $(this).popover({delay: { hide: 300},
		        		   trigger: "hover", 
		        		   html: 'true', 
		        		   placement : 'bottom', 
		        		   content: ap.worklist["actions.link.workitem.hover"]
		        	});
		     });  
		} catch(error) {
			ap.consoleInfo('Error applying template "' + this.activeWorkListDriver + '" for options ' + this.options);
		}
	},
	setActiveWorkListDriver: function(template_driver) {
		if (this.activeWorkListDriver) {
			this.activeWorkListDriver.unbindEvents();
		}
		
		// Make sure to remember our current driver before switching to the new one.
		this.previousWorkListDriver = this.activeWorkListDriver;
		this.activeWorkListDriver = template_driver;
		this.activeWorkListDriver.bindEvents();
	},
	getWorkItem: function( elem, callback ) {
		var id = $( elem ).closest('.worklist-item').attr('id');
		$.each( this.options.worklistEntries.workItem, function( i, val ) {
			if ( val.id == id ) {
				callback.apply( ap.WorkItemList, arguments );
				return false;
			}
		});
	},
	getSolrQuery: function() {
		return "SolrSecurityServlet?q=" +
				ap.searchManager.constructSolrQuery() + 
				"&wt=json&rows=" + ap.initialWorklistSize + 
				"&index_type=worklist&rnd=" + new Date().getTime();
	},
	
	validateAndFetchWorkItems : function(){
		if(ap.searchManager.validateAdvancedQuery()){
			this.fetchWorkItems();
			if($('#advanced_search_div').length){
				$('#advanced_search_div').removeClass('open');
			}
		}
	},
	
	fetchWorkItems: function() {
		var solrQuery = this.getSolrQuery();

		$.get(solrQuery, {})
		.done(function(data, textStatus, jqXHR) {
			ap.consoleInfo(data);
			
			if(data.responseHeader.status == 1) {
				$('#error_msg').html("Unable to fetch work items at this time").show();
				ap.consoleInfo(data.responseHeader.description);
				return;
			}
			
			this.options.worklistEntries.workItem = {};
			
			for(var i=0; i<data.response.docs.length; i++) {
				var entity = data.response.docs[i];
				var modifiedEntity = this.activeWorkListDriver.prepareDataForDisplay(entity);
				
				this.options.worklistEntries.workItem[i] = modifiedEntity;
			}
			
			this.activeWorkListDriver.bindEvents();		// Need to rebind events because we just cleared out all the work items.
			this.render();
			
			if(!this.activeWorkListDriver.infiniteScrollInitialized) {
				this.activeWorkListDriver.initializeInfiniteScroll();
			}
			
			this.postFetchWorkItems(data);
		}.bind(this))
		.fail(function() {
			ap.consoleInfo("Failed to save filter.");
		});
	},
	postFetchWorkItems: function(data) {
		// Custom hook to do extra processing, if necessary.
		var numWorkitems = 0;
		if(data != undefined && data.response != undefined && data.response.docs != undefined) {
			numWorkitems = data.response.numFound;
		}
		
		var label = ap.worklist["label.WorkItems"];
		
		if(numWorkitems > 1) {
			label;
		}
		
		$('#num-workitems').text(numWorkitems + ' ' + label);
	},
	open: function() {
		ap.WorkItemList.getWorkItem( this, function(i) {

			$('#action').each(function(i) {
				var elem = $(this);
				var value = elem.val();
				var qstr = ap.WorkItemList._getQueryString(elem.parent());
				if(value == "Open") {
					window.location = 'LaunchWorkItem'+qstr;
					return;
				}
				else if(value == "View") {
					ap.WorkItemList.handleWorkItemActions("View", qstr);
					return;
				}
			});
		});
	},
	
	LaunchWorkItem: function() {
		ap.WorkItemList.getWorkItem( this, function(i) {
			$('#eventWorkItemAction_Open').each(function(i) {
				var qstr = ap.WorkItemList._getQueryString($(this));
				window.location = 'LaunchWorkItem'+qstr;
				return;
			});
		});
	},
	
	getSelectedWorkItem: function(id, callback ) {
		$.each( this.options.worklistEntries.workItem, function( i, val ) {
			if ( val.id == id ) {
				callback.apply( ap.WorkItemList, arguments );
				return false;
			}
		});
	},
	
	LaunchSelectedWorkItem:function(){
		ap.WorkItemList.getSelectedWorkItem( ap.selectedWorkItem , function(i) {
			$('#eventWorkItemAction_Open').each(function(i) {
				var qstr = ap.WorkItemList._getQueryString($(this));
				window.location = 'LaunchWorkItem'+qstr;
				return;
			});
		});
	},
	
	selectWorkItem: function() {
		var triggerCard = $(this).closest('.worklist-item ,.add ');
		
		var id = triggerCard.attr('id'); // Acquire the Work Item Id - 
		
		if(!id){  // Event bubbling to the top - let it return. No Special handling needed. 
			
			return true;
		}
		
		//This function server all the add cards. 
		//since the add behavior is different for add card on worklist and add card on account worklist
		//Worklist add card will not present upload option 
		if(triggerCard.hasClass('show-list')){
			ap.WorkItemList.handleAddActions('show-list');
		}else if(triggerCard.hasClass('add-button')){
			ap.WorkItemList.handleAddActions('add-button');
		}else if(id.match("^add-") ){    // If the ID starts with add-, signifies an add action. Handle the action. 
			return ap.WorkItemList.handleAddActions(id);
		}else{
			// Regular work item click event.
			ap.WorkItemList.getWorkItem( this, function(i) {
				if (this.selectedWorkItem) {
					this.selectedWorkItem.selected = false;
				}
				
				this.selectedWorkItem = this.options.worklistEntries.workItem[i];
				this.selectedWorkItem.selected = true;
				
				if (!this.selectedWorkItem.actions) {
					this.fetchWorkItemActions();
					this.options.worklistEntries.workItem[i] = this.selectedWorkItem;
				}
				
				ap.selectedWorkItem = id;
				ap.selectedWorkItemAccountId = this.options.worklistEntries.workItem[i].account_id;
				ap.selectedWorkItemTransactionId = this.selectedWorkItem.transaction_id;
				ap.csrfToken = this.csrfToken;
				this.render();
			});		
			
			return false;
		}
		

	},

 	handleAddActions : function (id) {
		
		if( id === "add-list"){
			return true;
		}
		if( id === "add-button"){
			 
			$("#add-button").addClass('hidden');
			// Depending on turnstile status, one of the two tiles is shown.
			if(ap.options.WIPMetaData.turnstileEnabled){
				$("#add-turnstile").removeClass('hidden');
			}else{
				$("#add-list").removeClass('hidden');
			}
			
			return false;
		}
		if( id === "add-turnstile"){
			return true;
		}
		/*
		 * Cancel an add event - show the Add buttons.
		 */
		if( id === "cancel-list"){
			$("#add-button").removeClass('hidden');
			$("#add-list").addClass('hidden');
			return false;
		}
		if( id === "show-list"){
			$("#add-button").addClass('hidden');
			$("#add-list").removeClass('hidden');
			$("#add-turnstile").addClass('hidden');
			return false;
		}
			
	},
	
	fetchWorkItemActions: function() {
		var workItem = this.selectedWorkItem;
		var url = 'WorkItemAction?action=GetWorkItemActions&WORKITEMID=';
		url += workItem.id;
		url += '&CSRF_TOKEN=';
		url += this.csrfToken;
		jQuery.ajax(url, {
			type:'post',
			async: false,
			headers: this.params,
			success: function(data,status,jqXHR) {
				workItem.actions = data;
				this.workItemActions = $(data);
			}.bind(this),
			error: function(){
				alert('Unable to retrieve work item actions from the server.') ;
			}
		});
	},
	performWorkItemAction: function(e) {
		var action = $(this).find('input[id="action"]').val();
		var qstr = ap.WorkItemList._getQueryString($(this));
		ap.WorkItemList.handleWorkItemActions(action, qstr);
		e.stopPropagation();
	},	
	/**
	* Handle the requested action.
	*/
	handleWorkItemActions : function(action, qstr) {
			var qstrWithType = qstr + '&WorkListType=WorkItemsView';
			if(action == 'Open') {
				window.location = 'LaunchWorkItem'+qstrWithType;

			}
			
			if (action == 'Delete') {
				ap.workItemDeleteUrl = 'WorkItemAction'+qstrWithType;
				if(ap.workItemDeleteUrl.indexOf("CSRF_TOKEN") < 0){
					ap.workItemDeleteUrl += '&CSRF_TOKEN=' +  this.csrfToken;
				}
				$('#workitem_delete_modal').modal();
			}
			
			if (action == 'Approve') {
				ap.workItemDeleteUrl = 'WorkItemAction'+qstrWithType;
				if(ap.workItemDeleteUrl.indexOf("CSRF_TOKEN") < 0){
					ap.workItemDeleteUrl += '&CSRF_TOKEN=' +  this.csrfToken;
				}
				$('#workitem_approve_modal').modal();
			}
			
			if(action == 'Copy' || action == 'Claim' ) {
				$.ajax({
					url:'WorkItemAction'+qstrWithType,
					dataType: 'json'
				})
					.done(function(data, textStatus, jqXHR) {
						ap.consoleInfo(data);
						var workItemId = data.response[0].newWorkItemId;
						var openMode = data.response[0].openMode;
						
						window.location = "LaunchWorkItem?WORKITEMID=" + workItemId + 
											"&action=Open&openmode=" + openMode + 
											"&WorkListType=WorkItemsView";
					}.bind(this))
					.fail(function() {
						ap.consoleInfo("Failed to complete action of " + action + " on work item.");
					});
				
			}
			if(action == 'Assign') {
				this.getAssignee(qstrWithType);
			}
			
			if(action == 'View') {
				setTimeout(function(){window.location = 'DisplayWorkInProgress'+qstrWithType;}, 0);
			}
			
			if(action == 'Link') {
				$('#move-account-search-input').val('');
				$('#move-account-search-results-listing').html('');
				$('#move-workitem-account-modal').modal();						
				var title = ap.account_management["account.actions.link.workitem"];
				$('#move-account-confirm .modal-title').html(title);	
				$('#move-account-success .modal-title').html(title);
			}
			
			if(action == 'Move'){
				$('#move-workitem-search-input').val('');
				$('#move-workitem-search-results-listing').html('');
				$('#workitem_move_modal').modal();
				var title = ap.account_management["account.actions.move.workitem"];
				$('#move-account-confirm .modal-title').html(title);
				$('#move-account-success .modal-title').html(title);
			}
			if (action == 'Endorse') {
				// Construct the URL
				var workItemId = $("#WORKITEMID").get(0).value;
				var lobCdElem = $("#" + workItemId + "_LOB").get(0);
				var lobCd = "";
				// In card view the lob is read from hidden variable. In classic view, it comes from the column.
				if (lobCdElem){
					lobCd = lobCdElem.value;
				}else{
					lobCd = this.selectedWorkItem.lob;
				}
				var endorseTranid = $("#EndorseTransactionId").get(0).value;
				ap.workItemEndorseUrl = "FrontServlet?";
				ap.workItemEndorseUrl += 'TRANSACTION_NAME=' + endorseTranid;
				ap.workItemEndorseUrl += '&PAGE_NAME=launchPASRequest';
				ap.workItemEndorseUrl += '&METHOD=Display';
				ap.workItemEndorseUrl += '&LOB=' + lobCd; 
				ap.workItemEndorseUrl += '&POLICY_NUMBER=' + workItemId;
				ap.workItemEndorseUrl += '&NEW_PAS_REQUEST=true';
				if(ap.workItemEndorseUrl.indexOf("CSRF_TOKEN") < 0){
					ap.workItemEndorseUrl += '&CSRF_TOKEN=' +  this.csrfToken;
				}
				window.location = ap.workItemEndorseUrl;
			}
	},
	/**
	 * Perform call-out to server to retrieve list of potential assignees.  In the
	 * case of the base implementation, we just pop the modal and provide a text
	 * box for manual assignee entry.
	 * 
	 * @param queryString
	 */
	getAssignee: function(queryString) {
		// Save off the URL for making the assignment.
		ap.workItemAssignUrl = 'WorkItemAction'+queryString;
		
		$('#workitem_assign_modal').modal();
	},
	/**
	 * Perform the actual assignment. This takes the assignee specified and sends a GET
	 * to the server where the work item reassignment will occur.
	 */
	doAssign: function() {
		var assignee = $('#assignee').val();
		var url = ap.workItemAssignUrl.replace("action=Assign", "action=DoAssign") + '&assignee=' + assignee;
		$.ajax({
			url: url,
			dataType: 'json'
		})
			.done(function(data, textStatus, jqXHR) {
				ap.consoleInfo(data);
				var outcome = data.actionResponse[0].outCome;
				if(outcome == "failure") {
					var reason = data.actionResponse[0].reason;
					ap.consoleInfo(reason);
				}
				else {
					var workItemId = data.actionResponse[0].workitemid;
					$('#' + workItemId).fadeOut(1000, function() {
						$(this).remove();
					});
				}
				
				$('#workitem_assign_modal').modal('hide');
			}.bind(this))
			.fail(function() {
				ap.consoleInfo("Failed to assign work item.");
			});
	},
	doDelete: function() {
		$.ajax({
			url: ap.workItemDeleteUrl,
			dataType: 'json'
		})
		.done(function(data, textStatus, jqXHR) {
			ap.consoleInfo(data);
			var status = data.actionResponse[0].outCome;
			if(status == 'failure') {
				ap.consoleInfo( data.actionResponse[0].outCome.reason);
			}
			else {
				var workItemId = data.actionResponse[0].workitemid;
				$('#' + workItemId).fadeOut(1000, function() {
					$(this).remove();
				});
				for(var k in  ap.WorkItemList.options.worklistEntries.workItem) {
					if( ap.WorkItemList.options.worklistEntries.workItem[k].id == workItemId) {
						delete  ap.WorkItemList.options.worklistEntries.workItem[k];
						break;
					}
				}
				ap.WorkItemList.render();
			}
			
			$('#workitem_delete_modal').modal('hide');
		}.bind(this))
		.fail(function() {
			ap.consoleInfo("Failed to copy work item.");
		});
	},
	doApprove: function() {
		$.ajax({
			url: ap.workItemDeleteUrl,
			dataType: 'json'
		})
		.done(function(data, textStatus, jqXHR) {
			var status = data.actionResponse[0].outCome;
			if(status == 'failure') {
				ap.consoleInfo( data.actionResponse[0].outCome.reason);
			}else {
				setTimeout(function(){ap.WorkItemList.fetchWorkItems();}, 1000);
			}
			
			$('#workitem_approve_modal').modal('hide');
		}.bind(this))
		.fail(function() {
			ap.consoleInfo("Failed to approve work item.");
		});
	},
	_getQueryString : function($element) {
		var qstr = '';
		
		$element.find('input[type="hidden"]').each(function(i, hiddenObj){
			if(qstr){
	          qstr =qstr+"&"+hiddenObj.id+"="+hiddenObj.value;
	        }else {
	         	qstr = qstr+"?"+hiddenObj.id+"="+hiddenObj.value;
	        }
		},qstr);

		return qstr;
	}
};


