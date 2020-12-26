<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% 
String csrfToken = JSPHelper.get(request).getCSRFToken();
%>

<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleStringUtils"%>
<%@page import="com.agencyport.account.AccountDetails" %>

<%
	IResourceBundle workItemRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.WORKLIST_BUNDLE);
%>
<script id="work_list_tiles_container_template" type="text/x-handlebars-template">
{{#this}}

	<div class="row worklist-table">
		
		<div class="col-xs-12 col-sm-6 col-md-4" id="add_new_workitem">
			<div class="card add <c:if test="${param.isAccountWorklist == 'true'}">add-button</c:if> <c:if test="${param.isAccountWorklist == 'false'}">show-list</c:if>" id="add-button">
				<div class="add-button">
					<i class="fa fa-plus lob-icon"></i>
					<a><%= workItemRB.getString("action.AddNewWorkItem") %></a>						
				</div>
			</div>	
			<div class="card add hidden" id="add-list">
				<div class="add-list">
					<h3><%= workItemRB.getString("header.Title.SelectLOB") %><button type="button" class="close" aria-hidden="true" onclick="javascript: ap.WorkItemList.handleAddActions('cancel-list');" ><i class="fa"></i></button></h3>
					<ul role="menu">
						{{#each WIPMetaData.lobLinksList}}
							{{#isAccount ../WIPMetaData/account_id}}
								<li onclick="ap.account.createWorkItem(this);" value="{{this.url}}&amp;sourceWorkItemType=2&amp;CSRF_TOKEN=<%=csrfToken%>&amp;WorkListType=">{{this.title}}</li>
							{{else}}
								<li><a href="{{this.url}}">{{this.title}}</a></li>
							{{/isAccount}}
						{{/each}}
					</ul>	
				</div>
			</div>
			<div class="card add hidden" id="add-turnstile">
				<div class="add-turnstile">
				<c:choose>
					<c:when test="${param.isAccountWorklist == 'true'}">
						<a href="#" class="upload" onclick="javascript:ap.turnstileWidget.launchUploadWidget(ap.accountId)"><i class="fa"></i><span class="link"><%= workItemRB.getString("action.UploadForm") %></span></a>
						<a href="#" onclick="javascript: ap.WorkItemList.handleAddActions('show-list');" class="start"><i class="fa"></i><span class="link"><%= workItemRB.getString("action.StartNewWorkItem") %></span></a>
					</c:when>
					<c:otherwise>
						<a href="#" onclick="javascript: ap.WorkItemList.handleAddActions('show-list');" class="start"><i class="fa"></i><span class="link"><%= workItemRB.getString("action.StartNewItem") %></span></a>
					</c:otherwise>
				</c:choose>
				</div>
			</div>
		</div>	

 		{{> list_tiles}}

	</div>
{{/this}}

</script>

<script id="work_list_tiles_template" type="text/x-handlebars-template">
	{{#each worklistEntries.workItem}}
       	<div class="col-xs-12 col-sm-6 col-md-4">
       		<div id="{{id}}" class="card workitem worklist-item {{lob}} card-{{#tolower}}{{after_title}}{{/tolower}}">

				<div class="percentage-color text-center"></div>
				<div class="card-header">
					<span class="{{#tolower}}{{after_title}}{{/tolower}} noaction">{{id}}: {{lob_desc}}
						<span class="badge">{{complete_percent}}%</span>
						{{#if selected}}
							<span id="eventWorkItemAction_Delete" class="delete">
								<i class="fa"></i>
							</span>
							<input type="hidden" value="{{id}}" id="WORKITEMID">
							<input type="hidden" value="{{lob}}" id="{{id}}_LOB">
							<input type="hidden" value="{{transaction_id}}" id="TRANSACTION_NAME">
							<input type="hidden" value="Delete" id="action">
							<ap:csrf />
						{{/if}}
					</span>
				</div>
         		<div class="card-content">
					<i class="fa"></i>					
					<h2>
						<span>{{entity_name}}</span>
						{{#ifCond account_id "-1"}}
							<span class="no-account"><i class="fa"></i></span>
						{{/ifCond}}
					</h2>
					<ul>
						<li>Effective On {{effective_date}}</li>

					{{#ifEquals premium "$.00"}}
    					<li><%= workItemRB.getString("label.WorkList.Premuim") %></li>
					{{else}}
    					<li class="premium">Premium: {{premium}}</li>
					{{/ifEquals}}

						<li>{{transaction_type}}</li>
						<li>{{after_title}}</li>
					</ul>
				</div>

				{{#if selected}}
					<div id="tile-actions" class="row card-actions">
						<div class="card-button">
						{{#if actions}} {{{actions}}} {{/if}}
						</div>
					</div>
				{{/if}}
			
			</div>
		</div>
	{{/each}}
</script>
