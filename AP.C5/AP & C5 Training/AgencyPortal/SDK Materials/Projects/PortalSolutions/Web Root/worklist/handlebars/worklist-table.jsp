<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>

<script>
/**
 * If Equals
 * if_eq this compare=that
 */
Handlebars.registerHelper('if_eq', function(context, options) {
    if (context == options.hash.compare)
        return options.fn(this);
    return options.inverse(this);
});
Handlebars.registerHelper('tolower', function(options) {
    return options.fn(this).toLowerCase();
});
</script>

<% 
String csrfToken = JSPHelper.get(request).getCSRFToken();
IResourceBundle workItemRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.WORKLIST_BUNDLE);
%>

<script id="work_list_table_template" type="text/x-handlebars-template">
{{#this}}

<div class="button-row">
	<div class="add-list">
		<div class="btn-group">
			<button data-toggle="dropdown" class="btn btn-default dropdown-toggle">
				<%= workItemRB.getString("header.Title.AddWorkItemForLOB") %> <span class="caret"></span>
			</button>
			<ul role="menu" class="dropdown-menu filter-selector filter-lob">
				{{#each WIPMetaData.lobLinksList}}
					{{#isAccount ../WIPMetaData/account_id}}
						<li class="on-click" onclick="ap.account.createWorkItem(this);" value="{{this.url}}&amp;sourceWorkItemType=2&amp;CSRF_TOKEN=<%=csrfToken%>&amp;WorkListType=">{{this.title}}</li>
					{{else}}
						<li><a href="{{this.url}}">{{this.title}}</a></li>
					{{/isAccount}}
				{{/each}}
			</ul>
		</div>
	</div>
</div>
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
										{{#ifCond account_id "-1"}}
											<span class="no-account"><i class="fa"></i></span>
										{{/ifCond}} 
                                    </div> 
                                </td>
                            {{/getCellData}}

                        </tr>

                        {{#if selected}}
                            {{#if actions}}

                                <tr class="worklistactions">
                                    <td>
                                        {{{actions}}}
                                    </td>
                                </tr>

                                <tr class="invisible"><!-- invisible row to avoid throwing off table striping styles -->
                                </tr>

                            {{/if}}
                        {{/if}}
                    {{/each}}
                </tbody>
            </table>
        </div>
    </div>
</div>
{{/this}}
</script>
