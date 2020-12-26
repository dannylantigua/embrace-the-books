<!--BEGIN STANDARD FRAMEWORK -->
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%@ page import="com.agencyport.menu.Menu" %>
<%@ page import="com.agencyport.menu.IMenuConstants" %>
<%@ page import="com.agencyport.pagebuilder.Page" %>
<%@ page import="com.agencyport.jsp.JSPHelper" %>
<%@ page import="com.agencyport.locale.IResourceBundle" %>
<%@ page import="com.agencyport.locale.ResourceBundleManager" %>
<%@ page import="com.agencyport.locale.ILocaleConstants" %>
<%@ page import="com.agencyport.workitem.model.IWorkItem" %>

<%
	JSPHelper jspHelper = JSPHelper.get(request);
	IResourceBundle rb = ResourceBundleManager.get()
			.getHTMLEncodedResourceBundle(
					ILocaleConstants.CORE_PROMPTS_BUNDLE);
	Page htmlPage = jspHelper.getPage();
	String pageId = htmlPage.getId();
	String subtype = htmlPage.getSubType();
	String pageTitle = htmlPage.getTitle();
	String styleClass = htmlPage.getStyleClass();
	boolean isReadOnly = htmlPage.isReadOnly();
	String readOnlyClass = "";
	if(isReadOnly){
		readOnlyClass = "read-only";
	}
	
	
	String multipart = "";
	if (subtype.equals("file")) {
		multipart = "ENCTYPE=\"multipart/form-data\"";
	}

	String processMethod = (String) request.getAttribute("METHOD");
	if (processMethod == null)
		processMethod = "Process";

	boolean showWorkItemAssistant = jspHelper.supportsWorkItemAssistant();
	
	Menu menu = (Menu) request.getAttribute(IMenuConstants.MENU);
	String nav_menu = "../site/submission_navigation_menu.jsp";
%>

<jsp:include page="../shared/framework_ui.jsp" flush="true" />
	
<div id="transaction" class="container">

	<!--div id="backtotop" class="back-to-top"><img src="assets/img/up-arrow.png" /><h4>Top</h4></div-->
	
	<div class="row">
	
		<div class="col-md-3" id="lower">
			<jsp:include page="<%=nav_menu%>" flush="true" />
		</div>

		<div class="col-md-7 agencyportal-transaction">
					
			<div id="pageBody" class="<%=styleClass%>" style="display: none;">
		
				<jsp:include page="../shared/messageTemplate.jsp" flush="true" />
		
				<div id="dynamic_page_inner">
					<span id="transaction_content" class="dynamic_page_column left">
						<form action="FrontServlet" class="form-horizontal dataentry agencyportal-form animated fadeIn <%=readOnlyClass%>" id="<%=pageId%>" name="<%=pageId%>" method="post" <%=multipart%>>
							<ap:page/>
							<jsp:include page="../shared/accountEntities.jsp" flush="true" />
						</form>
					</span>
				</div>
			</div>

		</div>
		<%
		if (showWorkItemAssistant) {
		%>		
		<div class="col-md-2 animated fadeIn" id="right-sidebar">
			<div>
				<jsp:include page="../workitemassistant/assistant_helper.jsp" flush="true" />
			</div>
		</div>
		<%
		}
		%>
	</div>
</div>

<jsp:include page="../home/footer.jsp" flush="true" />

<script type="text/javascript">page.initialize();</script>
 