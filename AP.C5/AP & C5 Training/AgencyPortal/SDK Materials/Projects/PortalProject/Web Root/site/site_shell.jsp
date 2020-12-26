<!DOCTYPE html>
<!-- site/site_shell.jsp-->
<%@ page import="com.agencyport.jsp.JSPHelper" %>
<%@ page import="com.agencyport.utils.AppProperties" %>
<%@ page import="com.agencyport.security.profile.ISecurityProfile" %>
<%@ page import="com.agencyport.product.ProductDefinitionsManager" %>
<%@ page import="com.agencyport.utils.text.CharacterEncoding" %>
<%@ page import="com.agencyport.utils.AppProperties" %>
<%@ page import="com.agencyport.servlets.base.IBaseConstants" %>

<%
ISecurityProfile securityProfile = JSPHelper.get(request).getSecurityProfile();
String versionNumber = ProductDefinitionsManager.getCurrentlyRunningVersion().toString();
String np = (String)request.getAttribute(IBaseConstants.NEXT_PAGE);

String bodyClass = (String)request.getAttribute("bodyClass");
if (bodyClass == null) bodyClass = "";

%>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Agencyportal</title>
		<meta name="description" content="AgencyPortal Web Application V10.0">
		<meta name="author" content="Agencyport">
		<meta http-equiv="Content-Type" content="text/html; charset=<%=CharacterEncoding.get().getCharacterEncoding()%>">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
	
		<link href="${pageContext.request.contextPath}/assets/themes/agencyportal/agencyportal.css" rel="stylesheet">
	  
		<!-- Fav and touch icons -->
		<link rel="apple-touch-icon-precomposed" sizes="144x144" href="${pageContext.request.contextPath}/assets/ico/apple-touch-icon-144-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="${pageContext.request.contextPath}/assets/ico/apple-touch-icon-114-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="${pageContext.request.contextPath}/assets/ico/apple-touch-icon-72-precomposed.png">
		<link rel="apple-touch-icon-precomposed" href="${pageContext.request.contextPath}/assets/ico/apple-touch-icon-57-precomposed.png">
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/ico/favicon.ico">	
	    
		<script src="${pageContext.request.contextPath}/assets/js/agencyportal.js" type="text/javascript"></script>	
	</head>
	<body <%= bodyClass %>>
	 
		<div class="agencyportal-5">
			<!--  Navigation Bar -->
			<jsp:include page="../menu/menu.jsp" flush="true" />
		
			<!-- Page Body (Editable Content) -->
			<jsp:include page="<%=np%>" flush="true" />
	
		</div>
		<!-- Idle Timer -->
		<% if(securityProfile != null){ %>
			<jsp:include page="timer.jsp" flush="true" />
		<%} %>
		<script src="${pageContext.request.contextPath}/assets/js/agencyportal-body.js" type="text/javascript"></script>
	</body>
</html>