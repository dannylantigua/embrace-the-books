<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleStringUtils"%>
<%@page import="com.agencyport.account.AccountDetails" %>

<%
	IResourceBundle coreRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
%>
<script id="work_list_table_template" type="text/x-handlebars-template">
{{#this}}
<div class="padded-box">
	<div class="row">
		<div class="table-responsive col-xs-12">
			<table id="work_list_table" summary="A work list" class="table table-border table-hover table-striped work-list">
				<thead>
					{{#each WIPMetaData.columnMetaData.columns.column}}
                        {{#if displayColumn}}
                            <th class="columnHeader worklistdata-{{name}}" id="columnHeader_{{number}}">

                                {{#if sortEnabled}} 
                                    <a href="#" onclick="ap.WorkItemList_Table.sort(this, '{{#if isIdentityColumn}}id{{else}}{{name}}{{/if}}')"> 
                                {{/if}}

                                <div class="columnName gainlayout" id="headerDiv_{{number}}">
                                    <input type="hidden" id="columnName" value="{{name}}" />
                                    <input type="hidden" id="columnNumber" value="{{number}}" />
                                    {{title}}
                                </div>

                                {{#if sortEnabled}} 
                                    </a> 
                                {{/if}}

                            </th>
                        {{/if}}
                    {{/each}}
				</thead>
				<tbody id="work_list_table_body">
					{{#each worklistEntries.workItem}}

                        <tr id="{{id}}" class="{{lob}} worklist-item worklistrow {{#if selected}}selected info{{/if}}">

                            {{#getCellData this}}
                                <td class="{{styleClass}}">
                                    <div title="{{title}}">
                                        {{mapValue value title}}
                                    </div> 
                                </td>
                            {{/getCellData}}

                        </tr>

                            {{#if selected}}
                                <tr class="worklistactions">
                                    <td>
                                        <span id="eventWorkItemAction_Open" class="work_list_action action btn btn-default" title="Open" onmouseover="return true;">
                                            <span><%= coreRB.getString("action.Open") %></span>
                                            <input type="hidden" value="{{id}}" id="WORKITEMID">
                                            <input type="hidden" value="Open" id="action">
                                            <ap:csrf />
                                    	</span>
                                        <span id="eventWorkItemAction_Delete" class="work_list_action action btn btn-default" title="Delete" onmouseover="return true;"> 
                                            <span></span>
                                            <span><%= coreRB.getString("action.Delete") %></span>
                                            <input type="hidden" value="{{id}}" id="WORKITEMID">
                                            <input type="hidden" value="Delete" id="action">
                                            <ap:csrf />
                                        </span>
                                    </td>
                                </tr>
                                <tr class="invisible"><!-- invisible row to avoid throwing off table striping styles --></tr>
                            {{/if}}
                    {{/each}}
                </tbody>
            </table>
        </div>
    </div>
</div>
{{/this}}
</script>