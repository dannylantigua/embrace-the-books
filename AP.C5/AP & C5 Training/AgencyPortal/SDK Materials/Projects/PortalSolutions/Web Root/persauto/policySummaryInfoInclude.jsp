<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary,
				com.agencyport.pagebuilder.Page" %>
				
<%
	PersAutoPolicySummary summary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();	
    
	if (null == summary) {
%>

	<fieldset>
		<span class="greyBackground"><legend>Summary</legend></span>
		<table summary="Policy Summary">
			<tr>
		      	<td class="formLabel">There was a problem with the Policy Summary creation.</td>
			</tr>
		</table>
	</fieldset>
		
<%	return;
	} 	
%>

<%
if( false && summary.getAgencyName().length() != 0 ) // only show agency information if name spec'd
{
%>

	<fieldset>
		<span class="greyBackground"><legend>Agency Information</legend></span>
		<table summary="Agency Information">
			<tr>
				<td class="formLabel" width=150px>Agency:</td>
				<td class="formField" width=400px><%=summary.getAgencyName()%></td>
			</tr>
		
			<tr>
				<td class="formLabel">Producer Code:</td>
				<td class="formField"><%=summary.getProducerCode()%></td>
			</tr>
		</table>
	</fieldset>

<%	
} 
%>

	
	<fieldset>
		<span class="greyBackground"><legend>Applicant Information</legend></span>
		<table summary="Submission Summary">
			<tr>
		      	<td class="formLabel" width=150px>Reference #:</td>
		      	<td class="formField" width=400px><%=summary.getWorkItemId()%></td>
			</tr>
			<tr>
				<td class="formLabel">Applicant:</td>
				<td class="formField"><%=summary.getInsured()%></td>
			</tr>
		<%
		if( !summary.haveCoinsured())  
		{
		%>
		
			<tr>
				<td class="formLabel">Co-Applicant:</td>
				<td class="formField"><%=summary.getCoinsured()%></td>
			</tr>
		<%
		} 
		%>
			<tr>
				<td class="formLabel">Policy Term:</td>
				<td class="formField">
				<% String to = " "+"to"+" "; %>
					<%=summary.getEffectiveDate()%><%=to%><%=
							summary.getExpirationDate()%> 
				</td>
			</tr>

		<%
		if( !summary.getAgencyName().equals("") /* !summary.getAgencyCustomerId().equals("") */ ) 
		{
		%>
		
			<tr>
				<td class="formLabel">Agency Customer ID:</td>
				<td class="formField"><%=summary.getAgencyCustomerId()%></td>
			</tr>
		<%
		} 
		%>
		
		<%
		if(!pageName.equals("submissionConfirmation")){
		%>			
			
			<tr>
				<td class="formLabel">Submission Status:</td>
				<td class="formField"><%=summary.getWorkItemStatus().getAfterChangeStatusTitle()%></td>
			</tr>		
<%
			}
%>
			
		</table>
	</fieldset>

