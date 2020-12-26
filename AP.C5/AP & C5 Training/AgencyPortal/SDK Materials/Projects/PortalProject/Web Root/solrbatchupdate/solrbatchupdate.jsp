<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="java.util.Locale"%>
<%@page import="com.agencyport.locale.LocaleFactory"%>
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%
IResourceBundle solrRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.SOLR_BUNDLE, request);
%>

<script type="text/javascript" language="javascript">
	var options = eval(<%= request.getAttribute("options") %>);
	options.indexer_column_name = "<%=solrRB.getString("label.indexer")%>";
	options.action_column_name = "<%=solrRB.getString("label.action")%>";
	options.update_index_button = "<%=solrRB.getString("action.update")%>";
</script>

<script id="solr_admin_template" type="text/x-handlebars-template">
	{{#this}}		
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>{{indexer_column_name}}</th>
					<th>{{action_column_name}}</th>
				</tr>
			</thead>
			<tbody>
				{{#each indexers}}
				<tr>
					<td>{{this}}</td>
					<td><a href="#" class="btn btn-primary" onclick="update_index('{{this}}');">{{../update_index_button}}</a></td>
				</tr>
				{{/each}}
			</tbody>
		</table>
	{{/this}}
</script>
<ap:ap_rb_loader rbname="core_prompts" />
<!-- Div that will be populated with Handlebars solr_admin_template template. -->
<div class="container">
	<h1><%= solrRB.getString("header.Title.SolrSync") %></h1>
	<div class="row">
		<div class="col-xs-12">
			<div id="error_messages" style="display:none" class="alert alert-error"></div>
			<div id="success_messages" style="display:none" class="alert alert-success"></div>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12">
			<div id="solr_admin_div"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var source = $("#solr_admin_template").html();
	var template = Handlebars.compile(source);
	$("#solr_admin_div").html(template(options));
</script>

<jsp:include page="../home/footer.jsp" flush="true" />

