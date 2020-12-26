<%@page import="com.agencyport.account.AccountManagementFeature"%>
<%@page import="com.agencyport.account.AccountUtility"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@ page import="com.agencyport.paging.worklist.IWorkListResults"%>
<%@ page import="com.agencyport.paging.worklist.WorkListHelper"%>
<%@ page import="com.agencyport.product.ProductDefinitionsManager"%>
<%@ page import="com.agencyport.utils.AppProperties" %>
<%@ page import="com.agencyport.webshared.IWebsharedConstants" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.List"%>

<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleStringUtils"%>

<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal"%>
<!-- account/recentAccountSearch.jsp-->
<!-- Adding resource bundles for JavaScript use -->
<ap:ap_rb_loader rbname="core_prompts"/>
<ap:ap_rb_loader rbname="account_management"/>

<%
	
	IResourceBundle workListRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.WORKLIST_BUNDLE);
	IResourceBundle accountRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
	IResourceBundle coreRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
	
%>

<div class="modal fade" id="workitem_delete_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
    	<div class="modal-content">
	    	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        	<h2 class="modal-title"><%= accountRB.getString("header.Title.ConfirmAccountDeletion") %></h2>
	      	</div>
			<div class="modal-body">
				<p><%= accountRB.getString("account.actions.delete.warn") %></p>
				<div class="button-row">
					<button type="button" class="btn btn-primary" onclick="ap.WorkItemList.doDelete();"><%= workListRB.getString("modal.confirmation.button.yes") %></button>
					<button type="button" class="btn btn-default" data-dismiss="modal"><%= workListRB.getString("modal.confirmation.button.no") %>  </button>
				</div>
			</div>
    	</div>
  	</div>
</div>

<section id="worklist_contents_section" class="worklist-section">
	<div class="container">
		<div id="work_list_contents"></div>
	</div>
</section>

<div style="display:none" id="results_nav">
	<a id="results_nav_next" href="page2""><%= coreRB.getString("action.Next") %></a>
</div>

<!-- Handlebars templates for html rendering of the worklist on the client-side -->
<%-- <jsp:include page="../worklist/handlebars/work_list_delete.jsp" flush="true"/> --%>
<jsp:include page="../worklist/handlebars/account-worklist-table.jsp" flush="true"/>
<jsp:include page="../worklist/handlebars/account-worklist-card.jsp" flush="true">
	<jsp:param name="isAccountWorklist" value="recentaccounts"/>
</jsp:include>


 
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/worklist.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/account-worklist.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/worklist-table.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/account-worklist-table.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/worklist-card.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/account-worklist-card.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/worklist-switcher.js"></script>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/filter-manager.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/account-filter-manager.js"></script>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/search-manager.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/worklist/account-search-manager.js"></script>

<script type="text/javascript">
	$(function() {
		var searchBoxId = 'account_searchInput';

		ap.accountSearchMgr = new ap.AccountSearchManager();
		ap.account = new ap.Account();
		ap.searchManager = SearchManager;
		SearchManager.initialize({
			filterManager: ap.filterManager,
			searchBoxId: searchBoxId,
			solrUrl: ap.options.worklistEntries.solr_select_url,
			indexType: "account",
			typeHeadSetup: "true"
		});
		FilterManager.initialize({
			activeFiltersDivId: "active_filters_display",
			searchBoxId: searchBoxId,
			filterBaseUrl: "",
			entityTemplateId: 'work_list_tiles_template',
			filterType: "account"
		});
		
	});
	
	
</script>
