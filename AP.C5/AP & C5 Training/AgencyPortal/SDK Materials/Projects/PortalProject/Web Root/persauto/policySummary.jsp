<%@ page import="java.util.*,
    com.agencyport.jsp.JSPHelper,
    com.agencyport.pagebuilder.Page,
    com.agencyport.webshared.IWebsharedConstants"%>
<%@include file="../policychange/pageSetup.jsp" %>
<%@page import="com.agencyport.webshared.URLBuilder"%>
<%@ page import="com.agencyport.persauto.beans.PersAutoPolicySummary"%>

<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%
    String pageTitle = htmlPage.getTitle();
    String pageName = htmlPage.getId();
	int workItemId = jspHelper.getWorkItemId();
    if (processMethod == null) processMethod = "Process";
    PersAutoPolicySummary policySummary =	(PersAutoPolicySummary) request.getAttribute("PA_POLICY_SUMMARY");
    
    String status = JSPHelper.prepareForHTML(policySummary.getWorkItemStatus().getAfterChangeStatusTitle());
%>

<style type="text/css">

	tr.subtotal {
		background-color: #f5f5f5;
		font-weight: bold;
	}

	table.roster td{
		font-weight: normal;
	}

	th.rightAlign{
		text-align:right;
	}
		
	.rightAlign{
		text-align:right;
	}
	
	.premiumCalculationDetail tbody tr:hover{
		background: #ebf5ff url(row_hover.png) repeat-x top left;
	}
}
</style>
<jsp:include page="../shared/framework_ui.jsp" flush="true" />

<%--
<div class="row">
	
		<div class="col-md-3" id="lower">
			<jsp:include page="../site/submission_navigation_menu.jsp" flush="true" />
		</div>
</div>
 --%>

<div id="pageBody" class="pageBodyWithSubmissionNavigation">

	<div class="row">
		<div class="col-xs-12">
			<h4>
				<a href="#" class="window-history" onclick="javascript:window.history.back(-1);return false;"><i class="fa fa-arrow-left"></i> Back</a>
			</h4>
		</div>
	</div>

    <jsp:include page="../shared/messageTemplate.jsp" flush="true" />

	<div class="row">
		<div class="col-xs-12">
			<h3 class="header">SUMMARY<span class="pull-right label label-large label-<%=status.toLowerCase()%> "><%=status%></span></h3>
		</div>
	</div>
		
	<div class="row">
		<div class="col-xs-12">
			<div id="tip" class="alert alert-info">
				<h4 class="hidden">Tips</h4>
				<p>If you have completed the application, click &quot;Save and Exit&quot;. Your submission will be saved in your Work in Progress.</p>
			</div>
		</div>
	</div>

    <form action="FrontServlet" 
        id="<%=pageName%>" 
        name="<%=pageName%>" 
        method="post">
	<script type="text/javascript">
		ap.submitQuoteForm = function(action) {
			var form = document.forms["<%=pageName%>"];
			var next = form["NEXT"];
			next.value = action;
			/*
			if( action == 'ConvertToApplication' ) {
				lightbox.showDialogByID("lb_confirm_convert",350,null,true,true);
			}
			else */ {
				form.submit();
				pleaseWaitLB(true);
			}
		}
	</script>
 
        <h3 class="pageTitle"><%=pageTitle%></h3>
	
	<div id="tip">
		<h4 class="hidden">Tips</h4>
		<p>If you have completed the application, click &quot;Save and Exit&quot;. Your submission will be saved in your Work in Progress.</p>
	</div>	
	
	<jsp:include page="policySummaryInfoInclude.jsp" flush="true"/>	

		
	<fieldset>
	
               <%String pdfUrl = URLBuilder.buildFrontServletURL(jspHelper.getWorkItemId(), "Acord90PDF", null, 
						"persauto", URLBuilder.DISPLAY_METHOD, false);	%>
	
	<legend>Documents</legend>
	<table>
		<tbody>
				<tr>
					<TD CLASS="fieldB_Rt">View ACORD 90</td>
				</tr>	
				<tr>			<TD><a href="<%=pdfUrl%>"
	target="new_window"><img alt="Click to view as PDF" SRC="themes/agencyportal/adobe_pdf.gif" border ="0"></a>
					</tr></td>
	
				</tr>
		</tbody>
	</table>
	</fieldset>

	<jsp:include page="../shared/fileAttachmentsInclude.jsp" flush="true"/>
	<jsp:include page="policySummaryPersAutoDrivers.jsp" flush="true"/>
	<jsp:include page="policySummaryPersAutoIncidents.jsp" flush="true"/>
	<jsp:include page="policySummaryPersAutoDriverVehAssignments.jsp" flush="true"/>	
	<jsp:include page="policySummaryPersAutoVehicles.jsp" flush="true"/>	
	<jsp:include page="policySummaryPersAutoTotalPremium.jsp" flush="true"/>	

	<jsp:include page="../policychange/readOnlyPolicyView.jsp" flush="true" />
<%	
	String[] validationErrors = (String[]) request.getAttribute("ERRORS");
	
	if (validationErrors != null) {
%>
		<fieldset>
		<legend>An action has made the application inconsistent.  Please correct the error(s).</legend>
		<table summary="">
<%	
		for (int ix = 0, size = validationErrors.length; ix < size; ix++) {
		
			String msg = validationErrors[ix];
%>	
			<tr>
				<td class="formLabel">&nbsp;</td>
				<td><label><%=msg%></label></td>
			</tr>		
<%		}
%>
		</table>
		</fieldset>
<%	}
%>	

<%--
    <jsp:include page="../shared/control_data.jsp" flush="true"/>
 --%>       
 	<ap:control_data />
    <div id="buttons">
       		<p>
    			<%if (tran.getType().equals(IWebsharedConstants.QUICK_QUOTE_TRANSACTION_TYPE)) { %>                
	                <input name="convertToApplicationButton" type="button" value="Convert to Application" style="width: 200px" onclick="ap.submitQuoteForm('ConvertToApplication');" />
                <%} %>
                	<input name="saveAndExitButton" type="button" value="Save and Exit" onclick="ap.submitQuoteForm('Save and Exit');" />
            </p>
    </div>
       <input type="HIDDEN" name="PAGE_NAME" value="<%=pageName%>" />
       <input type="HIDDEN" name="METHOD" value="<%=processMethod%>" />
	   <input type="HIDDEN" name="NEXT" value="" />
    </form>
</div>