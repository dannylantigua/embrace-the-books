// Setup ap namespace if not already defined.
if(typeof(ap) == 'undefined') {
    var ap ={};
}

FilterManager.hasAssociatedFilter = function(filterName) {
	return filterName == "type";
};

FilterManager.renderActiveFilterIndicators = function(container) {
	container.empty();
	
	if(this.filter[this.filterType] === undefined || this.filter[this.filterType].type === undefined) {
		container.append("<span class='filter-button showing-all'>" + ap.account_management['label.Account.ShowingAllAccounts'] + "</span>");
		return;
	}
	
	if(this.filter[this.filterType] !== undefined && this.filter[this.filterType].type !== undefined){
		for(var i=0; i<this.filter[this.filterType].type.length; i++) {
			var badgeId = "filterbadge_" + this.filter[this.filterType].type[i];
			var badgeValue = this.filterData["type"][this.filter[this.filterType].type[i]];
			container.append("<div id='" + badgeId + "' class='filter-button'>" + "<button class='close filter-close' onclick='ap.filterManager.removeFilter(\"type\"," + i + ", \"" + badgeId + "\");'><i class=\"fa\"></i></button>" + badgeValue + "</div>");
		}
	}
	this.customRenderActiveFilterIndicators(container);
};
