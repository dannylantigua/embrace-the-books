<!-- home/home.jsp-->
<!--@@apwebapp_specification_version@@-->
<%@page import="java.util.Set"%>
<%@page import="java.util.ListIterator"%>
<%@page import="com.agencyport.security.profile.impl.SecurityProfileManager"%>
<%@page import="com.agencyport.security.profile.ISecurityProfile"%>
<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@page import="com.agencyport.webshared.URLBuilder"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="java.util.List"%>
<%@page import="com.agencyport.trandef.Transaction"%>
<%@page import="com.agencyport.domXML.widgets.LOBCode"%>
<%@page import="com.agencyport.trandef.TransactionDefinitionManager"%>

<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal"%>

<!-- Adding core_prompts resource bundles for JavaScript use -->
<ap:ap_rb_loader rbname="core_prompts"/>

<%
List<Transaction> transactions = TransactionDefinitionManager.getTransactions(true); 
IResourceBundle coreRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
ListIterator<Transaction> iterator = transactions.listIterator();
JSPHelper jspHelper = JSPHelper.get(request);
ISecurityProfile securityProfile = SecurityProfileManager.get().acquire(session);
String userId = securityProfile.getSubject().getId().toString();
Set<String> userPermissions = securityProfile.getRoles().getPermissionNames(securityProfile.getSubject().getPrincipal());
%>
<script src="${pageContext.request.contextPath}/javascript/worklist/filter-manager.js"></script>
<div class="home-page">
	<section class="get-started">
		<div class="container">
			<h3 class="header"><%=coreRB.getString("label.GetStarted")%></h3>
			<div class="row lines-of-business animated fadeIn">
			<%
			// We expect two transactions (quick quote and new business for each LOB)
			while (iterator.hasNext()){
				Transaction first = iterator.next();
				// Determine if user has the writes to work with this LOB
				String permissionForTransaction = "access" + first.getLob();
				if (!userPermissions.contains(permissionForTransaction)){
					continue;
				}
				String firstURL = URLBuilder.buildFrontServletURL(-1, null, Boolean.TRUE.toString(), first.getId(), URLBuilder.DISPLAY_METHOD, false);
				String secondURL = null;
				Transaction second = null;
				if (iterator.hasNext()){
					second = iterator.next();
					// If the second one's LOB code does not match the first one's then we move the iterator back
					// to catch it the next time around for the next LOB.
					if (!second.getLobCode().equals(first.getLobCode())){
						iterator.previous();
						second = null;
					} else {
						secondURL = URLBuilder.buildFrontServletURL(-1, null, Boolean.TRUE.toString(), second.getId(), URLBuilder.DISPLAY_METHOD, false); 
					}
				}
				String lobCodeDesc = first.getLobCode().getDescription();
				String lobCSSImageClass = jspHelper.getLOBImageClass(first);
			%>
				<div class="col-xs-12 col-sm-6 col-lg-2">
					<div class="<%=lobCSSImageClass%>">
						<div class="hover-color"></div>		
						<div class="btn-group">
							<div class="lob-button"><a class="btn" href="<%=firstURL%>"><%=first.getLocalizedType()%></a></div>
							<%if (second != null) { 
							%>
							<div class="lob-button"><a class="btn" href="<%=secondURL%>"><%=second.getLocalizedType()%></a></div>
							<%}%>
						</div>
						<div class="caption">
							<h4><%=lobCodeDesc%></h4>
						</div>
					</div>
				</div>
			<%}%>	
			</div> <!-- /.row -->
		</div> <!-- /.container -->
	</section>

	<section class="queue">
		<div class="container">
			<h3 class="header"><%=coreRB.getString("label.Queue")%></h3>
			<div class="row">
				<div  id="agent_queue" class="queue-agent col-xs-12 col-sm-6 animated fadeIn">
					<div class="table-panel agent-queue"></div>
				</div>
				<div id="underwriter_queue" class="queue-underwriter col-xs-12 col-sm-6 animated fadeIn">
					<div class="table-panel underwriter-queue"></div>
				</div>
			</div> <!-- /.row -->	
		</div> <!-- /.container -->
			
		<script type="text/javascript">
			var agentQueue = new ApQueueWidget("agent_queue", {
				"title": "<%=coreRB.getString("label.MostRecent")%>", "statusCds": [20], "negateStatusCds": true, "filterOnCreator": true, "userId": "<%= userId%>"
			});
			agentQueue.render();
			var underwriterQueue = new ApQueueWidget("underwriter_queue", {
				"title": "<%=coreRB.getString("label.WaitingforUnderwriter")%>", "statusCds": [20], "negateStatusCds": false, "filterOnCreator": true, "userId": "<%= userId%>"
			});
			underwriterQueue.render();
		</script>
	
	</section>

	<section class="quotes">
		<div id="quote_container" class="container">		
		</div> <!-- /.container -->
		
		<script type="text/javascript">
			var quoteWidget = new ApQuoteWidget("quote_container", {
				title: "<%=coreRB.getString("label.Quotes")%>",
				status: [15, 22, 21, 35],
				userId: "<%= userId%>"
			});
			quoteWidget.render();
		</script>
	</section>
</div>

<jsp:include page="footer.jsp" flush="true" />
