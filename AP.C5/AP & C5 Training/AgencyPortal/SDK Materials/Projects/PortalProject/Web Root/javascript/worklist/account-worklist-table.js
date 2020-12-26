/** Worklist UI component driver for the table layout
 * 
 *  This object is responsible for binding/unbinding table-specific events
 *  as well as compiling the appropriate handlebars template and executing
 *  it on demand.
 */
$(document).ready(function() {
	ap.WorkItemList_Table.prepareDataForDisplay = function(data) {
		var entity = {};
		for(var key in data) {
			entity[key] = data[key];
		}
		
		// Last update time
		var lastUpdate = data.last_update_time.replace('Z', '');
		var lastUpateParts = lastUpdate.substring(0,10).split('-');
		entity.last_update_time = lastUpateParts[1] + "-" + lastUpateParts[2] + "-" + lastUpateParts[0] +  " " + lastUpdate.substring(11);

		return entity;
	};
});
