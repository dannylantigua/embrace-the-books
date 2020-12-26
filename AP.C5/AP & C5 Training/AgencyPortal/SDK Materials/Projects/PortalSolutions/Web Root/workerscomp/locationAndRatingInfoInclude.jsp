<!--begin workerscomp/locationAndRatingInfoInclude.jsp -->

<%@ page import="java.util.List,
	java.util.LinkedHashMap,
	java.util.HashMap,
	com.agencyport.workerscomp.beans.WorkersCompPolicySummary,
	com.agencyport.workerscomp.beans.LocationAndRatingInfoHelper"
	
%>

<%
	WorkersCompPolicySummary summary = (WorkersCompPolicySummary) request.getAttribute("WORK_POLICY_SUMMARY");
	
	if(null == summary)
	{ 
		return;
	}

	LinkedHashMap locations = summary.getLocationsTable();
	if(locations.size() <= 0 ) return;
%>

   <% int locCounter=0;
   		
   	/*
   		HashMap locationAndRatingInfo = new HashMap(100);
   		HashMap finalLocationAndRatingInfo = new HashMap(100);
   		HashMap locationRatingInfo = new HashMap(100);
   		String locationInformation = "";
   		String ratingClassCd = "";
   		String ratingClassCdDesc = "";
   		String numEmpFullTime = "";
   		String numEmpPartTime = "";
   		String exposure = "";
   		int size = 0; 
   		*/
   		
      	for (java.util.Iterator li = locations.keySet().iterator(); li.hasNext(); ) {
       		++locCounter;
       		String locRefId = (String) li.next();  
		   	HashMap locationAndRatingInfo =  (HashMap)locations.get(locRefId);
   			String locationInformation =  (String)locationAndRatingInfo.get(WorkersCompPolicySummary.LOCATION_INFO_DESC);
   			HashMap finalLocationAndRatingInfo =  (HashMap)locationAndRatingInfo.get(WorkersCompPolicySummary.LOCATION_RATING_INFO);
   	
   			int size = finalLocationAndRatingInfo.size();
   %>
			<br>
			<table  border="0" colspan="5" cellspacing="0" cellpadding="3" width="100%"  align="center" >
				<tr>
					<th class="rosterHeaderLabel" colspan="1">Rate Class Information</th>
					<th class="rosterHeaderTab" colspan="20"> </th>
				</tr>
			
				<tr style="text-align:left; background-color: #f5f5f5;">
					<td colspan="7"><span><b>Location# &nbsp;<%=locCounter%> &nbsp;&nbsp;<%=locationInformation%></b></span></td>
								
				</tr>	
				
			<%	if ( size > 0 )	{ %>			
				<tr>
					<th style="width=150; text-align:left;  background-color: #f5f5f5;">ClassCode&nbsp;</th>
					<th style="width=300;text-align:left;  background-color: #f5f5f5;">ClassCode Description&nbsp;</th>
					<th style="width=150;text-align:left;  background-color: #f5f5f5;">Full Time Employees&nbsp;</th>
					<th style="width=150;text-align:left;  background-color: #f5f5f5;">Part Time Employees&nbsp;</th>
					<th style="width=150;text-align:left;  background-color: #f5f5f5;">Est. Annual Exposure</th>
				</tr>     
			<% } %>
     		
			
			<%--
			
			Custom JSP lab
			--------------
			
			Add the logic to iterate thru the finalLocationAndRatingInfo using the LocationAndRatingInfoHelper
			
			- get the LocationAndRatingInfoIterator
			- for each LocationAndRatingInfoDetails, emit a table record w/ table data corresponding to the table headers above
			
			
			--%>
			
			<%-- 
			
			<%
			for (java.util.Iterator ratingInfo = finalLocationAndRatingInfo.keySet().iterator(); ratingInfo.hasNext(); ) {
     			String id = (String) ratingInfo.next();  
     			HashMap locationRatingInfo = (HashMap)finalLocationAndRatingInfo.get(id);			
     		
     			String ratingClassCd =  (String)locationRatingInfo.get(WorkersCompPolicySummary.RATING_CLASS_CODE+id);
     			String ratingClassCdDesc =  (String)locationRatingInfo.get(WorkersCompPolicySummary.RATING_CLASS_CODE_DESC+id);
     	        String numEmpFullTime = (String)locationRatingInfo.get(WorkersCompPolicySummary.NUM_FULLTIME_EMP+id);
     			String numEmpPartTime = (String)locationRatingInfo.get(WorkersCompPolicySummary.NUM_PARTTIME_EMP+id);
     			String exposure =   (String)locationRatingInfo.get(WorkersCompPolicySummary.EXPOSURE+id);
     	%>								
				<tr>
					<td width="150"> <%=ratingClassCd%>&nbsp;</td>	
					<td width="300"> <%=ratingClassCdDesc%>&nbsp;</td>	
					<td width="150"><%=numEmpFullTime%>&nbsp;</td>
					<td width="150"><%=numEmpPartTime%>&nbsp;</td>
					<td width="150"><%=exposure%>&nbsp;</td>
				</tr>
			
			
		<% } %>
		
		--%>
			 
			<%
			for( LocationAndRatingInfoHelper.LocationAndRatingInfoDetails details : LocationAndRatingInfoHelper.iterator( finalLocationAndRatingInfo )) {
				
				%>								
				<tr>
					<td><%=details.getClassCd()%>&nbsp;</td>	
					<td width="300"><%=details.getClassCdDesc()%>&nbsp;</td>	
					<td><%=details.getNumFullTimeEmp()%>&nbsp;</td>
					<td><%=details.getNumPartTimeEmp()%>&nbsp;</td>
					<td><%=details.getExposure()%>&nbsp;</td>
				</tr>
			
			
		<%
				
			}
				
			%>
			</table>
	<% } %>
	<br>