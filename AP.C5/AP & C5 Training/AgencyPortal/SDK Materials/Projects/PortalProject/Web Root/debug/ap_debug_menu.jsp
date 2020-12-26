<%@ page import="com.agencyport.jsp.JSPHelper"%>
<%
JSPHelper jspHelper = JSPHelper.get(request);
%>
<html class="menu">
	<head>
	<title>AgencyPortal Console Menu</title>
	<style type="text/css" title="Debug Themeing">
		@import "ap_debug.css";	
	</style>	
	<script type="text/javascript">
		var page = parent.page;
		var transaction = parent.transaction;
		var user = parent.user;
		var debugConsole = parent.debugConsole;
	</script>
	</head>
	<body>			
		<h1>AgencyPortal Console</h1>
		<script type="text/javascript">
			document.write(debugConsole.makeMenu());
			document.close();
		</script>
	</body>
</html>
<!--end debug\ap_debug_menu.jsp -->