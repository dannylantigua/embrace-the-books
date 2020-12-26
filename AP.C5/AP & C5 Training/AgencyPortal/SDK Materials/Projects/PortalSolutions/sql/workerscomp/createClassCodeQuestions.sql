

drop table IF EXISTS CLASS_CODE_QUESTIONS;
CREATE TABLE CLASS_CODE_QUESTIONS 
( 	CLASS_CODE_ID 			VARCHAR (4)  NOT NULL ,
	QUESTION_ID 			VARCHAR (20) NOT NULL,
	DESCRIPTION 			VARCHAR (200) NOT NULL 
) ;
CREATE UNIQUE INDEX IDX_CLASS_CODE_QUESTIONS_1 ON CLASS_CODE_QUESTIONS (CLASS_CODE_ID ASC,QUESTION_ID ASC,DESCRIPTION ASC);

Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION) VALUES ('0005','WORKCLCDQ01','Is the insured a street vendor?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION) VALUES ('0005','WORKCLCDQ02','Does the insured operate a warehouse to supply the retail stores?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0005','WORKCLCDQ03','Does the insured operate a mail order business in conjunction with retail store locations?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0005','WORKCLCDQ04','Does the insured principally sell: paint, floor covering, office machines, household appliances, christmas trees, pets, beer, soft drinks, wine or liquor?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0005','WORKCLCDQ05','Does the insured principally sell: fireworks, pornography, firearms, guns, weapons or ammunition?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0005','WORKCLCDQ06','Does the insured operate an arcade?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ01','Is the insured a street vendor?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ02','Does the insured operate a warehouse to supply the retail stores?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ03','Does the insured operate a mail order business in conjunction with retail store locations?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ04','Does the insured principally sell: paint, floor covering, office machines, household appliances, christmas trees, pets, beer, soft drinks, wine or liquor?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ05','Does the insured principally sell: fireworks, pornography, firearms, guns, weapons or ammunition?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ06','Does the insured operate an arcade?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0008','WORKCLCDQ07','Does the insured operate as an auctioneer or auction house?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ02','Does the insured operate a warehouse to supply the retail stores?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ03','Does the insured operate a mail order business in conjunction with retail store locations?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ04','Does the insured principally sell: paint, floor covering, office machines, household appliances, christmas trees, pets, beer, soft drinks, wine or liquor?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ05','Does the insured principally sell: fireworks, pornography, firearms, guns, weapons or ammunition?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ06','Does the insured operate an arcade?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ11','Does the insured provide installation and repair service?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ16','Does the insured pick up and/or deliver to customers?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('0016','WORKCLCDQ26','Is at least one employee (on duty) trained in administering first aid?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9501','WORKCLCDQ27','Are employees required to wear gloves and masks when working with patients?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9501','WORKCLCDQ28','Are all work stations ergonomically designed to prevent repetitive motion injuries?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9501','WORKCLCDQ29','Are ear and eye protection required?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9501','WORKCLCDQ30','Is there random drug testing of drivers after hire?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9600','WORKCLCDQ29','Are ear and eye protection required?' );
Insert into CLASS_CODE_QUESTIONS(CLASS_CODE_ID, QUESTION_ID, DESCRIPTION ) VALUES ('9600','WORKCLCDQ30','Is there random drug testing of drivers after hire?' );
