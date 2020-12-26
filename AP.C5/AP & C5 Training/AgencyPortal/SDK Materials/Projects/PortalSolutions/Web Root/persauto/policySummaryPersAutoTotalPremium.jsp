<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page,
				com.agencyport.shared.apps.common.utils.NumberFormatter" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
		return;
	} 	
	
	boolean haveTotalPremium = true; // summary.getTotalPremium() > 0;
	
	if( !haveTotalPremium ) {
		return;
	}
%>
	
	<fieldset>
	<span class="greyBackground"><legend>Total Premium</legend></span>
	<table border="0" cellspacing="0" cellpadding="3" width="100%" summary="Premium Calculation Detail" class="premiumCalculationDetail"  >
		<thead> 
			<tr>
				<th width="30%"/>
				<th width="30%"/>
				<th width="10%"/>
				<th width="15%"/>
				<th width="15%"/>
			</tr>
		</thead>
		<tbody class="premiumCalculationDetail">
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td class="rightAlign">$<%=summary.getTotalPremium() %></td>
			</tr>
		</tbody> 
	</table>
		
	</fieldset>

