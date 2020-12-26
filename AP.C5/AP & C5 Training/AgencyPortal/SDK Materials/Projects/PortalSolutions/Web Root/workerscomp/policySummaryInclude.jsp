<!-- begin workerscomp\policySummaryInclude.jsp -->

<%@page import="com.agencyport.pagebuilder.Page"%>
<%@page import="com.agencyport.workerscomp.beans.WorkersCompPolicySummary"%>
<%@page import="com.agencyport.workitem.model.IWorkItemStatus"%>
<%@page import="com.agencyport.workitem.impl.WorkItemStatusManager"%>

<script type="text/javascript" src="javascript/electronicPayment.js"></script>

<%
    Page htmlPage = (Page) request.getAttribute("PAGE");
    String pageName = htmlPage.getId();		

	WorkersCompPolicySummary summary = (WorkersCompPolicySummary) request.getAttribute("WORK_POLICY_SUMMARY");
	WorkItemStatusManager wism = new WorkItemStatusManager();
	
	if(null == summary){ %>
	<fieldset>
		<span class="greyBackground"><legend>Summary</legend></span>
		<table summary="Submission Summary">
			<tr>
		      	<td class="formLabel">There was a problem with the Policy Summary creation.</td>
			</tr>
		</table>
	</fieldset>
		
	<%	return;
	} 
	
%>
	<fieldset>
		<span class="greyBackground"><legend>Agency Information</legend></span>
		<table summary="Agency Information">
			<tr>
				<td class="formLabel" width=150px>Agency Name:</td>
				<td class="formField" width=400px><%=summary.getAgencyName()%></td>
			</tr>
			<tr>
				<td class="formLabel">Producer Code:</td>
				<td class="formField"><%=summary.getProducerCode()%></td>
			</tr>	
			<tr>
				<td class="formLabel">Producer Sub Code:</td>
				<td class="formField"><%=summary.getProducerSubCode()%></td>
			</tr>
			<tr>
				<td class="formLabel">Controlling State:</td>
				<td class="formField"><%=summary.getControllingState()%></td>
			</tr>				
		</table>
	</fieldset>
	
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
			<!-- LAB: Custom JSPs -->
			<tr>
				<td class="formLabel">Applicant Email:</td>
				<td class="formField">
					<%=request.getAttribute("EMAILADDR").toString()%>&nbsp;
					<%=summary.getInsuredEmail()%>&nbsp;
					<%=summary.getFieldValue("InsuredOrPrincipal[InsuredOrPrincipalInfo.InsuredOrPrincipalRoleCd='Insured'].GeneralPartyInfo.Communications.EmailInfo[CommunicationUseCd='Business'].EmailAddr","")%>
				
				</td>
			</tr>
			<tr>
				<td class="formLabel">Policy Term:</td>
				<td class="formField">
				<% String to = " "+"to"+" "; %>
					<%=summary.getEffectiveDate()%><%=to%><%=
							summary.getExpirationDate()%> 
				</td>
			</tr>
			<tr>
				<td class="formLabel">Agency Customer ID:</td>
				<td class="formField"><%=summary.getAgencyCustomerId()%></td>
			</tr>
			<tr>
				<td class="formLabel">Date Submitted:</td>
				<td class="formField">
					<label> <%=summary.getSubmissionDate()%> </label>
				</td>
			</tr>	
			<tr>
				<td class="formLabel">Submission Status:</td>
				<td class="formField"><%=summary.getWorkItemStatus().getMnemomic()%></td>
			</tr>		
		</table>
	</fieldset>
	<!-- LAB: Connectors [Java] -->
	<fieldset>
		<span class="greyBackground"><legend>Premium Summary</legend></span>
		<table summary="Premium">
			<tr>
				<td class="formLabel" width="150px">Total Premium:</td>
				<td class="formField" width="400px"><%=summary.getPremium()%></td>
			</tr>
		</table>
	</fieldset>
