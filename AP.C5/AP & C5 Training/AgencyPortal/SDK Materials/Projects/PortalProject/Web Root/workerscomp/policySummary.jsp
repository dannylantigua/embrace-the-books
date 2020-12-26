<!--begin workerscomp\policySummary.jsp -->

<!--BEGIN STANDARD FRAMEWORK -->

<%@ page import="java.util.*,
    com.agencyport.html.elements.BaseElement,
    com.agencyport.pagebuilder.Page,
    com.agencyport.pagebuilder.BasePageElement,
    com.agencyport.webshared.IWebsharedConstants,
    com.agencyport.connector.IConnectorConstants,
    com.agencyport.connector.MessageMap,
    com.agencyport.connector.Result,
    com.agencyport.workerscomp.servlets.PolicySummary"%>
   	
<%@page import="com.agencyport.webshared.URLBuilder"%>
<%@page import="com.agencyport.jsp.JSPHelper"%>   	
  
<%@ include file="../policychange/pageSetup.jsp" %>
   
<%--   	
<%@ include file="../shared/framework_ui.jsp" %>
 
 --%>   	
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%
	// JSPHelper jspHelper = JSPHelper.get(request);
    // Page htmlPage = jspHelper.getPage();
    String pageTitle = htmlPage.getTitle();
    String pageName = htmlPage.getId();
    boolean errorMessagesExist = false;
    
	MessageMap messageMap = (MessageMap) 
        request.getAttribute(IWebsharedConstants.MESSAGES);
        
	if (messageMap != null) {
    	List<Result> errors = messageMap.getResultsByType(IConnectorConstants.MESSAGE_ERROR_LITERAL);
    	
		if (errors.size() > 0) {
			errorMessagesExist = true;
		}
	}
 
    // String processMethod = (String) request.getAttribute("METHOD");
    if (processMethod == null) processMethod = "Process";

	/* 
	TODO
	PolicySummary policySummary = (PolicySummary) request.getAttribute("WORK_POLICY_SUMMARY");

    String status = JSPHelper.prepareForHTML(policySummary.getWorkItemStatus().getAfterChangeStatusTitle());
    */
%>

<%
			// PolicySummary summary = (PolicySummary) request.getAttribute("APP_POLICY_SUMMARY");
			String pdfUrl = URLBuilder.buildFrontServletURL(jspHelper.getWorkItemId(), "Acord130PDF", null, 
						"workersComp", URLBuilder.DISPLAY_METHOD, false);
			
			%>
    <script type="text/javascript" src="javascript/common.js"></script>	
	<script type="text/javascript" src="javascript/submissionSummary.js"></script>
	<div id="pageBody" class="pageBodyWithSubmissionNavigation">

	<div class="row">
		<div class="col-xs-12">
			<h4>
				<a href="#" class="window-history" onclick="javascript:window.history.back(-1);return false;"><i class="fa fa-arrow-left"></i> Back</a>
			</h4>
		</div>
	</div>

    <jsp:include page="../shared/messageTemplate.jsp" flush="true" />

	<%--
	<div class="row">
		<div class="col-xs-12">
			<h3 class="header">SUMMARY<span class="pull-right label label-large label-<%=status.toLowerCase()%> "><%=status%></span></h3>
		</div>
	</div>
	--%>
		
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
    	
    	<h3 class="pageTitle"><%=pageTitle%></h3>    
			
		<jsp:include page="policySummaryInclude.jsp" flush="true"/>
		
		<%	if (!errorMessagesExist) {	%>

			<jsp:include page="locationAndRatingInfoInclude.jsp" flush="true"/>
	
			<fieldset>
		 		<span class="greyBackground"><legend>Documents</legend></span>
		 		<table width="650px"> 
		  		<tbody>
					<tr>
						<td >An original copy of the application must be signed by the applicant and the agent, and kept on file by the agency of record. The original copy of the application is subject to audit by the Insurance Carrier.</td>
					</tr>		 
				<tr>
					<TD CLASS="fieldB_Rt">View ACORD 130</td>
				</tr>	
				<tr>			<TD><a href="<%=pdfUrl%>"
	target="new_window"><img alt="Click to view as PDF" SRC="themes/agencyportal/adobe_pdf.gif" border ="0"></a>
					</tr></td>
	
				</tr>
					</tr>
		  		</tbody>
		 		</table>
			</fieldset>					
			<tr>
				<td> <jsp:include page="../shared/fileAttachmentsInclude.jsp" flush="true"/> </td>
			<%-- 					
				<td> <jsp:include page="../shared/control_data.jsp" flush="true"/> </td>
			 --%>
			 	<ap:control_data />
			</tr>		

			<table width="650px" >
				<tr><td><br><br> To complete the submission process later, click &quot;Save and Exit&quot; to stop now.  Your submission will be saved in the Work in Progress folder. <br><br></td></tr>
				<tr><td> Submission of this application certifies that the answer to the questions are true, correct and complete to the best of my knowledge.<br><br></td></tr>				
			</table>		
			   
			<div id="buttons">
				<p>
				<%if (tran.getType().equals(IWebsharedConstants.QUICK_QUOTE_TRANSACTION_TYPE)) { %>                
	                <input name="convertToApplicationButton" type="button" value="Convert to Application" style="width: 200px" onclick="ap.submitQuoteForm('ConvertToApplication');" />
                <%} %>
					<button name="NEXT" type="submit" value="Save and Exit" accesskey="x" id="saveAndExitButton" onclick="javascript:buttonClick(this)">Save and Exit</button>
					<button type="button" value="Print Page" id="print" onClick="window.print()">Print Page</button>
				</p>
			</div>
		<% } %>

		<input type="HIDDEN" name="PAGE_NAME" value="<%=pageName%>" />
		<input type="HIDDEN" name="METHOD" value="<%=processMethod%>" />
    </form>
</div>

