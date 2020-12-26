<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
		return;
	}
	
	int vehicleCount = summary.getVehicleCount();
	int driverCount = summary.getDriverCount();
	
	int vehicleWidth = 35; // percent
	
	int driverWidth = (100 - vehicleWidth) / driverCount; 	
%>

	
	<fieldset>
		<span class="greyBackground"><legend>Driver Vehicle Assignments</legend></span>
		<table class="premiumCalculationDetail" summary="Submission Summary" width="100%">
			<thead> 
				<tr>
					<th width="<%=vehicleWidth%>%"/>
				<% for( int drvrIdx = 0; drvrIdx < driverCount; drvrIdx++ ) { %>
					<th width="<%=driverWidth%>%" style="text-align:center;">
						<%=summary.getDriverVehUsageDriver( drvrIdx, -1 )%>
					</th>
				<% } %>
				<tr>
					<th style="text-align:left;" colspan="<%=driverCount+1%>">Vehicles</th>
				</tr>
			</thead>
			<tbody class="premiumCalculationDetail">

		<% for( int vehIdx = 0; vehIdx < vehicleCount; vehIdx++ ) { %>
					
				<tr>
					<td class="formField"><%=summary.getDriverVehUsageVehicle( -1, vehIdx )%></td>
			<% for( int drvrIdx = 0; drvrIdx < driverCount; drvrIdx++ ) { %>
		
			      	<td class="formField" style="text-align:center;"><%=summary.getDriverVehUsage( drvrIdx, vehIdx )%></td>
			
			<% } %>
				</tr>
				
		<% } %>
		
			</tbody>
		
		</table>
	</fieldset>

