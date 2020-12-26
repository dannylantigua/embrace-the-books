/**
 * 
 */
function initWorklistData(options) {
	/**
	 * Extract transaction information from the JSON.
	 */
	var lobToTransactionName = {};
	var transactionFirstPages = {};
	var transactionUrls = [];
	for(var transactionId in options.WIPMetaData.transaction_data) {
		var tranData = options.WIPMetaData.transaction_data[transactionId];
		var lob = options.WIPMetaData.transaction_data[transactionId]["lob"];
		var firstPage = options.WIPMetaData.transaction_data[transactionId]["first_page"];
		var type = options.WIPMetaData.transaction_data[transactionId]["type"];
		var title = options.WIPMetaData.transaction_data[transactionId]["title"];
		var lobDescription = options.WIPMetaData.transaction_data[transactionId]["lob_description"];
		
		lobToTransactionName[lob + "_" + title] = transactionId;
		transactionFirstPages[transactionId] = firstPage;
		transactionUrls.push({
			url: 'FrontServlet?PAGE_NAME=' + firstPage + '&TRANSACTION_NAME=' + transactionId + '&FIRST_TIME=true&METHOD=Display',
			title: lobDescription + ' ' + title
		});
	}
	
	ap.lobToTransactionName = lobToTransactionName;
	ap.transactionFirstPages = transactionFirstPages;
	
	options.transactionUrls = transactionUrls;
	
	/**
	 * Extract status code information from the JSON.
	 */
	ap.statusCodes = options.WIPMetaData.status_data;
	
	/**
	 * Extract the initial number of worklist entries to fetch.
	 */
	ap.initialWorklistSize = options.WIPMetaData.initial_worklist_size;
	
	/**
	 * Extract the number of worklist entries to fetch on each infinite scroll invocation.
	 */
	ap.workListFetchSize = options.WIPMetaData.worklist_fetch_size;
	
	/**
	 * Extract the reference account id, if it exists.
	 */
	ap.accountId = options.WIPMetaData.account_id;
}