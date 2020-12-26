<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="com.agencyport.pagebuilder.Page" %>
<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="java.util.HashMap"%>

<%
	IResourceBundle rb = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.ACCOUNT_MANAGEMENT_BUNDLE);
	IResourceBundle rbCore = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.CORE_PROMPTS_BUNDLE);
	String actionAdd = rbCore.getString("action.Add");
%>

<!-- locations from the account which the work item is associated with. Duplicated locations are not included--> 
<!-- location_value_list and location_display_list are built in commands CMDBaseDisplayRoster and CMDBaseProcessRoster-->
<jsp:useBean id="account_downfill_list" class="java.util.HashMap" scope="request"/>

<c:if test="${account_downfill_list != null && not empty account_downfill_list}">
	<div id="accountEntitiesContainer" class="accountEntities" style="display: none;">
		<fieldset id="accountEntitiesInfo" class="standardForm">		
		<%-- 	<legend>${account_downfill_page}</legend>	 --%>
			<div class="tip_container" id="tip">				
				<%=rb.getString("account.import.header") %>
			</div>		
			<div class="account-entities" summary="Account Entities" >				
				<c:forEach var="item" items="${account_downfill_list}" varStatus="status">				
					<ul>
						<li>
							<input class="account_entity_checkbox" type="checkbox" name="CHECKBOX_ACCOUNT_ENTITY_${status.index}"
								value="${item.key}"> ${item.value}
							</input>
						</li>
					</ul>					
				</c:forEach>				
			</div>
		</fieldset>
		<div class="form-actions buttons">
			<div class="btn-group">
				<input type="button" onclick="page.addAccountEntity();" id="addButton" value="<%=actionAdd%>" name="addButton" class="btn btn-primary" tabindex="11">
			</div>
		</div>
	</div>	
</c:if>