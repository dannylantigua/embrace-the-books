<%@page import="com.agencyport.security.csrf.CSRFHelper"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ap" uri="http://www.agencyportal.com/agencyportal" %>

<%@page import="com.agencyport.jsp.JSPHelper"%>
<%@page import="com.agencyport.locale.ILocaleConstants"%>
<%@page import="com.agencyport.locale.ResourceBundleStringUtils" %>
<%@page import="com.agencyport.locale.IResourceBundle"%>
<%@page import="com.agencyport.locale.ResourceBundleManager"%>
<%@page import="com.agencyport.webshared.IWebsharedConstants"%>
<%
	JSPHelper jspHelper = JSPHelper.get(request);
	IResourceBundle workItemRB = ResourceBundleManager.get().getHTMLEncodedResourceBundle(ILocaleConstants.WORKITEM_ASSISTANT_BUNDLE);
%>

<div class="panel-group work-item-assistant" id="work_item_assistant_group">
	
</div>

<script id="work_item_assistant_template" type="text/x-handlebars-template">
{{#each sections}}
	<div class="panel panel-default">
		<div class="panel-heading">
			<h4 class="panel-title">
				{{#if_eq type compare='comments'}}<span class="has-comments"><i class="fa"></i></span>{{/if_eq}}
				{{#if_eq type compare='fileAttachments'}}<span class="has-files"><i class="fa"></i></span>{{/if_eq}}
				{{#if_eq type compare='activeUsers'}}<span class="has-users"><i class="fa"></i></span>{{/if_eq}}
				{{localizedlabel}}
			</h4>
		</div>

		{{#if_eq type compare='comments'}}
			<div class="panel-body wia-comments" id="workItemAssistant_comments_section" >
				<div id="workItemAssistant_comments_container" class="wia-container panel-fixed-height">
					{{> comment_partial}}
				</div>
				<div class="workItemAssistant_comments_new_comment">
				    <span class="new_comment_textarea_wrapper">
						<textarea class="form-control" id="workItemAssistant_comments_text"></textarea>
				    </span>
					<div class="wip-button comment_actions">
						<span class="actions_group secondary">
							<input type="button" class="btn btn-info" 
				  					id="workItemAssistant_comments_button" class="comment" value="${ap:getResourceBundleValue('workitem_assistant','workitemAssistant.comments.button', '')}"/>
						</span>
					</div>
					<br/>
					<p class="alert alert-danger hidden" id="workItemAssistant_comments_validationMessage">Please add some comments.</p>
				</div>	
			</div>
		{{/if_eq}}
		{{#if_eq type compare='fileAttachments'}}
			<div class="panel-body wia-file-attachments" id="workItemAssistant_fileattachments_section" >
				<div id="workItemAssistant_fileattachments_container" class="panel-fixed-height">
					{{> fileattachments_partial}}
				</div>
				<div class="workItemAssistant_fileattachments_new_file">
				<form id="work_item_assistant_fileattachments_form" 
				action="FrontServlet?CSRF_TOKEN={{../../CSRF_TOKEN}}&amp;WORKITEMID={{../../WORKITEMID}}&amp;PAGE_NAME={{../../PAGE_NAME}}&amp;TRANSACTION_NAME={{../../TRANSACTION_NAME}}&amp;METHOD=Process&amp;NEXT=WorkItemAssistant&amp;ACTION=FileAttachmentAdd&amp;SECTION=fileattachments" 
				enctype="multipart/form-data"
				method="POST"
				target="fileattachments_upload_target">
					<div class="new_fileAttachment new-file-attachment" id="fileAttachment_fileattachments">
						<div class="file_actions">
							<label id="fileAttachment_fileattachments_FileAttachmentInfo.AttachmentFilename_label" for="fileAttachment_fileattachments_FileAttachmentInfo.AttachmentFilename">
								<span id="fileAttachment_fileattachments_FileAttachmentInfo.AttachmentFilename_labelText"><%=workItemRB.getString("workitemAssistant.fileAttachments.selectFile")%></span>
							</label>
				            <span class="FileAttachmentInput">
				            	<input type="file" class="form-control input-sm" id="fileAttachment_fileattachments_FileAttachmentFilename" name="fileAttachment_fileattachments_FileAttachmentFilename" class="attach_file">
				            </span>
				        </div>
				        <div class="label_doctype">
				        	<label id="fileAttachment_fileattachments_FileAttachmentTypeCd_label" for="fileAttachment_fileattachments_FileAttachmentTypeCd">
				        		<span id="fileAttachment_fileattachments_FileAttachmentTypeCd_labelText"><%=workItemRB.getString("workitemAssistant.fileAttachments.documentType") %></span>
							</label>
						</div>
						<div class="file_actions select_doctype">
							<select id="fileAttachment_fileattachments_FileAttachmentTypeCd" name="fileAttachment_fileattachments_FileAttachmentTypeCd" class="attach_file form-control input-sm">
								{{#each fileTypes}}
									<option value="{{value}}" {{#if selected}}selected=""{{/if}}>{{displayText}}</option>
								{{/each}}
							</select>
						</div>
						<div class="file_actions attach_doctype wip-button">
							<span class="actions_group secondary">
								<input type="button" class="btn btn-primary file_button" id="fileAttachment_fileattachments_button" value="Go">
							</span>
						</div>									
				        <div class="file_attach_help">
							<span>File size must be 10 MB or less.</span>
						</div>
						<div class="activity_spinner hidden">
							<img id="busy_spinner_gif_fileattachments" src="assets/img/indicator_medium.gif" style="" width="32">
						</div>
						<br/>
						<p class="alert alert-danger hidden" id="workItemAssistant_fileAttachment_validationMessage"></p>
					</div>
				</form>				 
				<iframe id="fileattachments_upload_target" name="fileattachments_upload_target" src="" style="display:none">&lt;p&gt;&lt;/p&gt;</iframe>
				</div>	
			</div>
		{{/if_eq}}

		{{#if_eq type compare='activeUsers'}}
			<div class="panel-body wia-comments" id="workItemAssistant_activeUsers_section" >
				<div id="workItemAssistant_activeUsers_container" class="wia-container panel-fixed-height">
					{{> activeUsers_partial}}
				</div>
		{{/if_eq}}
	</div>
{{/each}}
</script>

<script id="work_item_assistant_activeUsers_partial" type="text/x-handlebars-template">
	{{#each sectionContent}}	
		<div id="workItemAssistant_activeUsers" class="workitem-comment">
			<div class="activeUser_text">{{userName}} </div>
		</div>			
	{{/each}}
</script>

<script id="work_item_assistant_comment_partial" type="text/x-handlebars-template">
	{{#each sectionContent}}	
		<div id="workItemAssistant_comments_{{@index}}" class="workitem-comment">
			<div class="comment_text">{{comment}} </div>
			<div class="comment_author">{{enteredByName}}</div>
			<div class="comment_timestamp">{{timestamp}}</div>
		</div>
			
	{{/each}}
</script>

<script id="work_item_assistant_fileattachments_partial" type="text/x-handlebars-template">
	{{#each sectionContent}}
		<div id="workItemAssistant_fileattachments_{{@index}}" class="workitem-file-attachment">
			<div class="file_attachment_icon"></div>
			<span class="icon_wrapper">                                      
			  <a href="{{fileDisplayURL}}"><div class="workitem_assistant_{{contentType}}"></div></a>
			</span>
			<span class="file_attachment_name">
				<a href="{{fileDisplayURL}}">{{fileName}}</a>
			</span>
		</div>
		<div class="file_attachment_type">{{fileTypeDisplay}} - {{fileSize}} kb</div>
		<div class="file_attachment_author">{{enteredByName}}</div>
		<div class="file_attachment_timestamp"> {{timestamp}}</div>
	{{/each}}
</script>

<script type="text/javascript">
	var ap = ap || {};

	var wiAssistantOptions = { sections : $.parseJSON('<%= request.getAttribute(IWebsharedConstants.WORK_ITEM_ASSISTANT_JSON) %>'), 
							  WORKITEMID : '<%=jspHelper.getWorkItemId()%>',
							  PAGE_NAME  : '<%=jspHelper.getPage().getId().toString()%>',
							  TRANSACTION_NAME : '<%=jspHelper.getTransaction().getId().toString()%>',
							  CSRF_TOKEN : '<%=jspHelper.getCSRFToken()%>'
							};  
 
	ap.workItemAssistant =  new WorkItemAssistant();
	
	ap.workItemAssistant.init('<%=jspHelper.getTransaction().getId().toString()%>',
							  '<%=jspHelper.getPage().getId().toString()%>', 
							  '<%=jspHelper.getWorkItemId()%>',
							  '<%=jspHelper.getClientUpdateInterval()%>', 
							  '<%=jspHelper.getCSRFToken()%>');
	
	<%if(jspHelper.supportsWorkItemAssistant()) { %>
		if(wiAssistantOptions) {
			ap.workItemAssistant.setup(wiAssistantOptions);
		}
	<% } %>
	 

</script>
