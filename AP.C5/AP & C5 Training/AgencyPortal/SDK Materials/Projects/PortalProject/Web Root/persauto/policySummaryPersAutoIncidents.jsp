<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
		return;
	}
	
	int incidentCount = summary.getIncidentCount(); 	
%>

	
	<fieldset>
		<span class="greyBackground"><legend>Incidents</legend></span>
		<table summary="premiumCalculationDetail" width="100%">
			<thead> 
				<tr>
					<th width="10%"/>
					<th width="5%"/>
					<th width="85%"/>
				</tr>
				<tr>
					<th style="text-align:left;">Date</th>
					<th style="text-align:center;">Driver</th>
					<th style="text-align:left;">Desc</th>
				</tr>
			</thead>
			<tbody class="premiumCalculationDetail">
					
		<% for( int incIdx = 0; incIdx < incidentCount; incIdx++ ) { %>
		
				<tr>
			      	<td><%=summary.getIncidentDate(incIdx)%></td>
			      	<td style="text-align:center;"><%=summary.getIncidentDriverNum(incIdx)%></td>
			      	<td><%=summary.getIncidentDesc(incIdx)%></td>
				</tr>
			
		<% } %>
		
			</tbody>
		
		</table>
	</fieldset>

