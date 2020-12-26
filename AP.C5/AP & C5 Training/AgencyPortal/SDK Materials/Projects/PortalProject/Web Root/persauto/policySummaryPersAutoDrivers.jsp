<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
		return;
	}
	
	int driverCount = summary.getDriverCount(); 	
%>

	
	<fieldset>
		<span class="greyBackground"><legend>Drivers</legend></span>
		<table summary="Submission Summary">
			<thead> 
				<tr>
					<th width="100%"/>
				</tr>
				<tr>
					<th style="text-align:left;">Name</th>
				</tr>
			</thead>
			<tbody>
					
		<% for( int drvrIdx = 0; drvrIdx < driverCount; drvrIdx++ ) { %>
		
				<tr>
			      	<td class="formField"><%=summary.getDriverName(drvrIdx)%></td>
				</tr>
			
		<% } %>
		
			</tbody>
		
		</table>
	</fieldset>

