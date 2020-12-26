<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="com.agencyport.constants.TurnstileConstantsProvider" %>
<%@ page import="com.agencyport.account.AccountManagementFeature" %>
<%@ page import="com.agencyport.utils.AppProperties" %>
<%@ page import="com.agencyport.paging.worklist.WorkListHelper"%>
<%@ page import="com.agencyport.webshared.IWebsharedConstants" %>
<%@ page import="com.agencyport.paging.worklist.IWorkListResults"%>
<%@ page import="com.agencyport.jsp.JSPHelper" %>
<%@ page import="com.agencyport.locale.IResourceBundle" %>
<%@ page import="com.agencyport.locale.ResourceBundleManager" %>
<%@ page import="com.agencyport.locale.ILocaleConstants" %>
<%@page import="com.agencyport.paging.worklist.IColumnMetaData"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%
	
	String quotebox = request.getParameter("quotebox");
	if(null == quotebox ){
		quotebox =  "";
	}
	String worklistId = (String)request.getAttribute(WorkListHelper.WORK_LIST_VIEW_ID);
	String filterXML = (String)request.getAttribute(IWebsharedConstants.FILTER_XML + worklistId);	
	
	JSPHelper jspHelper = JSPHelper.get(request); 
		
	String searchParam = (request.getParameter("query") == null) ? "" : request.getParameter("query");
	
	IResourceBundle workItemRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.WORKLIST_BUNDLE);
	IResourceBundle accountRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
	IResourceBundle coreRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
	
	List<IColumnMetaData> columnMetaData  = (List<IColumnMetaData>) request.getAttribute(WorkListHelper.ColumnMetadata);
%>
<ap:ap_rb_loader rbname="worklist" />
<ap:ap_rb_loader rbname="account_management"/>
<div class="modal fade" id="workitem_assign_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
    	<div class="modal-content">
	    	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        	<h2 class="modal-title"><%= workItemRB.getString("header.Title.AssignThisWorkItem") %></h2>
	      	</div>
			<div class="modal-body">
				<form role="form">
					<div class="form-horizontal">
						<div class="form-group">
							<label for="assignee" id="assignee_label" class="col-sm-3 control-label"><%= workItemRB.getString("label.Assignee") %></label>
							<div class="col-sm-9"><input type="text" class="form-control" id="assignee"/></div>
						</div>
					</div>
				</form>
				<div class="button-row">
					<button type="button" class="btn btn-primary" onclick="ap.WorkItemList.doAssign();"><%= workItemRB.getString("action.WorkItem.canAssign") %></button>
				</div>
			</div>
    	</div>
  	</div>
</div>

<div class="modal fade" id="workitem_delete_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
    	<div class="modal-content">
	    	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        	<h2 class="modal-title"><%= workItemRB.getString("header.Title.DeleteThisWorkItem") %></h2>
	      	</div>
			<div class="modal-body">
				<p><%= workItemRB.getString("action.WorkItem.canConfirm") %></p>
				<div class="button-row">
        			<button type="button" class="btn btn-primary" onclick="ap.WorkItemList.doDelete();"><%= workItemRB.getString("modal.confirmation.button.yes") %></button>
					<button type="button" class="btn btn-default" data-dismiss="modal"><%= workItemRB.getString("modal.confirmation.button.no") %>  </button>
				</div>
			</div>
    	</div>
  	</div>
</div>

<div class="modal fade" id="workitem_approve_modal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
    	<div class="modal-content">
	    	<div class="modal-header">
	        	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	        	<h2 class="modal-title"><%= workItemRB.getString("header.Title.approveThisWorkItem") %></h2>
	      	</div>
			<div class="modal-body">
				<p><%= workItemRB.getString("message.WorkList.approve") %></p>
				<div class="button-row">
        			<button type="button" class="btn btn-primary" onclick="ap.WorkItemList.doApprove();"><%= workItemRB.getString("action.WorkItem.canApprove") %></button>
				</div>
			</div>
    	</div>
  	</div>
</div>


<section id="worklist_search_section" class="worklist-section">
	<div id="lb_workitem_locked" class="lightbox_panel" style="display: none">
		<div id="readOnlyMessage">
			<p><%= workItemRB.getString("account.management.pendingupload.locked") %></p>
		</div>
	</div>
	<div id="search_filter" class="search-filter">
		<div class="row">
			<div id="messages" class="col-xs-12">
				<div id="error_msg" class="alert alert-error" style="display:none"></div>
				<div id="success_msg" class="alert alert-success" style="display:none"></div>
				<div id="info_msg" class="alert alert-info" style="display:none"></div>		
			</div>
		</div>
		<div class="row filter-row">
			<div id="filter" class="hidden-xs hidden-sm col-md-10 input-append animated fadeIn filter-controls">
				<div class="btn-group">
					<button type="button" class="btn btn-default filter-counter" id="num-workitems"></button>
					<div class="btn-group">
						<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							<%= workItemRB.getString("action.lob") %> <span class="caret"></span>
						</button>
						<ul class="dropdown-menu filter-selector filter-lob" id="filter_lob">
						</ul>
					</div>
					<div class="btn-group">
						<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							<%= workItemRB.getString("action.Status") %> <span class="caret"></span>
						</button>
						<ul class="dropdown-menu filter-selector filter-status" id="filter_work_item_status">
						</ul>
					</div>
					<div class="btn-group">
						<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							<%= workItemRB.getString("action.Transaction") %> <span class="caret"></span>
						</button>
						<ul class="dropdown-menu filter-selector filter-transaction" id="filter_transaction">
						</ul>
					</div>
					<div class="btn-group sort-by">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><%=accountRB.getString("label.Account.SortBy") %> <b class="caret"></b></button>	
						<ul class="dropdown-menu" role="menu">
							<input type="hidden" id="sortresults" value="last_update_time desc" />
                            
                           <% for(IColumnMetaData column : columnMetaData) {
                                if(column.isSortingEnabled()) {%>
                                    <li class="<%=column.getColumnName()%>">
                                        <a href="#" onclick="ap.WorkItemList_Table.sort(this, '<%=(column.isIdentityColumn()) ? "id" : column.getColumnName() %>')">
                                            <%=column.getColumnTitle()%>
                                        </a>
                                    </li>
                                <%}
                           }%>
						</ul>
					</div>
				
				    <div id="worklist_advanced_search_div" class="btn-group dropdown advanced-search-div">
						<button class="btn btn-default dropdown-toggle advanced-search" type="button" id="dropdown-advanced" data-toggle="dropdown">
							<%=accountRB.getString("label.SearchResults.AdvancedSearch") %>
							<span class="caret"></span>
						</button>
						<div class="dropdown-menu" role="menu" aria-labelledby="dropdown-advanced">
							<form role="form" id="advancedDropDown" class="advanced dropdown-advanced">
							   <div class="error-message">
									<p id="workitem_error_msg_advanced_search" style="display:none"></p>
								</div>
								<div class="form-group">
									<label for="workItemId"><%=workItemRB.getString("worklist.label.workItemId", "Work Item ID")%></label>
									<input type="text" class="form-control" id="workItemId" name="workItemId">
								</div>
								<div class="form-group form-inline">
									<div class=" effective-date">
										<label for="start_date"><%=workItemRB.getString("worklist.label.effectiveDate", "Effective Date")%></label>
										
										<div class="form-group">	
											<select class="form-control" id="date_operator">
												<option value="after"> <%=workItemRB.getString("operator.WorkList.After", "After")%> </option>
												<option value="before"> <%=workItemRB.getString("operator.WorkList.Before", "Before")%> </option>
												<option value="between"> <%=workItemRB.getString("operator.WorkList.Between", "Between")%> </option>
												<option value="on"> <%=workItemRB.getString("operator.WorkList.on", "On")%> </option>									
											</select>
										</div>
										
										<div class="form-group start-date">
											<span class="has-addon">
												<div class="input-group date">
													<input id="start_date" name="start_date" size="10" maxlength="10" value="" type="text" class="form-control" />
													<span class="input-group-addon"><i class="fa"></i></span>
												</div>
											</span>
										</div>
									
										<div class="form-group end-date" id="end_date_div">
											<span class="has-addon">
												<div class="input-group date">
													<input id="end_date" name="end_date" size="10" maxlength="10" value="" type="text" class="form-control" />
													<span class="input-group-addon"><i class="fa"></i></span>
												</div>
											</span>
										</div>								
									</div>
								</div>
								<div class="form-group">
									<button onclick="javascript:ap.searchManager.validateAndFetchWorkItems();" class="btn btn-primary" id="searchBtn" name="searchBtn" type="button"><%= workItemRB.getString("worklist.label.search") %></button>
								</div>
							</form>
						</div>
					</div>				
				</div>
			</div>
	
			<div id="switch" class="hidden-xs hidden-sm col-md-2 animated fadeIn">
				<div id="switch-options" class="switch-options btn-group pull-right">
					<a id="tile-view" class="card-view btn btn-default active"><i class="fa"></i></a>				
					<a id="list-view" class="list-view btn btn-default"><i class="fa"></i></a>
				</div>    			
			</div>
		</div>
		<div class="row active-filters-display" id="active_filters_display"></div>
		
		<div class="row search-bar">
			<div class="search-field" id="search">
				<div class="input-group search" id="search">
					<input id="search-box" type="text" class="form-control" autocomplete="off" placeholder="Search for a customer by name (3 character minimum)" />
				</div>	
			</div>
		</div>
	</div>
</section>

<section id="worklist_contents_section" class="worklist-section">
	<div class="container">
		<div id="work_list_contents"></div>
	</div>
</section>

<div style="display:none" id="results_nav">
	<a id="results_nav_next" href="page2"><%= workItemRB.getString("action.Next") %></a>
</div>

<!-- Handlebars templates for html rendering of the worklist on the client-side -->
<%-- <jsp:include page="../worklist/handlebars/work_list_delete.jsp" flush="true"/> --%>
<jsp:include page="../worklist/handlebars/worklist-table.jsp" flush="true"/>
<jsp:include page="../worklist/handlebars/worklist-card.jsp" flush="true">
	<jsp:param name="isAccountWorklist" value="${param.isAccountWorklist}"/>
</jsp:include>
 
<script src="${pageContext.request.contextPath}/javascript/worklist/worklist-card.js"></script>
<script src="${pageContext.request.contextPath}/javascript/worklist/worklist-switcher.js"></script>
<script type="text/javascript">

$(function() {
	var searchBoxId = 'search-box';
	ap.searchManager = SearchManager;
	SearchManager.initialize({
		filterManager: ap.filterManager,
		searchBoxId: searchBoxId,
		solrUrl: ap.options.WIPMetaData.solr_select_url,
		indexType: "worklist",
		autoSuggestCount:-1
	});
	ap.filterManager.initialize({
		activeFiltersDivId: "active_filters_display",
		searchBoxId: searchBoxId,
		filterBaseUrl: "",
		entityTemplateId: 'work_list_tiles_template',
		filterType: "worklist",
		quotebox: '<%=quotebox%>'
	});
	
	/* ap.filterManager = filterManager; */
	
	ap.searchManager.initializeAdvancedSearch();
	
});
</script>

<jsp:include page="../worklist/move-workitem.jsp" flush="true" />
