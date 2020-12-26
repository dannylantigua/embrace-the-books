<%@ page import="com.agencyport.account.AccountManagementFeature" %>
<%@ page import="com.agencyport.constants.TurnstileConstantsProvider" %>
<%@ page import="com.agencyport.jsp.JSPHelper" %>
<%@ page import="com.agencyport.locale.IResourceBundle" %>
<%@ page import="com.agencyport.locale.ResourceBundleManager" %>
<%@ page import="com.agencyport.locale.ILocaleConstants" %>
<%@ page import="com.agencyport.paging.worklist.IWorkListResults" %>
<%@ page import="com.agencyport.paging.worklist.WorkListHelper"%>
<%@ page import="com.agencyport.utils.AppProperties" %>
<%@ page import="com.agencyport.webshared.IWebsharedConstants" %>
<%@ page import="com.agencyport.webshared.URLBuilder" %>

<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal"%>

<!-- Adding core_prompts resource bundles for JavaScript use -->
<ap:ap_rb_loader rbname="core_prompts" />
<ap:ap_rb_loader rbname="worklist" />

<!-- home/wip.jsp-->
<!--@@apwebapp_specification_version@@-->

<% 
String workListType = request.getParameter("WorkListType");
if(workListType == null) {
	workListType = "";
}

int numberOfVisibleRows = AppProperties.getAppProperties().getIntProperty(WorkListHelper.WORKLIST_NUMBER_OF_VISIBLE_ROWS, 10);
int bufferSize = AppProperties.getAppProperties().getIntProperty(WorkListHelper.WORKLIST_BUFFER_SIZE, 250);

IResourceBundle core_rb = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
IResourceBundle rb = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
int scrollPadding = bufferSize / 2;
String numberOfVisible = request.getParameter("numberOfVisibleRows");
if(null != numberOfVisible){
	numberOfVisibleRows = Integer.parseInt(numberOfVisible);
}
JSPHelper jspHelper = JSPHelper.get(request); 
String worklistId = (String)request.getAttribute(WorkListHelper.WORK_LIST_VIEW_ID);
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

<%
if(AccountManagementFeature.get().isOn() && workListType.equals("AccountsView")) {
%>	
	<section id="upload_menu" style="display: none">
		<div class="container">
			<form class="form-inline upload_menu" role="form">
				<div class="form-group">
					<label for="getStartedUpload"><%=core_rb.getString("label.GetStartedWithUpload")%></label>
					<button type="submit" class="btn btn-primary" placeholder="<%=core_rb.getString("menu.wi.Name.UploadNow")%>" onclick="javascript:launchFileupload()"><%=core_rb.getString("menu.wi.Name.UploadNow")%></button>
				</div>
			</form>
		</div>
	</section>
	<section id="account-search" class="account-section"><div class="container"><jsp:include page="../account/accountSearch.jsp" /></div></section>
	<section id="recent-accounts" class="recent-accounts account-section"><div class="container"><jsp:include page="../account/recentAccounts.jsp" /></div></section>

<% } else { %>

	<div class="container">
		<jsp:include page="../worklist/worklist.jsp">
			<jsp:param name="isAccountWorklist" value="false"/>
		</jsp:include>
	</div>

<% } %>

<jsp:include page="../home/footer.jsp" flush="true" /> 