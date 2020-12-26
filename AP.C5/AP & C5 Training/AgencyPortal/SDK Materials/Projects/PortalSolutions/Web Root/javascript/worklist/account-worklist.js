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

$(document).ready(function() {
	var accountWorkItemList = ap.WorkItemList;
	
	accountWorkItemList.getSolrQuery = function() {
		return "SolrSecurityServlet?q=" +
				ap.searchManager.constructSolrQuery() + 
				"&rows=" + ap.initialWorklistSize + 
				"&index_type=account&rnd=" + new Date().getTime();
	};
	
	accountWorkItemList.postFetchWorkItems = function(data) {
		var numAccounts = 0;
		if(data != undefined && data.response != undefined && data.response.docs != undefined) {
			numAccounts = data.response.numFound;
		}
		
		var label = ap.account_management["label.Accounts"];
		
		if(numAccounts > 1) {
			label;
		}
		
		$('#num-accounts').text(numAccounts + ' ' + label);
	};
	
	accountWorkItemList.selectWorkItem = function() {
		
		var id = $(this).closest('.worklist-item ,.add ').attr('id'); // Acquire the Work Item Id - 
		var csrfToken = $("#CSRF_TOKEN").val(); // Acquire the CSRF Token
		
		if(!id){  // Event bubbling to the top - let it return. No Special handling needed. 
			return true;
		}	
		
		if(id.match("^add-") ){    // If the ID starts with add-, signifies an add action. Handle the action. 
			return ap.WorkItemList.handleAddActions(id);
		}else{
			// Regular work item click event.
			ap.WorkItemList.getWorkItem( this, function(i) {
				if (this.selectedWorkItem) {
					this.selectedWorkItem.selected = false;
				}
				
				this.selectedWorkItem = this.options.worklistEntries.workItem[i];
				this.selectedWorkItem.selected = true;
				
				ap.selectedWorkItem = id;
				ap.csrfToken = csrfToken;

				this.render();
			});		
			
			return false;
		}
	};
	
	accountWorkItemList.getSelectedWorkItem= function(id, callback ) {
		$.each( this.options.worklistEntries.workItem, function( i, val ) {
			if ( val.id == id ) {
				callback.apply( ap.WorkItemList, arguments );
				return false;
			}
		});
	};
	
	accountWorkItemList.LaunchSelectedWorkItem=function(){
		ap.WorkItemList.getSelectedWorkItem( ap.selectedWorkItem , function(i) {
			
			$('#eventWorkItemAction_Open').each(function(i) {
				var url = "DisplayWorkInProgress?action=Open&WorkListType=AccountItemsView&WORKITEMID=" + ap.selectedWorkItem;
				setTimeout(function(){window.location = url;}, 0);
				return;
			});
		});
	};
	/**
	* Handle the requested action.
	*/
	accountWorkItemList.handleWorkItemActions = function(action, qstr) {
		if(action == 'Open') {
			ap.accountSearchMgr.launchAccount(ap.selectedWorkItem,true);

		}
		else if (action == 'Delete') {
			$('#workitem_delete_modal').modal();
		}
	};
	/**
	 * Adding double click open implementation for account worklist in table view.
	 */
	accountWorkItemList.open =  function() {
		ap.WorkItemList.getWorkItem( this, function(i) {

			$('#action').each(function(i) {
				var elem = $(this);
				var value = elem.val();
				var qstr = ap.WorkItemList._getQueryString(elem.parent());
				if(value == "Open" || value == "View" ) {
					 
					ap.WorkItemList.handleWorkItemActions("Open", qstr);
					return;
				} 
			});
		});
	},
	
	accountWorkItemList.handleAddActions = function (id) {
		
		if( id === "add-list"){
			return true;
		}
		if( id === "add-button"){
			 
			$("#add-button").addClass('hidden');
			// Depending on turnstile status, one of the two tiles is shown.
			$("#add-list").removeClass('hidden');
			$("#add-turnstile").addClass('hidden');
			return false;
		}
		if( id === "add-turnstile"){
			return true;
		}
	};
	
	accountWorkItemList.doDelete = function() {
		var csrfToken = $("#CSRF_TOKEN").val();
		$.ajax({
			url: "WorkItemAction",
			data: {
				WorkListType: 'AccountsView',
				action: 'Delete',
				TRANSACTION_NAME: 'account',
				WORKITEMID: ap.selectedWorkItem,
				CSRF_TOKEN: csrfToken
			},
			contentType: 'application/json',
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
					for(var k in accountWorkItemList.options.worklistEntries.workItem) {
						if(accountWorkItemList.options.worklistEntries.workItem[k].id == workItemId) {
							delete accountWorkItemList.options.worklistEntries.workItem[k];
							break;
						}
					}
					
					accountWorkItemList.render();

					var text = $('#num-accounts').text();
					var numAccounts = parseInt(text.match(/[0-9]+/));
					$('#num-accounts').text((numAccounts -1) + ' ' + ap.account_management["label.Account.Accounts"]);
				});
			}
			
			$('#workitem_delete_modal').modal('hide');
		}.bind(this))
		.fail(function() {
			ap.consoleInfo("Failed to delete account.");
		});
	};
	
	accountWorkItemList.LaunchWorkItem = function() {
		ap.WorkItemList.getWorkItem( this, function(i) {
			$('#eventWorkItemAction_Open').each(function(i) {
				var url = "DisplayWorkInProgress?action=Open&WorkListType=AccountItemsView&WORKITEMID=" + ap.selectedWorkItem;
				setTimeout(function(){window.location = url;}, 0);
				return;
			});
		});
	};
});