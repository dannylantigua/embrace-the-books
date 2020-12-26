<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
		return;
	}
	
	String[][] coverages = 
		{ { "CSL", 	"CSL Limit"}
		, { "BI", 	"Split BI Limits",}
		, { "PD",	"Property Damage Limit" }
		, { "MEDPM", "Medical Payments" }
		, { "UMCSL", "Uninsured Motorists CSL" }
		, { "UM", 	"Uninsured Motorists Split Limits" }
		, { "UNCSL", "Underinsured Motorists CSL" }
		, { "UNDUM", "Underinsured Motorists Split Limits" }
		, { "UMPD", "UMPD Limit" }
		, { "PIP", 	"PIP Coverage" }
		, { "APIP", "Additional PIP Coverage" }
		, { "COMP", "Comprehensive Deductible" }
		, { "COLL", "Collision Deductible" }
		, { "TL", 	"Towing and Labor Limit" }
		, { "TRNEX", "Increased Limits Transportation Expense" }
		, { "SORPE", "Excess Sound Reproducing Equipment Limit" }
		, { "AV",	"Audio, Visual and Data Electronic Equipment Coverage Limit" }
		, { "TR", 	"Tapes, Records, Discs and Other Media Coverage Limit" }
		, { "CUSTE", "Customizing Equipment Coverage" }
		, { "LEASE", "Auto Lease Gap" }
		, { "RENT", "Motor Home Rental Coverage" }
		, { "EXNON", "Extended Non-Ownership Coverage" }
		};
	
	int vehicleCount = summary.getVehicleCount(); 	
%>

	
	<fieldset>
		<span class="greyBackground"><legend>Vehicles</legend></span>
					
		<table class="premiumCalculationDetail" summary="Premium Calculation Detail" width="100%">
			<thead> 
				<tr>
					<th width="65%"/>
					<th width="5%"/>
					<th width="15%"/>
					<th width="15%"/>
				</tr>
				<tr>
					<th style="text-align:left;">Coverage</th>
					<th style="text-align:right;">&nbsp;</th>
					<th style="text-align:right;">&nbsp;</th>
					<th style="text-align:right;">Premium</th>
				</tr>
			</thead>
		<% for( int vehIdx = 0; vehIdx < vehicleCount; vehIdx++ ) { %>
			<thead> 
				<tr>
					<th colspan="4">
						<%=summary.getVehicleYear(vehIdx)%>
						<%=summary.getVehicleMake(vehIdx)%>
						<%=summary.getVehicleModel(vehIdx)%>
						VIN# <%=summary.getVehicleVIN(vehIdx)%>
					</th>
				</tr>
			</thead>
			<tbody class="premiumCalculationDetail">
			<% for( int cc = 0; cc < coverages.length; cc++ ) { %>		
				<% if( summary.haveVehicleCoverage(vehIdx,coverages[cc][0])) { %>
				<tr>
			      	<td><%=coverages[cc][1]%></td>
			      	<td style="text-align:right;"></td>
			      	<td style="text-align:right;">
			      							<%=summary.getVehicleCoverageLimit(vehIdx,coverages[cc][0])%>
			      							<%=summary.getVehicleCoverageDeductible(vehIdx,coverages[cc][0])%>
			      							<%=summary.getVehicleCoverageOption(vehIdx,coverages[cc][0])%>
			      	</td>	
			      	<td style="text-align:right;"><%=summary.getVehicleCoveragePremium(vehIdx,coverages[cc][0])%></td>
				</tr>
				<% } %>
			<% } %>
			</tbody>
		<% } %>
		</table>
		
	</fieldset>

