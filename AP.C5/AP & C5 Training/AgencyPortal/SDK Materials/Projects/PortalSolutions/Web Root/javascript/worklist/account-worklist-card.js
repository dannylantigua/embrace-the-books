/** Worklist UI component driver for the tiled layout
 * 
 *  This object is responsible for binding/unbinding tile-specific events
 *  as well as compiling the appropriate handlebars template and executing
 *  it on demand.
 */
$(document).ready(function() {
	ap.WorkItemList_Tiles.prepareDataForDisplay = function(data) {
		var entity = {
				id: data.id,
				account_type: data.account_type,
				firstName: data.firstName,
				lastName: data.lastName,
				other_name: data.other_name,
				account_number: data.account_number,
				address: data.address,
				city: data.city,
				state_prov_cd: data.state_prov_cd,
				entity_name: data.entity_name,
				postal_code: data.postal_code
			};
		
		// Last update time
		var lastUpdate = data.last_update_time.replace('Z', '');
		var lastUpateParts = lastUpdate.substring(0,10).split('-');
		entity.last_update_time = lastUpateParts[1] + "-" + lastUpateParts[2] + "-" + lastUpateParts[0] +  " " + lastUpdate.substring(11);

		return entity;
	};
});
