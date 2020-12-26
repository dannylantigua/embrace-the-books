<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%@ page import="com.agencyport.jsp.JSPHelper, 
	com.agencyport.trandef.Transaction,
	com.agencyport.account.AccountUtility,
	com.agencyport.constants.TurnstileConstantsProvider,
	com.agencyport.trandef.TransactionDefinitionManager,
	com.agencyport.account.AccountDetails,
	com.agencyport.utils.AppProperties,
	com.agencyport.trandef.Transaction,
	com.agencyport.product.ProductDefinitionsManager,
	java.util.Hashtable,java.util.Iterator,
	com.agencyport.fieldvalidation.validators.BaseValidator,
	com.agencyport.database.locking.RecordLockStatus,
	com.agencyport.paging.worklist.IWorkListResults,
	com.agencyport.paging.worklist.WorkListHelper,
	com.agencyport.webshared.IWebsharedConstants"%>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.shared.locale.ISharedLocaleConstants"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>

<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal"%>

<!-- Adding core_prompts resource bundle for JavaScript use -->
<ap:ap_rb_loader rbname="core_prompts" />

<%
	IResourceBundle accountRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
	IResourceBundle rb = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
	JSPHelper jspHelper = JSPHelper.get(request);
	AccountDetails details = (AccountDetails) request.getAttribute("accountDetails");
	Transaction tran = TransactionDefinitionManager.getTransaction(details.getAccountTransactionId());
	String javascriptValidation = AccountUtility.buildClientValidationFunction();
	String nextpage = request.getContextPath();
	nextpage += AppProperties.getAppProperties().getStringProperty("application.account.delete.nextpage", "/DisplayWorkInProgress?WorkListType=AccountsView");
	Hashtable accountHolderLocationParams = (Hashtable) request.getAttribute("LOCATION_PARAMS");
	String originUrl = request.getParameter("origin");
	
	String accountName = JSPHelper.prepareForJavaScript(details.getAccountName());
	
	boolean supportActionM = AppProperties.getAppProperties().getBooleanProperty("application.account.management.support.merge");
	RecordLockStatus recordLockStatus = details.getRecordLockStatus();
	String versionNumber= ProductDefinitionsManager.getCurrentlyRunningVersion().toString();

	String updateInterval = jspHelper.getClientUpdateInterval();
	if(!jspHelper.isWorkItemLockSupported()){
		updateInterval = "0";
	}
	
	
	String worklistId = (String)request.getAttribute(WorkListHelper.WORK_LIST_VIEW_ID);
	
	int numberOfVisibleRows = AppProperties.getAppProperties().getIntProperty(WorkListHelper.WORKLIST_NUMBER_OF_VISIBLE_ROWS, 10);
	int bufferSize = AppProperties.getAppProperties().getIntProperty(WorkListHelper.WORKLIST_BUFFER_SIZE, 250);
	int scrollPadding = bufferSize / 2;
	String filterXML = (String)request.getAttribute(IWebsharedConstants.FILTER_XML + worklistId);
%>

<script type="text/javascript" src="javascript/worklist/worklist-data-init.js" language="javascript"></script>
<script type="text/javascript" language="javascript">
if(typeof(ap) == 'undefined') {
    var ap ={};
}
ap.options = {
		bufferSize:<%=bufferSize%>,
		scrollPadding:<%=scrollPadding%>,
		numberVisibleOfRows:<%=numberOfVisibleRows%>,
		nameSpace: '${nameSpace}',
		filterXML: '<%=filterXML%>',
		csrfToken: '<%=jspHelper.getCSRFToken()%>',
		WIPMetaData: eval(<%=(String)request.getAttribute(WorkListHelper.WIP_META_DATA)%>)
	};
	
$(function() {
	ap.options.worklistEntries = {}
	ap.options.WIPMetaData.defaultDriver = 'tiles';
	initWorklistData(ap.options);
	ap.WorkItemList = WorkItemList;
	ap.WorkItemList.init(ap.options);
});
</script>

<script src="${pageContext.request.contextPath}/javascript/worklist/worklist.js"></script>
<script src="${pageContext.request.contextPath}/javascript/worklist/filter-manager.js"></script>
<script src="${pageContext.request.contextPath}/javascript/worklist/search-manager.js"></script>
<script src="${pageContext.request.contextPath}/javascript/worklist/worklist-table.js"></script>

<section class="account_body account-section" id="page_body">
	<div class="container">	
		<jsp:include page="message.jsp"></jsp:include>
		<jsp:include page="confirmAccountDelete.jsp"/>
		<jsp:include page="accountActionMessage.jsp"/>
		<jsp:include page="mergeAccounts.jsp"/>
		<!-- progress bar -->

		<div id="pleaseWait">
			<div class="progress progress-striped please-wait active invisible" data-spy="affix" data-offset-top="60">
				<div class="progress-bar" role="progressbar" style="width: 100%">
					<span><%=rb.getString("message.PleaseWait")%>...</span>
				</div>
			</div>
		</div>
		<div class="account-details">

			<% if(!BaseValidator.checkIsEmpty(originUrl)){ %>
			<p class="backtosearch"><a href="javascript: ap.accountSearchMgr.backToSearch('<%=originUrl%>')"><%= accountRB.getString("label.AccountDetails.BackToSearchResults") %></a></p>
			<% } %>

			<div class="header">
				<h2><%= accountRB.getString("header.Title.AccountInformation") %></h2>
				<ul class="pull-right controls" role="menu">
					<li value="editaccount" class="edit-account"><a href="<%=details.getAccountEditLink() %>" title="${ACCOUNT_MANAGEMENT_RB['account.management.editAccount']}"><i class="fa"></i><span>${ACCOUNT_MANAGEMENT_RB['account.management.editAccount']}</span></a></li>
					<% if (!jspHelper.getRecordLockStatus().equals(RecordLockStatus.LOCKED_BY_OTHER_USER)){ %>
					<li value="mergeaccount" class="merge-account"><a onclick="ap.account.handleAccountActions('mergeaccount')" href="#" title="${ACCOUNT_MANAGEMENT_RB['account.actions.merge.account']}"><i class="fa"></i><span>${ACCOUNT_MANAGEMENT_RB['account.actions.merge.account']}</span></a></li>
					<li value="deleteaccount" class="delete-account"><a onclick="ap.account.handleAccountActions('deleteaccount')" href="#" title="${ACCOUNT_MANAGEMENT_RB['account.actions.delete']}"><i class="fa"></i><span>${ACCOUNT_MANAGEMENT_RB['account.actions.delete']}</span></a></li>
					<%}%>
				</ul>
			</div>								
			<jsp:include page="accountSummary.jsp" />
			
		</div>
	</div>
</section>
	
<section id="account_detail" class="account-section">
	<div class="container">
		<div class="col-md-12" >
			<div id="move_work_item_container" class="move-work-item" style="display:none;">
				<jsp:include page="moveWorkItems.jsp"/>
			</div>
			<form action="FrontServlet" id="accountForm" name="accountForm" method="post" class="account-form form-horizontal">		
				<input type="hidden" name="TRANSACTION_NAME" id="TRANSACTION_NAME" value="<%=tran.getId()%>" />
				<input type="hidden" name="WORKITEMID" id="WORKITEMID" value="<%=details.getAccountId().toString()%>">
				<ap:csrf />
				<div id="account_details_container">
					<ul class="nav nav-tabs" id="myTab">
						<li class="active"><a onclick="ap.filterManager.applyFilters()"  data-toggle="tab" href="#workitems">${ACCOUNT_MANAGEMENT_RB['account.management.workitem']}</a></li>
						<li class=""><a onclick="ap.account.loadRoster('location')" data-toggle="tab" href="#location">${ACCOUNT_MANAGEMENT_RB['account.management.location']}</a></li>
						<li class=""><a onclick="ap.account.loadRoster('people')" data-toggle="tab" href="#people">${ACCOUNT_MANAGEMENT_RB['account.management.contact']}</a></li>
					</ul>
					<div class="tab-content" id="myTabContent">
						<div id="workitems" class="tab-pane fade active in">
							<jsp:include page="../worklist/worklist.jsp" >
								<jsp:param name="isAccountWorklist" value="true"/>
							</jsp:include>
						</div>
						<div id="location" class="tab-pane fade tab-white-background">
							<div id="account_locations" class="account_locations"></div>
						</div>
						<div id="people" class="tab-pane fade tab-white-background">
							<div id="account_contacts" class="account_contacts"></div>
						</div>
					</div>
				</div>
			</form>
		</div>	
	</div>
</section>

<script type="text/javascript">

	var transaction = new ap.Transaction();
	ap.transaction = transaction;

	transaction.setId('<%=tran.getId()%>');
	transaction.setTitle('<%=tran.getTitle()%>');
	transaction.setTarget('<%=tran.getTarget()%>'); //root target node per the TDF
	transaction.setLob('<%=tran.getLob()%>'); //LOB Code per the TDF
	transaction.setType('<%=tran.getType()%>'); //transaction type per the TDF;
	transaction.setFirstTime(false); // set first time flag
	transaction.setWorkItemId('<%=details.getAccountId().toString()%>');
	
	var page = new ap.Page();
	page.setBody();
	page.initializeForm(document.forms['accountForm']);
	page.form.id='accountForm';
	ap.page = page;
	<%=javascriptValidation %>
	try {
		ap.ValidationLibrary = ValidationLibrary;
		ap.validationLibrary = validationLibrary;
	}catch (e) {}
	
	var account = new ap.Account();
	ap.account = account;
	ap.account.init('${accountDetails.accountId}', '${accountDetails.accountNumber}', '${accountDetails.accountTransactionId}', 
		'<%=details.getAccountType() %>', "<%=accountName %>", "<%=updateInterval%>", '<%=jspHelper.getCSRFToken()%>');	
	ap.account.setAccountDeleteTarget('<%= nextpage %>');
  	ap.account.setRecordLockStatus('<%=recordLockStatus.name()%>');
  	ap.account.setCanMergeWithOtherType(${accountDetails.canMergeWithOtherType});
  	<%if(null != accountHolderLocationParams){
  		for(Iterator<String> it = accountHolderLocationParams.keySet().iterator(); it.hasNext();){
  			String key = it.next();
  			String value = (String)accountHolderLocationParams.get(key);
  	%>
  		ap.account.setAccountHolderAddressFieldParam('<%=key%>', '<%=JSPHelper.prepareForJavaScript(value)%>');
  	<%
  		}
  	}%>
  	
 	ap.account.startWorkItemLock();	
	ap.modalAccountSearchManager = new ap.ModalAccountSearchManager('merge-account-search-input', 'merge-account-search-button', 'merge-account-search-results-listing', ap.MergeManager.selectAccount, true);

</script>	

<%
	if (Transaction.getClientDebugFlag()) {%>
		<ap:ap_debug/>
	<%}
%>	

<jsp:include page="../home/footer.jsp" flush="true" />