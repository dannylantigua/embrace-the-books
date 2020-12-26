<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.agencyport.webshared.URLBuilder"%>
<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>
 <%
 JSPHelper jspHelper = JSPHelper.get(request);
 Map<String, String> persAccount = new HashMap<String, String>();
 persAccount.put("account_type", "P");
 Map<String, String> commlAccount = new HashMap<String, String>();
 commlAccount.put("account_type", "C");

 %>
 
 <%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleStringUtils"%>
<%@page import="com.agencyport.account.AccountDetails" %>

<%
	IResourceBundle accountRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
%>

<script id="work_list_tiles_container_template" type="text/x-handlebars-template">
{{#this}}

	<div class="row worklist-table">
		
		<div class="col-xs-12 col-sm-6 col-md-4" id="add_new_workitem">
			<div class="card add" id="add-button">
				<div class="add-button">
					<i class="fa"></i>
					<a onclick="javascript: ap.WorkItemList.handleAddActions('add-button');"><%= accountRB.getString("action.AddNewAccount") %></a>
				</div>
			</div>	
			<div class="card add hidden" id="add-list">
				<div class="add-account">
					<a href="<%=URLBuilder.buildFrontServletURL(-1, null, Boolean.TRUE.toString(), "account", URLBuilder.DISPLAY_METHOD, false, commlAccount)%>" class="add-commercial"><i class="fa"></i><span class="link"><%= accountRB.getString("label.Account.Commercial") %></span></a>
					<a href="<%=URLBuilder.buildFrontServletURL(-1, null, Boolean.TRUE.toString(), "account", URLBuilder.DISPLAY_METHOD, false, persAccount)%>" class="add-personal"><i class="fa"></i><span class="link"><%= accountRB.getString("label.Account.Personal") %></span></a>
				</div>
			</div>
		</div>	
		
 		{{> list_tiles}}

	</div>

{{/this}}

</script>
 

<script id="work_list_tiles_template" type="text/x-handlebars-template">
	{{#each worklistEntries.workItem}}
       	<div class="col-xs-12 col-sm-6 col-md-4 {{account_type}}">
					<div id="{{id}}" class="card account worklist-item {{account_type}}">										
						<span class="lob-icon noaction">
							<i class="fa"></i>
						</span>
						
						{{#if selected}}
						<span id="eventWorkItemAction_Delete">
							<i class="fa"></i>
							<span></span>
							<input type="hidden" value="{{id}}" id="WORKITEMID">
							<input type="hidden" value="account" id="TRANSACTION_NAME">
							<input type="hidden" value="Delete" id="action">
							<ap:csrf />
						</span>
						{{/if}}
						
						<ul>
							{{#ifCond entity_name ""}}
								<li class="entity_name">{{other_name}}</li>
							{{else}}
								<li class="other_name">{{entity_name}}</li>
							{{/ifCond}} 
							
							<li class="type">{{mapValue account_type 'Type'}}</li>
							<li class="account-number">{{account_number}}</li>
							<li class="address">{{city}}, {{state_prov_cd}} {{postal_code}}</li>
						</ul>
						
						{{#if selected}}
						<div class="row card-actions" id="card-actions">
							<div class="worklist-card-button">
								<span id="eventWorkItemAction_Open" class="worklist-actions action btn btn-default" title="Open" onclick="javascript: ap.accountSearchMgr.launchAccount(ap.selectedWorkItem,true);" onmouseover="return true;">
									<span><%= accountRB.getString("action.Open") %></span>
								</span>		
								<span id="eventWorkItemAction_Delete" class="worklist-actions action btn btn-default" title="Delete" onclick="javascript:ap.WorkItemList.handleWorkItemActions('Delete');" onmouseover="return true;"> 
									<span></span>
									<span><%= accountRB.getString("action.Delete") %></span>
									<input type="hidden" value="{{id}}" id="WORKITEMID">
									<input type="hidden" value="account" id="TRANSACTION_NAME">
									<input type="hidden" value="Delete" id="action">
									<ap:csrf />
								</span>
							</div>
						</div>
						{{/if}}
					</div>	
				</div>
	{{/each}}
</script>
