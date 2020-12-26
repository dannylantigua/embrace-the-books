/** This javascript object adds the link to the nav bar to toggle between 
 *  table and tile worklist layout.  
 * 
 *  Custom worklist layouts would replace this script with something else 
 *  that calls:
 *  
 *  ap.WorkItemList.setActiveWorkListDriver(x);
 *  ap.WorkItemList.render();
 *  
 *  to set up the appropriate worklist UI driver and render the worklist.
 */
$(document).ready(function() {
	var WorkListDefault = {
		init: function() {
			this.cacheElements();
			this.bindEvents();
			var defaultDriver;
			ap.WorkListDriver.forEach(function(driver){
				
				if( driver.type == ap.options.WIPMetaData.defaultDriver)
					defaultDriver = driver;
				
			});
			ap.WorkItemList.setActiveWorkListDriver(defaultDriver);
			ap.WorkItemList.render();
		},
		cacheElements: function() {			
			this.$tileview = $("#tile-view");
			this.$listview = $("#list-view");
		},
		bindEvents: function() {
			
			// Toggle between tiled and table view
			this.$tileview.on('click', this.toggleView );
			this.$listview.on('click', this.toggleView );
		},
		toggleView: function(e) {
			e.stopPropagation();
			ap.consoleInfo("Target=" + e.target.id);
			if (ap.WorkItemList.activeWorkListDriver == ap.WorkItemList_Tiles && this.id == 'list-view') {
				ap.WorkItemList.setActiveWorkListDriver(ap.WorkItemList_Table);
				$("#tile-view").toggleClass("active", false);
				
				$(this).toggleClass("active", true);
				
				ap.WorkItemList.fetchWorkItems();
				
			} else if(ap.WorkItemList.activeWorkListDriver == ap.WorkItemList_Table && this.id == 'tile-view') {
				ap.WorkItemList.setActiveWorkListDriver(ap.WorkItemList_Tiles);
				$("#list-view").toggleClass("active", false);
				
				$(this).toggleClass("active", true);
				
				ap.WorkItemList.fetchWorkItems();
				
			}
		}		
	};
	WorkListDefault.init();
});