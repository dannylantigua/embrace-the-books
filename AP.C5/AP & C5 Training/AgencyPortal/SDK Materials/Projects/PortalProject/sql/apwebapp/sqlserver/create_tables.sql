/* database vendor target: sqlserver */

/* The following table DDL should move to the work item reference project when created */
create table NextKeyValue
(
	KeyName varchar(255) NOT NULL,
	KeyValue bigint NOT NULL
);
ALTER TABLE NextKeyValue ADD CONSTRAINT pk_NextKeyValue PRIMARY KEY (KeyName);

CREATE TABLE work_item
(
   	work_item_id	        integer NOT NULL,
    user_group_id           integer NOT NULL,
    creator_id				integer NOT NULL,
	owner_id				integer NOT NULL,
	owner_group_id          integer NOT NULL,
    status                  integer NOT NULL,
    policy_number			varchar(25),
	LOB                     varchar(10) NOT NULL,
	effective_date		    datetime,
	expiration_date		    datetime,
    creation_time           datetime,
	entity_name             varchar(80),
    premium					decimal(13,2),
	transaction_id          varchar(25) NOT NULL,
	upload_flag             smallint NOT NULL,
 	last_update_by		    varchar(128) NOT NULL,
	last_update_time	    datetime NOT NULL,
	commit_flag             smallint NOT NULL,
	transaction_type		varchar(32),
	complete_percent		integer DEFAULT 0
);
ALTER TABLE work_item ADD CONSTRAINT pk_work_item PRIMARY KEY (work_item_id);
CREATE INDEX idx_wi_1 ON work_item ( user_group_id ASC );
CREATE INDEX idx_wi_2 ON work_item ( policy_number ASC );
CREATE INDEX idx_wi_3 ON work_item ( entity_name ASC );

CREATE TABLE xmlstore
(
    work_item_id	        integer NOT NULL,
	xmlstring				xml,
	last_update_by		    varchar(128),
	last_update			    datetime NOT NULL,
	original_xmlstring		xml
);
ALTER TABLE xmlstore ADD CONSTRAINT pk_xmlstore PRIMARY KEY (work_item_id);

CREATE TABLE fileAttachment
(
	file_id integer NOT NULL,
    work_item_id integer NOT NULL,
    fileName varchar(100) NOT NULL,
    documentType varchar(100) NOT NULL,
    contentType varchar(100) NOT NULL,
    fileImage image NOT NULL,
    last_update_by varchar(128) NOT NULL,
    last_update datetime NOT NULL
);
ALTER TABLE fileAttachment ADD CONSTRAINT pk_fileAttachment PRIMARY KEY (file_id);
CREATE INDEX idx_fa_1 on fileAttachment(work_item_id ASC);
CREATE INDEX idx_fa_2 on fileAttachment(fileName);

insert into NextKeyValue(KeyName, KeyValue) VALUES ('FileAttachmentId', 1);

CREATE TABLE upload (
	guid					varchar(200) NOT NULL,
	work_item_id	   		integer,
	create_date   			datetime  NOT NULL,
	ams_org 				varchar(64),
	ams_name 				varchar(64),
	ams_version 			varchar(16)
);
ALTER TABLE upload ADD CONSTRAINT pk_upload PRIMARY KEY (guid);
CREATE INDEX idx_upload_1 ON upload ( work_item_id ASC );

CREATE TABLE menuInformation
(
    work_item_id	        integer NOT NULL,
    transactionName         varchar(30) NOT NULL,
	menu    				xml, /* Changed from varchar(2000) as of apwebapp 3.5 */
	last_update_by		    varchar(128),
	last_update			    datetime NOT NULL
);
ALTER TABLE menuInformation ADD CONSTRAINT pk_menuInformation PRIMARY KEY (work_item_id, transactionName);

CREATE TABLE preconditions
(
    work_item_id	        integer NOT NULL,
	xmlstring				xml,
	last_update_by		    varchar(128),
	last_update			    datetime NOT NULL,
	original_xmlstring		xml
);
ALTER TABLE preconditions ADD CONSTRAINT pk_preconditions PRIMARY KEY (work_item_id);

CREATE TABLE correction_set
(
	work_item_id						int not null,
	correction_set_id					int not null,
 	last_update_by		    			varchar(128),
 	defaults_template_name_used			varchar(64),
	last_update			    			datetime not null
);
ALTER TABLE correction_set ADD CONSTRAINT pk_correction_set PRIMARY KEY (work_item_id, correction_set_id);

CREATE TABLE correction_detail
(
	correction_set_id					int not null,
	sequence_no							int not null,
	corrected_page_entity_key			varchar(256),
	corrective_action_applied_flag		int not null,
	previous_value						varchar(256),
	adjusted_value						varchar(256),
	roster_path							varchar(256),
	field_label							varchar(1024),
	related_validation_err_msg			varchar(256),
	data_adjustor_class_name			varchar(512),
	validation_category					int not null,
	correction_element_xml				varchar(512),
	correction_message					varchar(512)
);
ALTER TABLE correction_detail ADD CONSTRAINT pk_correction_detail PRIMARY KEY (correction_set_id,sequence_no);

CREATE TABLE default_templates
(
	default_id				int not null,			/* primary key - foreign key to xmlstore */
    default_name			varchar(64) NOT NULL,	/* name of default template */
	owner_type				int not null,			/* 1 for user or agent, 2 for agency, 3 for carrier */
    owner_id		        varchar(64) NOT NULL,	/* carrier's id, agency's id, or user's/agent's id */
    lob						varchar(10)				/* e.g. AUTOP, HOME */
);
ALTER TABLE default_templates ADD CONSTRAINT pk_default_templates PRIMARY KEY (default_id);
CREATE INDEX idx_df_templates_name ON default_templates (default_name ASC);
CREATE INDEX idx_df_templates_owner ON default_templates (owner_id ASC);

insert into NextKeyValue(KeyName, KeyValue) VALUES ('WorkItemId', 1000);

CREATE TABLE auditlog (
	audit_id bigint NOT NULL,
	audit_realm  varchar(50),
	actor_link_value varchar(64) NOT NULL,
	actor_link_type varchar(64) NOT NULL,
	actor_link_short_name varchar(128) NOT NULL,
	action_code varchar(16) NOT NULL,
	success_flag char(1) NOT NULL,
	target_link_value varchar(64) NOT NULL,
	target_link_type varchar(64) NOT NULL,
	target_link_short_name varchar(128) NOT NULL,
	target2_link_value varchar(64),
	target2_link_type varchar(64),
	target2_link_short_name varchar(128),
	create_time datetime NOT NULL,
	user_group_id  varchar(32),
	user_group_name  varchar(50),
	description varchar(512)
);
ALTER TABLE auditlog ADD CONSTRAINT pk_auditlog PRIMARY KEY (audit_id);
CREATE INDEX idx_auditlog_arealm ON auditlog ( audit_realm ASC );
CREATE INDEX idx_auditlog_ctime ON auditlog ( create_time ASC );
CREATE INDEX idx_actor_lvalue ON auditlog ( actor_link_value ASC );
CREATE INDEX idx_actor_ltype ON auditlog ( actor_link_type ASC );
CREATE INDEX idx_trg_lvalue ON auditlog ( target_link_value ASC );
CREATE INDEX idx_trg_ltype ON auditlog ( target_link_type ASC );
CREATE INDEX idx_trg2_lvalue ON auditlog ( target2_link_value ASC );
CREATE INDEX idx_trg2_ltype ON auditlog ( target2_link_type ASC );
CREATE INDEX idx_user_group ON auditlog ( user_group_id ASC );
delete from NextKeyValue where KeyName='audit';
insert into NextKeyValue(KeyName, KeyValue) VALUES ('audit', 0);

CREATE TABLE rtracker (
	tracker_id		bigint  NOT NULL,
	key_value 		varchar(64) NOT NULL,
	key_type 		varchar(64) NOT NULL,
	owner_id		varchar(128) NOT NULL,
	user_id			integer NOT NULL,
	user_name 		varchar(200),
	locked			smallint NOT NULL,
	expiration 		datetime
);
ALTER TABLE rtracker ADD CONSTRAINT pk_rtracker PRIMARY KEY (tracker_id);
CREATE INDEX idx_tracker ON rtracker (key_value, key_type, owner_id);
CREATE INDEX idx_rt_key_value ON rtracker ( key_value ASC );
CREATE INDEX idx_rt_key_type ON rtracker ( key_type ASC );
CREATE INDEX idx_rt_owner_id ON rtracker ( owner_id ASC );
delete from NextKeyValue where KeyName='rtrack';
insert into NextKeyValue(KeyName, KeyValue) VALUES ('rtrack', 0);

CREATE TABLE locale_entries (
	id 				integer NOT NULL,
	locale_id		integer NOT NULL,
	language_code	char(2) NOT NULL,
	country_code    char(2) NOT NULL,
	variant			varchar(16) NOT NULL,
	description		varchar(64)
);
ALTER TABLE locale_entries ADD CONSTRAINT pk_locale_entries PRIMARY KEY (id);
insert into locale_entries (id, locale_id, language_code, country_code, variant, description) values (1, 1, 'en', 'US', '*', 'US English');
insert into locale_entries (id, locale_id, language_code, country_code, variant, description) values (2, 1, 'en', '*', '*', 'English');

CREATE TABLE auto_save_store
(
    work_item_id	        integer NOT NULL,
    transaction_id          varchar(25) NOT NULL,
    page_id					varchar(100),
	screen_data				text,
	auto_saved				smallint NOT NULL,
	last_update_by		    varchar(128),
	last_update			    datetime NOT NULL,
	url						varchar(1000)
);
ALTER TABLE auto_save_store ADD CONSTRAINT pk_autosave PRIMARY KEY (work_item_id, transaction_id);

CREATE TABLE work_item_assistant_file_att
(
	wi_assistant_id 	integer NOT NULL,
	work_item_id 		integer NOT NULL,
    page_id				varchar(100),
	file_name 			varchar(100),
    file_image 			image,
	content_type 		varchar(100),
	file_type			varchar(100),
	section_id	    	varchar(100) NOT NULL,
	file_size			integer,
    entered_by 			varchar(128) NOT NULL,
	entered_by_name 	varchar(100),
    creation_time 		datetime NOT NULL
);
ALTER TABLE work_item_assistant_file_att ADD CONSTRAINT pk_WIA_file PRIMARY KEY (wi_assistant_id);
CREATE INDEX idx_act_file_1 on work_item_assistant_file_att(work_item_id ASC);

insert into NextKeyValue(KeyName, KeyValue) VALUES ('WIAssistantFileAttachment', 1);

CREATE TABLE work_item_assistant_comments
(
	wi_assistant_id 	integer NOT NULL,
	work_item_id 		integer NOT NULL,
    page_id				varchar(100),
	comment_text		text,
	section_id	    	varchar(100) NOT NULL,
    entered_by 			varchar(128) NOT NULL,
	entered_by_name 	varchar(100),
    creation_time 		datetime NOT NULL
);
ALTER TABLE work_item_assistant_comments ADD CONSTRAINT pk_WIA_comments PRIMARY KEY (wi_assistant_id);
CREATE INDEX idx_act_com_1 on work_item_assistant_comments(work_item_id ASC);

insert into NextKeyValue(KeyName, KeyValue) VALUES ('WIAssistantComments', 1);

CREATE TABLE tvr_tracker
(
	tvr_tracker_id 		integer NOT NULL,			/* IO implementation also supports a character based id */
	locale_id			integer NOT NULL,
	last_time_run		datetime,
	page_last_updated  	varchar(64),
	num_issues			integer,
	last_impactful_change_on datetime,
	page_tvr_run_on		varchar(64)
);
CREATE INDEX idx_tvr_tr ON tvr_tracker (tvr_tracker_id, locale_id);

CREATE TABLE tvr_results(
	tvr_results_id 		integer NOT NULL, 			/* IO implementation also supports a character based id */
	locale_id			integer NOT NULL,
	validation_text 	varchar(1024) NOT NULL,
	entity_compound_key varchar(512) NOT NULL,
	validation_category integer NOT NULL,
	field_roster_index 	varchar(128),
	field_value 		varchar(256),
	entity_label 		varchar(1024),
	rule_id				varchar(256),
	page_id				varchar(100)
);
CREATE INDEX idx_tvr_res ON tvr_results (tvr_results_id, locale_id);

CREATE TABLE code_list
(
	code_list_id 		integer NOT NULL,
	locale_id			integer NOT NULL,
	value			  	varchar(24) NOT NULL,
	title				varchar(50) NOT NULL
	
);
ALTER TABLE code_list ADD CONSTRAINT pk_code_list PRIMARY KEY (code_list_id, value, locale_id);
CREATE INDEX idx_code_list ON code_list(value, locale_id);

delete from code_list;	

/* Transaction types */
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'ENDORSEMENT', 'Endorsement'); 	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'RENEWAL', 'Renewal'); 	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'REISSUE', 'Reissue'); 	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'NEW_BUSINESS', 'Full Application'); 	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'QUICK_QUOTE', 'Quick Quote'); 	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'INTERVIEW', 'Interview');
/* 4.5 Account Management */ 
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'ACCOUNT', 'Account');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(100, 1, 'CLAIM', 'Claim');
	
	
/* LOB Codes */
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'AUTOB', 'Commercial Auto');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'AUTOP', 'Personal Auto');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'BANDM', 'Boiler and Machinery');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'BOAT', 'Watercraft');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'BOP', 'Business Owners');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'BOPGL', 'BOP Liability');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'BOPPR', 'BOP Property');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CAVN', 'Commercial Aviation');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CEQFL', 'Contractors Equipment Floater');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CFIRE', 'Commercial Fire');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CFRM', 'Farm Owners');				
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CGL', 'Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'COMAR', 'Commercial Articles');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'COMR', 'Ocean Marine');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CONTR', 'Contract');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CPKGE', 'Commercial Package');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CPMP', 'Commercial Multi Peril');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CRIM', 'Crime');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'CRIME', 'Crime (includes Burglary)');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'DFIRE', 'Dwelling Fire');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'DISAB', 'Disability');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'DO', 'Directors And Officers');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EDP', 'Computers');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EL', 'Employers Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EO', 'Errors and Omissions');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EPLI', 'Employment Practices Liability Insurance');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EQ', 'Earthquake');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EQPFL', 'Equipment Floater');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'EXLIA', 'Excess Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'FIDTY', 'Fidelity');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'FINEA', 'Fine Arts');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'FLOOD', 'Flood');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'GARAG', 'Garage and Dealers');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'GL', 'General Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'GLASS', 'Glass');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'HBB', 'Home Based Business');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'HOME', 'Homeowners');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'INBR', 'Installation/Builders Risk');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'INMAR', 'Inland Marine');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'INMRC', 'Inland Marine (commercial)');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'INMRP', 'Inland Marine (personal lines)');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'JUDCL', 'Judicial');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'LICPT', 'License and Permit');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'LSTIN', 'Lost Instrument');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'MHOME', 'Mobile Homeowners');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'MMAL', 'Medical Malpractice');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'MTRTK', 'Motor Truck Cargo');		
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'NWFGR', 'New Financial Guarantee');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'OLIB', 'Other Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PAPER', 'Valuable papers');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PHYS', 'Physicians and Surgeons');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PPKGE', 'Personal Package');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PROP', 'Property (includes Dwelling and Fire)');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PROPC', 'Commercial Property');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PUBOF', 'Public Official');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'RECV', 'Recreational Vehicles');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'SCAP', 'Small Commercial Package');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'SCHPR', 'Scheduled Property');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'SFRNC', 'Small Farm/Ranch');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'SIGNS', 'Signs');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'SMP', 'Special Multi-Peril');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'TRANS', 'Transportation');			
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'TRUCK', 'Truckers');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'UMBRC', 'Umbrella - Commercial');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'UMBRL', 'Umbrella');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'UMBRP', 'Umbrella - Personal (excess indemnity)');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'UN', 'Unknown');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'WCMA', 'Workers Comp Marine');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'WIND', 'Wind Policy');	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'WORK', 'Workers Comp');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'WORKP', 'Workers Comp Participating');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'Commercial', 'Commercial');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'Personal', 'Personal');
	
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'PROF', 'Professional Liability');
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES (200, 1, 'MROF', 'Management Liability');
	
	
/* 4.5 Account Management */ 
INSERT INTO code_list(code_list_id, locale_id, value, title)
	VALUES(200, 1, 'ACCOUNT', 'Account');

	

/* id_store table to be used by com.agencyport.id.IdProvider */
CREATE TABLE id_store ( 
    key_value varchar(255) NOT NULL, 
    key_type varchar(16) NOT NULL, 
    id_value bigint NOT NULL 
); 
ALTER TABLE id_store ADD CONSTRAINT pk_id_store PRIMARY KEY (key_value, key_type); 
CREATE UNIQUE INDEX idx_id_store ON id_store ( id_value, key_type ); 

/*These tables are for the Timeline feature and Audit*/
/*AUDIT TABLE */
CREATE TABLE audit_core(
	audit_id bigint NOT NULL,
	audit_type varchar(50) NOT NULL,
	work_item_id integer,
	create_time datetime NOT NULL,
	created_by varchar(50),
	user_group_id  varchar(32),
	user_group_name varchar(50)
);

ALTER TABLE audit_core ADD CONSTRAINT pk_auditcore PRIMARY KEY (audit_id);
CREATE INDEX idx_audit_user_group ON audit_core ( user_group_id ASC );

delete from NextKeyValue where KeyName='audit_core';
insert into NextKeyValue(KeyName, KeyValue) VALUES ('audit_core', 0);

/*AUDIT_STATUS*/
CREATE TABLE audit_status(
	audit_id bigint NOT NULL,
	old_status integer NOT NULL,
	status integer NOT NULL,
	last_page_id varchar(100)
);

ALTER TABLE audit_status ADD CONSTRAINT pk_audit_statuses PRIMARY KEY (audit_id);


/*AUDIT_WORKITEM*/
CREATE TABLE audit_workitem(
	audit_id bigint NOT NULL,
	page_id varchar(100),
	description varchar(2000)
);

ALTER TABLE audit_workitem ADD CONSTRAINT pk_audit_workitems PRIMARY KEY (audit_id);

/*AUDIT_RULE    */
CREATE TABLE audit_rule(
    audit_rule_id bigint NOT NULL,
	audit_id bigint NOT NULL,
	rule_name  varchar(100) NOT NULL,
	severity varchar(20) NOT NULL,
	page_id varchar(100) NOT NULL,
	message varchar(512) NOT NULL,
	message_class varchar(255)
);

ALTER TABLE audit_rule ADD CONSTRAINT pk_audit_rules PRIMARY KEY (audit_rule_id);
CREATE INDEX idx_audit_rule_name ON audit_rule ( rule_name ASC );
CREATE INDEX idx_audit_rule_page ON audit_rule ( page_id ASC );

delete from NextKeyValue where KeyName='audit_rule';
insert into NextKeyValue(KeyName, KeyValue) VALUES ('audit_rule', 0);

/*AUDITE_XMLSTORE */
CREATE TABLE audit_xmlstore
(
    audit_id	        bigint NOT NULL,
	xmlstring			xml NOT NULL
);
ALTER TABLE audit_xmlstore ADD CONSTRAINT pk_audit_xmlstore PRIMARY KEY (audit_id);


/*AUDTIT_MISC for admin, security, toolkit and others */
CREATE TABLE audit_misc (
	audit_id bigint NOT NULL,
	success_flag char(1) NOT NULL,
	actor_link_value varchar(64) NOT NULL,
	actor_link_type varchar(64) NOT NULL,
	actor_link_short_name varchar(128) NOT NULL,
	action_code varchar(16) NOT NULL,
	target_link_value varchar(64) NOT NULL,
	target_link_type varchar(64) NOT NULL,
	target_link_short_name varchar(128) NOT NULL,
	target2_link_value varchar(64),
	target2_link_type varchar(64),
	target2_link_short_name varchar(128),
	description varchar(512)
);
ALTER TABLE audit_misc ADD CONSTRAINT pk_audit_misc PRIMARY KEY (audit_id);
CREATE INDEX idx_audit_actor_lvalue ON audit_misc ( actor_link_value ASC );
CREATE INDEX idx_audit_actor_ltype ON audit_misc ( actor_link_type ASC );
CREATE INDEX idx_audit_trg_lvalue ON audit_misc ( target_link_value ASC );
CREATE INDEX idx_audit_trg_ltype ON audit_misc ( target_link_type ASC );
CREATE INDEX idx_audit_trg2_lvalue ON audit_misc ( target2_link_value ASC );
CREATE INDEX idx_audit_trg2_ltype ON audit_misc ( target2_link_type ASC );

/* 4.5 Account Management */
CREATE TABLE account
(
   	account_id	        	integer NOT NULL,
    user_group_id           integer NOT NULL,
    creator_id				integer NOT NULL,
	owner_id				integer NOT NULL,
	owner_group_id          integer NOT NULL,
    status                  integer NOT NULL,
	broad_LOB               varchar(10) NOT NULL,
    creation_time           datetime,
	entity_name             varchar(120),
	other_name				varchar(120),
	phone_number			varchar(20),
	address					varchar(256),
	city					varchar(64),
	state_prov_cd			varchar(2),
	postal_code				varchar(10),
	transaction_id          varchar(25) NOT NULL,
 	last_update_by		    varchar(128) NOT NULL,
	last_update_time	    datetime NOT NULL,
	commit_flag             smallint NOT NULL,
   	account_number  		varchar(120),
    account_type			char(1),
   	account_pas_id			varchar(120)	
);
ALTER TABLE account ADD CONSTRAINT pk_account PRIMARY KEY (account_id);
CREATE INDEX idx_ac_1 ON account ( user_group_id ASC );
CREATE INDEX idx_ac_2 ON account ( entity_name ASC );

CREATE TABLE account_member
(
   	account_id	        	integer NOT NULL,
   	work_item_id			integer NOT NULL
);
ALTER TABLE account_member ADD CONSTRAINT pk_acc_mem PRIMARY KEY (account_id, work_item_id); 
CREATE INDEX idx_ac_mem_1 ON account_member ( account_id ASC );
CREATE INDEX idx_ac_mem_2 ON account_member ( work_item_id ASC );


CREATE TABLE work_list_saved_filters (
	user_name		varchar(80) NOT NULL,
	filter_name		varchar(80) NOT NULL,
	filter_xml		xml NOT NULL,
	locale_id		integer NOT NULL,
	work_list_id 	integer NOT NULL
);
ALTER TABLE work_list_saved_filters ADD CONSTRAINT pk_wl_saved_flt PRIMARY KEY (user_name, filter_name);

CREATE TABLE work_list_search_detail (
	id				integer NOT NULL,
	code_list_id	integer NOT NULL,
	value			varchar(24) NOT NULL
);
ALTER TABLE work_list_search_detail ADD CONSTRAINT pk_wl_srch_dtl PRIMARY KEY (code_list_id, value);

delete from work_list_search_detail;
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(1, 100, 'ENDORSEMENT'); 	
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(2, 100, 'RENEWAL'); 	
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(3, 100, 'REISSUE'); 	
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(4, 100, 'NEW_BUSINESS'); 	
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(5, 100, 'QUICK_QUOTE'); 	
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(6, 100, 'INTERVIEW');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES(7, 100, 'CLAIM');

INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (7, 200, 'AUTOB');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (8, 200, 'AUTOP');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (9, 200, 'BOP');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (10, 200, 'CGL');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (11, 200, 'CFRM');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (12, 200, 'CPKGE');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (13, 200, 'CRIME');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (14, 200, 'HOME');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (15, 200, 'INMRC');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (16, 200, 'PROPC');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (17,200, 'WORK');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (18, 200, 'UMBRC');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (19, 200, 'UMBRP');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (20, 200, 'EXLIA');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (21, 200, 'PROF');
INSERT INTO work_list_search_detail(id, code_list_id, value)
	VALUES (22, 200, 'MROF');

CREATE TABLE external_relation
(
    relation_type	char NOT NULL,
   	internal_id	    integer NOT NULL,
    external_id     varchar(32) NOT NULL
);
ALTER TABLE external_relation ADD CONSTRAINT pk_ext_relat PRIMARY KEY (relation_type, internal_id, external_id);
CREATE UNIQUE INDEX ext_relation_1 ON external_relation ( relation_type ASC, internal_id ASC );
CREATE UNIQUE INDEX ext_relation_2 ON external_relation ( relation_type ASC, external_id ASC );

CREATE TABLE turnstile_upload_queue (
	guid					varchar(100) NOT NULL,
	status					integer NOT NULL,
	message					varchar(256),
	responsexml				image,
    user_group_id           integer NOT NULL,
    creator_id				integer NOT NULL,
	owner_id				integer NOT NULL,
	owner_group_id          integer NOT NULL,		
 	last_update_by		    varchar(128) NOT NULL,
	last_update_time	    datetime NOT NULL
);

ALTER TABLE turnstile_upload_queue ADD CONSTRAINT pk_upload_queue PRIMARY KEY (guid);
CREATE INDEX idx_upload_queue_1 ON turnstile_upload_queue ( status, last_update_by);
CREATE INDEX idx_upload_queue_2 ON turnstile_upload_queue (last_update_time);

CREATE TABLE turnstile_files
(
	file_id 			integer NOT NULL,
	file_name			varchar(100) NOT NULL,
    file_image 			image NOT NULL,
	content_type 		varchar(100),
	file_size			integer,
	queue_guid			varchar(100) NOT NULL
);
ALTER TABLE turnstile_files ADD CONSTRAINT pk_tss_file PRIMARY KEY (file_id);

delete from NextKeyValue where KeyName='turnstileFiles';
insert into NextKeyValue(KeyName, KeyValue) VALUES ('turnstileFiles', 1);
