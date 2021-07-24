-- create database

drop database if exists grato;

create database grato;
use grato;
drop table if exists subject;
create table subject
(
	id varchar(55) primary key,
    image varchar(55),
    name varchar(255)
);

drop table if exists subject_in_semester;
create table subject_in_semester
(
	sub_id varchar(55),
    semester_id int,
    primary key (sub_id, semester_id),
	foreign key (sub_id)
		references subject(id)
        on delete cascade
        on update cascade
);

drop table if exists class;
create table class
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    room varchar(55),
    start_time varchar(55),
    end_time varchar(55),
    primary key (sub_id, semester_id, class_id),
	foreign key (sub_id, semester_id)
		references subject_in_semester(sub_id, semester_id)
        on delete cascade
        on update cascade
);

drop table if exists `group`;
create table `group`
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    gname varchar(255),
    no_student int default 0,
    max_student int not null,
    primary key (sub_id, semester_id, class_id, gname),
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade
);

drop table if exists creator_group;
create table creator_group
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    gname varchar(255),
    user_id varchar(55),
    primary key (sub_id, semester_id, class_id, user_id),
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade
);

drop table if exists exam;
create table exam
(
	sub_id varchar(55),
    semester_id int,
    exam_name varchar(255),
    no_question int not null,
    primary key (sub_id, semester_id, exam_name),
	foreign key (sub_id, semester_id)
		references subject_in_semester(sub_id, semester_id)
        on delete cascade
        on update cascade
);

drop table if exists exam_code;
create table exam_code
(
	sub_id varchar(55),
    semester_id int,
    exam_name varchar(255),
    exam_code_id varchar(55),
    key_answer varchar(55),
    primary key (sub_id, semester_id, exam_name, exam_code_id),
	foreign key (sub_id, semester_id, exam_name)
		references exam(sub_id, semester_id, exam_name)
        on delete cascade
        on update cascade
);

drop table if exists quiz;
create table quiz
(
	sub_id varchar(55),
    semester_id int,
    quiz_name varchar(255),
    max_time int not null,
    no_question int not null,
    deadline datetime,
    primary key (sub_id, semester_id, quiz_name),
	foreign key (sub_id, semester_id)
		references subject_in_semester(sub_id, semester_id)
        on delete cascade
        on update cascade
);

drop table if exists quiz_of_class;
create table quiz_of_class
(
	sub_id varchar(55),
    semester_id int,
    quiz_name varchar(255),
    class_id varchar(55),
    primary key (sub_id, semester_id, quiz_name, class_id),
	foreign key (sub_id, semester_id, quiz_name)
		references quiz(sub_id, semester_id, quiz_name)
        on delete cascade
        on update cascade,
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade
);

drop table if exists question;
create table question
(
	sub_id varchar(55),
    semester_id int,
    quiz_name varchar(255),
    question_id int,
    content text,
    primary key (sub_id, semester_id, quiz_name, question_id),
	foreign key (sub_id, semester_id, quiz_name)
		references quiz(sub_id, semester_id, quiz_name)
        on delete cascade
        on update cascade
);

drop table if exists answer;
create table answer
(
	sub_id varchar(55),
    semester_id int,
    quiz_name varchar(255),
    question_id int,
    answer_id varchar(1),
    right_answer bool,
    content text,
    primary key (sub_id, semester_id, quiz_name, question_id, answer_id),
	foreign key (sub_id, semester_id, quiz_name, question_id)
		references question(sub_id, semester_id, quiz_name, question_id)
        on delete cascade
        on update cascade
);


-- User ------------------
drop table if exists user;
create table user
(
	id varchar(55) primary key,
    hashed_pass text not null,
    name varchar(255) not null,
    job_type enum('GV', 'SV') not null
);


drop table if exists user_of_subject_in_semester;
create table user_of_subject_in_semester
(
	sub_id varchar(55),
    semester_id int,
    user_id varchar(55),
    primary key (sub_id, semester_id, user_id),
	foreign key (sub_id, semester_id)
		references subject_in_semester(sub_id, semester_id)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

drop table if exists user_of_class;
create table user_of_class
(
	sub_id varchar(55),
    semester_id int,
	class_id varchar(55),
    user_id varchar(55),
    primary key (user_id,sub_id,semester_id),
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);


drop table if exists teacher_of_class;
create table teacher_of_class
(
	sub_id varchar(55),
    semester_id int,
	class_id varchar(55),
    user_id varchar(55),
    primary key (user_id, sub_id, semester_id, class_id),
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

drop table if exists student_attend_class;
create table student_attend_class
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    date datetime,
    user_id varchar(55),
    primary key (user_id, date),
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

drop table if exists student_in_group;
create table student_in_group
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    gname varchar(255),
    user_id varchar(55),
    primary key (user_id, sub_id, semester_id, class_id),
	foreign key (sub_id, semester_id, class_id, gname)
		references `group`(sub_id, semester_id, class_id, gname)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

drop table if exists student_do_exam_code;
create table student_do_exam_code
(
	sub_id varchar(55),
    semester_id int,
    exam_name varchar(255),
    exam_code_id varchar(55),
    user_id varchar(55),
    score double not null,
    student_answer varchar(255),
    image_scan varchar(255),
    primary key (sub_id, semester_id, exam_name, exam_code_id, user_id),
	foreign key (sub_id, semester_id, exam_name, exam_code_id)
		references exam_code(sub_id, semester_id, exam_name, exam_code_id)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

drop table if exists student_do_quiz;
create table student_do_quiz
(
	sub_id varchar(55),
    semester_id int,
    quiz_name varchar(255),
    user_id varchar(55) not null,
    student_answer varchar(55) not null,
    time double not null,
    score double not null,
    primary key (sub_id, semester_id, quiz_name, user_id),
	foreign key (sub_id, semester_id, quiz_name)
		references quiz(sub_id, semester_id, quiz_name)
        on delete cascade
        on update cascade,
	foreign key (user_id)
		references user(id)
        on delete cascade
        on update cascade
);

Insert into subject (id, image, name) values ('CH1003', 'bk.png', 'Hoa dai cuong');
Insert into subject (id, image, name) values ('MT1003', 'bk.png', 'Giao duc quoc phong');
Insert into subject (id, image, name) values ('PH1003', 'bk.png', 'Vat ly 1');
Insert into subject (id, image, name) values ('CO1005', 'bk.png', 'Nhap mon dien toan');
Insert into subject (id, image, name) values ('CO1007', 'bk.png', 'Cau truc roi rac');
Insert into subject (id, image, name) values ('MT1005', 'bk.png', 'Giai tich 2');
Insert into subject (id, image, name) values ('MT1007', 'bk.png', 'Dai so tuyen tinh');
Insert into subject (id, image, name) values ('CO1009', 'bk.png', 'Phuong phap tinh');
Insert into subject (id, image, name) values ('CO2007', 'bk.png', 'Kien truc may tinh');
Insert into subject (id, image, name) values ('CO2005', 'bk.png', 'Lap trinh huong doi tuong');
Insert into subject (id, image, name) values ('CO2003', 'bk.png', 'Cau truc du lieu va giai thuat');
Insert into subject (id, image, name) values ('PH1005', 'bk.png', 'Vat ly 2');
Insert into subject (id, image, name) values ('MT2001', 'bk.png', 'Xac suat va thong ke');
Insert into subject (id, image, name) values ('CO2011', 'bk.png', 'Mo hinh hoa toan hoc');
Insert into subject (id, image, name) values ('CO3001', 'bk.png', 'Cong nghe phan mem');
Insert into subject (id, image, name) values ('CO2017', 'bk.png', 'He dieu hanh');
Insert into subject (id, image, name) values ('CO2001', 'bk.png', 'Ky nang chuyen nghiep cho ky su');
Insert into subject (id, image, name) values ('SP1007', 'bk.png', 'Phap luat');
Insert into subject (id, image, name) values ('CO2013', 'bk.png', 'He co so du lieu');
Insert into subject (id, image, name) values ('CO3003', 'bk.png', 'Mang may tinh');
Insert into subject (id, image, name) values ('CO3005', 'bk.png', 'Nguyen ly ngon ngu lap trinh');

Insert into subject_in_semester (sub_id, semester_id) values ('CO3005', 202);
Insert into subject_in_semester (sub_id, semester_id) values ('SP1007', 202);
Insert into subject_in_semester (sub_id, semester_id) values ('CO3003', 202);
Insert into subject_in_semester (sub_id, semester_id) values ('CO2013', 202);

Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO2013', 202,'L01','221H1','7:00 AM','9:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO2013', 202,'L02','221H1','9:00 AM','11:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO2013', 202,'L03','410H1','7:00 AM','9:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO2013', 202,'L04','410H1','9:00 AM','11:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO3003', 202,'L01','212H1','7:00 AM','9:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO3003', 202,'L02','212H1','9:00 AM','11:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('SP1007', 202,'L01','112H1','9:00 AM','11:00 AM');
Insert into class (sub_id, semester_id,class_id,room,start_time,end_time) values ('CO3005', 202,'L01','210H1','9:00 AM','11:00 AM');

-- Insert into `group` (sub_id, semester_id,class_id,gname,no_student,max_student,creator) values ('CO3005', 202,'L01','Alias',4,5);
-- Insert into `group` (sub_id, semester_id,class_id,gname,no_student,max_student,creator) values ('CO3005', 202,'L01','Efien',4,5);
-- Insert into `group` (sub_id, semester_id,class_id,gname,no_student,max_student,creator) values ('CO3005', 202,'L01','Catus',4,5);
-- Insert into `group` (sub_id, semester_id,class_id,gname,no_student,max_student,creator) values ('CO3005', 202,'L01','Lancelot',3,5);

Insert into exam (sub_id, semester_id,exam_name,no_question) values ('CO3005', 202,'KTGK',30);
Insert into exam (sub_id, semester_id,exam_name,no_question) values ('CO3005', 202,'KTCK',30);
Insert into exam (sub_id, semester_id,exam_name,no_question) values ('CO3005', 202,'BTN',10);
Insert into exam (sub_id, semester_id,exam_name,no_question) values ('CO3005', 202,'BTL',10);

Insert into exam_code (sub_id, semester_id,exam_name,exam_code_id,key_answer) values ('CO3005', 202,'KTGK','001','BCDDDBBCBCCDADBACDADACBDCDBCDA');
Insert into exam_code (sub_id, semester_id,exam_name,exam_code_id,key_answer) values ('CO3005', 202,'KTCK','002','ABBBABCDCDBBADBCBACDBAACDAADCC');
Insert into exam_code (sub_id, semester_id,exam_name,exam_code_id,key_answer) values ('CO3005', 202,'BTN','003','CDAAAACDAA');
Insert into exam_code (sub_id, semester_id,exam_name,exam_code_id,key_answer) values ('CO3005', 202,'BTL','004','BBDDDBCDBC');

Insert into quiz (sub_id, semester_id,quiz_name,max_time,no_question,deadline) values ('CO3005', 202,'Quiz1: Lexical',20,2,'2021-04-30');
Insert into quiz (sub_id, semester_id,quiz_name,max_time,no_question,deadline) values ('CO3005', 202,'Quiz2: Syntax',20,1,'2021-04-30');
Insert into quiz (sub_id, semester_id,quiz_name,max_time,no_question,deadline) values ('CO3005', 202,'Quiz3: OOP',20,2,'2021-04-30');

Insert into quiz_of_class (sub_id, semester_id,quiz_name,class_id) values ('CO3005', 202,'Quiz1: Lexical','L01');
Insert into quiz_of_class (sub_id, semester_id,quiz_name,class_id) values ('CO3005', 202,'Quiz2: Syntax','L01');
Insert into quiz_of_class (sub_id, semester_id,quiz_name,class_id) values ('CO3005', 202,'Quiz3: OOP','L01');

Insert into question (sub_id, semester_id,quiz_name,question_id,content) values ('CO3005', 202,'Quiz1: Lexical',1,'1+1 = ?');
Insert into question (sub_id, semester_id,quiz_name,question_id,content) values ('CO3005', 202,'Quiz1: Lexical',2,'if(a):a?b');
Insert into question (sub_id, semester_id,quiz_name,question_id,content) values ('CO3005', 202,'Quiz2: Syntax',1,'2+2 = ?');
Insert into question (sub_id, semester_id,quiz_name,question_id,content) values ('CO3005', 202,'Quiz3: OOP',1,'3+3 = ?');
Insert into question (sub_id, semester_id,quiz_name,question_id,content) values ('CO3005', 202,'Quiz3: OOP',2,'B a = new A b');

Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz1: Lexical',1,'A',true,'2');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz1: Lexical',1,'B',false,'3');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz1: Lexical',1,'C',false,'4');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz1: Lexical',2,'A',true,'true');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz1: Lexical',2,'B',false,'false');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz2: Syntax',1,'A',true,'4');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz2: Syntax',1,'B',false,'5');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz2: Syntax',1,'C',false,'6');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz3: OOP',1,'A',true,'6');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz3: OOP',1,'B',false,'7');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz3: OOP',1,'C',false,'8');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz3: OOP',2,'A',true,'true');
Insert into answer (sub_id, semester_id,quiz_name,question_id,answer_id,right_answer,content) values ('CO3005', 202,'Quiz3: OOP',2,'B',false,'false');

Insert into user (id,name,job_type,hashed_pass) values ('1111111', 'Ho Thien Long','SV','hashed_pass');
Insert into user (id,name,job_type,hashed_pass) values ('2222222', 'Nguyen Phi Thong','SV','hashed_pass');
Insert into user (id,name,job_type,hashed_pass) values ('3333333', 'Phan Van Truong','SV','hashed_pass');
Insert into user (id,name,job_type,hashed_pass) values ('4444444', 'Nguyen Quang Tung','SV','hashed_pass');
Insert into user (id,name,job_type,hashed_pass) values ('5555555', 'Luu Quang Huan','GV','hashed_pass');

Insert into user_of_subject_in_semester (sub_id,semester_id,user_id) values ('CO3005', 202,'1111111');
Insert into user_of_subject_in_semester (sub_id,semester_id,user_id) values ('CO3005', 202,'2222222');
Insert into user_of_subject_in_semester (sub_id,semester_id,user_id) values ('CO3005', 202,'3333333');
Insert into user_of_subject_in_semester (sub_id,semester_id,user_id) values ('CO3005', 202,'4444444');

Insert into user_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','4444444');
Insert into user_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','3333333');
Insert into user_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','1111111');
Insert into user_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','2222222');
-- Insert into user_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','5555555');
Insert into teacher_of_class (sub_id,semester_id,class_id,user_id) values ('CO3005', 202,'L01','5555555');

Insert into student_attend_class (sub_id,semester_id,class_id,date,user_id) values ('CO3005',202,'L01','2021-04-30','1111111');
Insert into student_attend_class (sub_id,semester_id,class_id,date,user_id) values ('CO3005',202,'L01','2021-04-30','2222222');
Insert into student_attend_class (sub_id,semester_id,class_id,date,user_id) values ('CO3005',202,'L01','2021-04-30','3333333');
Insert into student_attend_class (sub_id,semester_id,class_id,date,user_id) values ('CO3005',202,'L01','2021-04-30','4444444');

-- Insert into student_in_group (sub_id,semester_id,class_id,gname,user_id) values ('CO3005', 202,'L01','Alias','1111111');
-- Insert into student_in_group (sub_id,semester_id,class_id,gname,user_id) values ('CO3005',202,'L01','Alias','2222222');
-- Insert into student_in_group (sub_id,semester_id,class_id,gname,user_id) values ('CO3005',202,'L01','Alias','3333333');
-- Insert into student_in_group (sub_id,semester_id,class_id,gname,user_id) values ('CO3005',202,'L01','Lancelot','4444444');

Insert into student_do_exam_code (sub_id,semester_id,exam_name,exam_code_id,user_id,score,student_answer) values ('CO3005',202,'BTL','004','4444444',0.0,'CCAAACDACD');
Insert into student_do_exam_code (sub_id,semester_id,exam_name,exam_code_id,user_id,score,student_answer) values ('CO3005',202,'BTL','004','1111111',1.0,'BCAAACDACD');

Insert into student_do_quiz (sub_id,semester_id,quiz_name,user_id,student_answer,time,score) values ('CO3005',202,'Quiz1: Lexical','2222222','AA',20,10.0);
Insert into student_do_quiz (sub_id,semester_id,quiz_name,user_id,student_answer,time,score) values ('CO3005',202,'Quiz1: Lexical','3333333','BA',10,5.0);


drop table if exists time_attendance;
create table time_attendance
(
	sub_id varchar(55),
    semester_id int,
    class_id varchar(55),
    start_time datetime,
    end_time datetime,
    primary key (start_time, end_time,sub_id, semester_id, class_id),
	foreign key (sub_id, semester_id, class_id)
		references class(sub_id, semester_id, class_id)
        on delete cascade
        on update cascade
);


-- create procedure 

-- nguyen phi thong
DELIMITER $$

DROP PROCEDURE IF EXISTS getNoMax $$
CREATE PROCEDURE getNomax(
				IN sub_id varchar(55),
                IN sem_id INT,
                IN class_id varchar(255),
                IN group_name varchar(255)
				)
BEGIN
    select no_student, max_student
    from `group` g
    where g.sub_id = sub_id and g.semester_id = sem_id and g.class_id = class_id and g.gname = group_name;
END; $$

DROP PROCEDURE IF EXISTS findGroup $$
CREATE PROCEDURE findGroup(
	user_id varchar(55),sub_id varchar(55), semester_id int, class_id varchar(55)
)
BEGIN
	SELECT gname
    From student_in_group s
    where s.user_id = user_id and s.sub_id = sub_id and s.semester_id = semester_id 
    and s.class_id = class_id;
END; $$

DROP PROCEDURE IF EXISTS inforclass $$
CREATE PROCEDURE inforClass(
	sub_id varchar(55), semester_id int, class_id varchar(55)
)
BEGIN
	SELECT image, sub_id, class_id, room, start_time, end_time, user.name
    FROM class, teacher_of_class t, user, subject
    WHERE class.sub_id = sub_id AND class.semester_id = semester_id AND class.class_id = class_id 
    AND t.user_id = user.id AND subject.id = sub_id;
END; $$

DROP PROCEDURE IF EXISTS joinsubject $$
CREATE PROCEDURE joinsubject(
	sub_id varchar(55), semester_id int, class_id varchar(55), user_id varchar(55)
)
BEGIN
	INSERT INTO user_of_class
    VALUES(sub_id,semester_id,class_id,user_id);
END; $$

DROP PROCEDURE IF EXISTS createClass_GV $$
CREATE PROCEDURE createClass_GV(
	sub_id varchar(55), semester_id int, class_id varchar(55),
    room varchar(55), start_time varchar(55), end_time varchar(55), user_id varchar(55)
)
BEGIN
	INSERT INTO class
    VALUES(sub_id,semester_id,class_id,room,start_time, end_time);
    INSERT INTO user_of_class
    VALUES(sub_id,semester_id,class_id,user_id);
END; $$

DROP PROCEDURE IF EXISTS listClass_GV $$
CREATE PROCEDURE listClass_GV(
	sub_id varchar(55), semester_id int, user_id varchar(55)
)
BEGIN
	select class_id
    from teacher_of_class t
    where t.user_id = user_id AND t.sub_id = sub_id AND t.semester_id = semester_id;
END; $$


DROP PROCEDURE IF EXISTS countstudent $$
CREATE PROCEDURE countstudent(
	class_id varchar(55), sub_id varchar(55), semester varchar(55)
)
BEGIN
	select ul.class_id, count(ul.user_id) count
    from user_of_class ul
    where ul.sub_id = sub_id AND ul.semester_id = semester
    group by ul.class_id
    having ul.class_id = class_id ;
END; $$

call countstudent("L01","CO3005",202);


DROP PROCEDURE IF EXISTS liststudentinclass $$
CREATE PROCEDURE liststudentinclass(
	sub_id varchar(55), semester_id int, class_id varchar(55)
	)
BEGIN
	select u.id, u.name
    from user_of_class ul, user u
    where s.sub_id=sub_id AND s.semester_id=semester_id AND s.class_id=class_id AND ul.user_id=u.id;
END;$$


DROP PROCEDURE IF EXISTS listgroup $$
CREATE PROCEDURE listgroup(
	sub_id varchar(55), semester_id int, class_id varchar(55)
	)
BEGIN
	select gname, no_student, max_student
    from `group`
    where `group`.sub_id = sub_id AND `group`.semester_id = semester_id 
    AND `group`.class_id = class_id;
END;$$


DROP PROCEDURE IF EXISTS listmemberingroup $$
CREATE PROCEDURE listmemberingroup(
	sub_id varchar(55), semester_id int, class_id varchar(55), gname varchar(55)
	)
BEGIN
	select u.id, u.name
    from user_of_class ul, user u, student_in_group s
    where s.sub_id=sub_id AND s.semester_id=semester_id AND s.class_id=class_id
    AND s.gname = gname AND s.user_id = ul.user_id AND ul.user_id=u.id;
END;$$



DROP PROCEDURE IF EXISTS joingroup $$
CREATE PROCEDURE joingroup(
	sub_id varchar(55), semester_id int, class_id varchar(55), gname varchar(55), 
    user_id varchar(55)
    )
BEGIN
    INSERT INTO student_in_group
    VALUES (sub_id, semester_id , class_id , gname, user_id);

	UPDATE `group` g
    SET no_student = no_student + 1
    WHERE g.sub_id=sub_id AND g.semester_id=semester_id 
    AND g.class_id=class_id AND g.gname =gname;
END; $$



DROP PROCEDURE IF EXISTS outgroup $$
CREATE PROCEDURE outgroup(
	sub_id varchar(55), semester_id int, class_id varchar(55), gname varchar(55), 
    user_id varchar(55)
    )
BEGIN
    DELETE from student_in_group s
    WHERE s.sub_id=sub_id AND s.semester_id=semester_id 
    AND s.class_id=class_id AND s.gname =gname AND s.user_id=user_id;
    
    UPDATE `group` g
    SET no_student = no_student -1
    WHERE g.sub_id=sub_id AND g.semester_id=semester_id 
    AND g.class_id=class_id AND g.gname =gname;
END; $$


DROP PROCEDURE IF EXISTS creategroup $$
CREATE PROCEDURE creategroup(
	sub_id varchar(55), semester_id int, class_id varchar(55), gname varchar(55), 
    no_student int, max_student int
    )
BEGIN
    INSERT INTO `group`
    VALUES (sub_id, semester_id , class_id , gname,no_student , max_student);
END; $$

DROP PROCEDURE IF EXISTS deleteGroup $$
CREATE PROCEDURE deleteGroup(
	sub_id varchar(55), semester_id int, class_id varchar(55), gname varchar(55)
    )
BEGIN
    Delete from `group` s
    where s.sub_id=sub_id AND s.semester_id=semester_id 
    AND s.class_id=class_id AND s.gname =gname;
END; $$

-- ho thien long

DROP PROCEDURE IF EXISTS create_user;
DELIMITER $$
CREATE PROCEDURE create_user
(
	id varchar(55), hashed_pass text, name varchar(255), job_type enum('GV','SV')
)
BEGIN
	insert user (id, hashed_pass, name, job_type)
    values (id, hashed_pass, name, job_type);
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

-- call create_user('1080','hashedpass', 'Ho Van Ten','GV');


DROP PROCEDURE IF EXISTS get_user;
DELIMITER $$
create procedure get_user
(
    id varchar(55), job_type enum('GV','SV')
)
begin
    select id, hashed_pass, job_type 
    from user u
    where u.id = id
		and u.job_type = job_type;
end$$
DELIMITER $$ ;

-- call get_user('1080', 'GV');

-- Quiz
DROP PROCEDURE IF EXISTS get_all_quiz_of_a_semester_proc;
DELIMITER $$
CREATE PROCEDURE get_all_quiz_of_a_semester_proc
(
	sub_id varchar(55), semester_id int
)
BEGIN
	select
		quiz_name,
        max_time,
        no_question,
        deadline
	from quiz q
    where q.sub_id = sub_id
		and q.semester_id = semester_id;
END $$
DELIMITER ;

-- call get_all_quiz_of_a_semester_proc('CO3005', 202);

DROP PROCEDURE IF EXISTS get_a_quiz_of_a_semester_proc;
DELIMITER $$
CREATE PROCEDURE get_a_quiz_of_a_semester_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255)
)
BEGIN
	select *
	from quiz q
    where q.sub_id = sub_id
		and q.semester_id = semester_id
		and q.quiz_name = quiz_name;
END $$
DELIMITER ;

-- call get_a_quiz_of_a_semester_proc('CO3005', 202, 'Quiz1: Lexical');


DROP PROCEDURE IF EXISTS add_quiz_proc;
DELIMITER $$
CREATE PROCEDURE add_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), max_time int, no_question int, deadline datetime
)
BEGIN
	insert quiz (sub_id, semester_id, quiz_name, max_time, no_question, deadline)
    values (sub_id, semester_id, quiz_name, max_time, no_question, deadline);
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

-- call add_quiz_proc("CO3005", 202, "Quiz4", 30, 5, '2021-06-01 23:59:59');


DROP PROCEDURE IF EXISTS modify_quiz_proc;
DELIMITER $$
CREATE PROCEDURE modify_quiz_proc
(
	sub_id varchar(55), semester_id int, old_quiz_name varchar(255), new_quiz_name varchar(255), max_time int, no_question int, deadline datetime
)
BEGIN
	update quiz q
    set q.quiz_name = new_quiz_name,
        q.max_time = max_time,
        q.no_question = no_question,
        q.deadline = deadline
	where q.sub_id = sub_id 
		and q.semester_id = semester_id
        and q.quiz_name = old_quiz_name;
END $$
DELIMITER ;

-- call modify_quiz_proc("CO3005", 202, "Quiz4", "Quiz5", 30, 5, '2021-06-01 23:59:59');


DROP PROCEDURE IF EXISTS delete_quiz_proc;
DELIMITER $$
CREATE PROCEDURE delete_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255)
)
BEGIN
	delete from quiz q
	where q.sub_id = sub_id 
		and q.semester_id = semester_id
        and q.quiz_name = quiz_name;
END $$
DELIMITER ;

-- call delete_quiz_proc("CO3005", 202, "Quiz6");

DROP PROCEDURE IF EXISTS teacher_get_all_quiz_of_class_proc;
DELIMITER $$
CREATE PROCEDURE teacher_get_all_quiz_of_class_proc
(
	sub_id varchar(55), semester_id int, class_id varchar(55)
)
BEGIN
	select *
	from quiz_of_class qoc
    where qoc.sub_id = sub_id
		and qoc.semester_id = semester_id
        and qoc.class_id = class_id;
END $$
DELIMITER ;

-- call teacher_get_all_quiz_of_class_proc('CO3005', 202, 'L01');

DROP PROCEDURE IF EXISTS get_all_class_of_quiz_proc;
DELIMITER $$
CREATE PROCEDURE get_all_class_of_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255)
)
BEGIN
	select *
	from quiz_of_class qoc
    where qoc.sub_id = sub_id
		and qoc.semester_id = semester_id
        and qoc.quiz_name = quiz_name;
END $$
DELIMITER ;

-- call get_all_class_of_quiz_proc('CO3005', 202, 'Quiz1: Lexical');


DROP PROCEDURE IF EXISTS add_quiz_of_class_proc;
DELIMITER $$
CREATE PROCEDURE add_quiz_of_class_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), class_id varchar(55)
)
BEGIN
	insert quiz_of_class (sub_id, semester_id, quiz_name, class_id)
    values (sub_id, semester_id, quiz_name, class_id);
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

-- call add_quiz_of_class_proc("CO3005", 202, "Quiz4", 'L01');


DROP PROCEDURE IF EXISTS delete_quiz_from_class_proc;
DELIMITER $$
CREATE PROCEDURE delete_quiz_from_class_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), class_id varchar(55)
)
BEGIN
	delete from quiz_of_class qoc
	where qoc.sub_id = sub_id 
		and qoc.semester_id = semester_id
        and qoc.quiz_name = quiz_name
        and qoc.class_id = class_id;
END $$
DELIMITER ;

-- call delete_quiz_from_class_proc("CO3005", 202, "Quiz4", 'L01');


-- Question of quiz
DROP PROCEDURE IF EXISTS add_question_to_quiz_proc;
DELIMITER $$
CREATE PROCEDURE add_question_to_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int, content text
)
BEGIN
	insert question (sub_id, semester_id, quiz_name, question_id, content)
    values (sub_id, semester_id, quiz_name, question_id, content)
    
    -- insert if not exist, otherwise update
    on duplicate key update
    question.sub_id = sub_id,
    question.semester_id = semester_id,
    question.quiz_name = quiz_name,
    question.question_id = question_id,
    question.content = content;
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

-- call add_question_to_quiz_proc("CO3005", 202, "Quiz4", 1, "Tu 'Da' trong tieng Anh la gi?");


DROP PROCEDURE IF EXISTS add_answer_to_question_proc;
DELIMITER $$
CREATE PROCEDURE add_answer_to_question_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int, answer_id varchar(1), right_answer bool, content text
)
BEGIN
	insert answer (sub_id, semester_id, quiz_name, question_id, answer_id, right_answer, content)
    values (sub_id, semester_id, quiz_name, question_id, answer_id, right_answer, content)
    
    -- insert if not exist, otherwise update
    on duplicate key update
    answer.sub_id = sub_id,
    answer.semester_id = semester_id,
    answer.quiz_name = quiz_name,
    answer.question_id = question_id,
    answer.answer_id = answer_id,
    answer.right_answer = right_answer,
    answer.content = content;
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

-- call add_answer_to_question_proc("CO3005", 202, "Quiz4", 1, 'A', true, "Stone");
-- call add_answer_to_question_proc("CO3005", 202, "Quiz4", 1, 'B', true, "Ice");
-- call add_answer_to_question_proc("CO3005", 202, "Quiz4", 1, 'C', true, "Kick");
-- call add_answer_to_question_proc("CO3005", 202, "Quiz4", 1, 'D', true, "Rock");




DROP PROCEDURE IF EXISTS modify_question_of_quiz_proc;
DELIMITER $$
CREATE PROCEDURE modify_question_of_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int, content text
)
BEGIN
	update question q
    set q.content = content
    where q.sub_id = sub_id
		and q.semester_id = semester_id
        and q.quiz_name = quiz_name
        and q.question_id = question_id;
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

call modify_question_of_quiz_proc("CO3005", 202, "Quy", 2, "Modify question");



DROP PROCEDURE IF EXISTS modify_answer_of_question_proc;
DELIMITER $$
CREATE PROCEDURE modify_answer_of_question_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int, answer_id varchar(1), right_answer tinyint(1), content text
)
BEGIN
	update answer a
    set a.content = content,
		a.right_answer = right_answer
    where a.sub_id = sub_id
		and a.semester_id = semester_id
        and a.quiz_name = quiz_name
        and a.question_id = question_id
        and a.answer_id = answer_id;
    
    select LAST_INSERT_ID() as last_id;
END $$
DELIMITER ;

call modify_answer_of_question_proc("CO3005", 202, "Quy", 2, "B", false, "Modify answer");



DROP PROCEDURE IF EXISTS get_all_answer_of_a_question_proc;
DELIMITER $$
CREATE PROCEDURE get_all_answer_of_a_question_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int
)
BEGIN
	select 
		answer_id,
        right_answer,
        content
	from answer ans
    where ans.sub_id = sub_id
		and ans.semester_id = semester_id
        and ans.quiz_name = quiz_name
        and ans.question_id = question_id;
END $$
DELIMITER ;

-- call get_all_answer_of_a_question_proc('CO3005', 202, 'Quiz4', 1);


DROP PROCEDURE IF EXISTS get_all_question_of_a_quiz_proc;
DELIMITER $$
CREATE PROCEDURE get_all_question_of_a_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255)
)
BEGIN
	select question_id, content
	from question que
    where que.sub_id = sub_id
		and que.semester_id = semester_id
        and que.quiz_name = quiz_name;
END $$
DELIMITER ;

-- call get_all_question_of_a_quiz_proc('CO3005', 202, 'Quiz1: Lexical');


DROP PROCEDURE IF EXISTS delete_answer_from_a_question_proc;
DELIMITER $$
CREATE PROCEDURE delete_answer_from_a_question_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int, answer_id varchar(1)
)
BEGIN
	delete from answer ans
	where ans.sub_id = sub_id 
		and ans.semester_id = semester_id
        and ans.quiz_name = quiz_name
        and ans.question_id = question_id
        and ans.answer_id = answer_id;
END $$
DELIMITER ;

-- call delete_answer_from_a_question_proc("CO3005", 202, "Quiz4", 1, 'D');


DROP PROCEDURE IF EXISTS delete_question_from_a_quiz_proc;
DELIMITER $$
CREATE PROCEDURE delete_question_from_a_quiz_proc
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255), question_id int
)
BEGIN
	delete from question que
	where que.sub_id = sub_id 
		and que.semester_id = semester_id
        and que.quiz_name = quiz_name
        and que.question_id = question_id;
END $$
DELIMITER ;

-- call delete_question_from_a_quiz_proc("CO3005", 202, "Quiz4", 1);

DROP PROCEDURE IF EXISTS student_get_all_quiz_of_class_proc;
DELIMITER $$
CREATE PROCEDURE student_get_all_quiz_of_class_proc
(
	sub_id varchar(55), semester_id int, class_id varchar(55), id_user varchar(55)
)
BEGIN
	select 
		q.quiz_name,
		q.max_time,
		q.no_question,
		q.deadline,
		sdq.student_answer,
		sdq.time,
		sdq.score,
		sdq.user_id
	from quiz_of_class qoc
	left join student_do_quiz sdq
		on qoc.sub_id = sdq.sub_id
		and qoc.semester_id = sdq.semester_id
		and qoc.quiz_name = sdq.quiz_name
	join quiz q
		on qoc.sub_id = q.sub_id
		and qoc.semester_id = q.semester_id
		and qoc.quiz_name = q.quiz_name
	where (user_id = id_user or user_id is null)
		and q.sub_id = sub_id
        and q.semester_id = semester_id;
END $$
DELIMITER ;

-- call student_get_all_quiz_of_class_proc('CO3005', 202, 'L01', '2222222');


-- Exam
DELIMITER $$
DROP PROCEDURE IF EXISTS viewListExam $$
CREATE PROCEDURE viewListExam(
				IN sub_id_param varchar(55),
                IN sem_id_param INT(10)
				)
BEGIN
    SELECT exam_name, no_question FROM exam
    WHERE sub_id = sub_id_param AND semester_id = sem_id_param;
END; $$

-- call viewListExam('CO3005', 202);

DELIMITER $$
DROP PROCEDURE IF EXISTS createNewExam $$
CREATE PROCEDURE createNewExam(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN no_question_param INT
				)
BEGIN
    INSERT INTO exam(sub_id, semester_id, exam_name, no_question)
    VALUES (sub_id_param, sem_id_param, exam_name_param, no_question_param);
END; $$

-- call createNewExam('CO3005', 202, 'Bonus', 5);


DELIMITER $$
DROP PROCEDURE IF EXISTS deleteExam $$
CREATE PROCEDURE deleteExam(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255)
				)
BEGIN
    DELETE FROM exam 
    WHERE sub_id = sub_id_param AND semester_id = sem_id_param AND exam_name = exam_name_param;
END; $$

-- call deleteExam('CO3005', 202, 'Bonus');

DELIMITER $$
DROP PROCEDURE IF EXISTS viewListExamCode $$
CREATE PROCEDURE viewListExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255)
				)
BEGIN
	SELECT exam_code_id, key_answer FROM exam_code
    WHERE sub_id = sub_id_param AND semester_id = sem_id_param AND exam_name = exam_name_param;
END; $$

-- call viewListExamCode('CO3005', 202, 'KTGK');

DELIMITER $$
DROP PROCEDURE IF EXISTS createExamCode $$
CREATE PROCEDURE createExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55),
                IN key_answer varchar(55)
				)
BEGIN
	INSERT INTO exam_code(sub_id, semester_id, exam_name, exam_code_id, key_answer)
	VALUES (sub_id_param, sem_id_param, exam_name_param, exam_code_id_param, key_answer);
END; $$

-- call createExamCode('CO3005', 202, 'KTGK', "009", 'ACCACBB');

DELIMITER $$
DROP PROCEDURE IF EXISTS viewAnswerExamCode $$
CREATE PROCEDURE viewAnswerExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55)
				)
BEGIN
	SELECT key_answer
    FROM exam_code
    WHERE sub_id = sub_id_param AND semester_id = sem_id_param AND exam_name = exam_name_param AND exam_code_id = exam_code_id_param;
END; $$

-- call viewAnswerExamCode('CO3005', 202, 'KTGK', "001");

DELIMITER $$
DROP PROCEDURE IF EXISTS deleteExamCode $$
CREATE PROCEDURE deleteExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55)
				)
BEGIN
	DELETE FROM exam_code
    WHERE sub_id = sub_id_param AND semester_id = sem_id_param AND exam_name = exam_name_param AND exam_code_id = exam_code_id_param;
END; $$

-- call deleteExamCode('CO3005', 202, 'KTGK', "009");

-- STUDENT DO EXAM CODE --

DELIMITER $$
DROP PROCEDURE IF EXISTS viewListStudentDoExamCode $$
CREATE PROCEDURE viewListStudentDoExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255)
)
                -- view ten, examcode nao, diem bao nhieu -- 
BEGIN
	SELECT 
		U.id as student_id,
        U.name student_name,
        S.exam_code_id,
        S.score
    FROM student_do_exam_code as S, user as U
    WHERE	S.user_id = U.id 
			AND sub_id = sub_id_param 
            AND semester_id = sem_id_param 
            AND exam_name = exam_name_param;
END; $$

-- call viewListStudentDoExamCode('CO3005', 202, 'BTL');

DELIMITER $$
DROP PROCEDURE IF EXISTS viewStudentDoExamCode $$
CREATE PROCEDURE viewStudentDoExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55),
                IN student_id_param varchar(55)
)
                -- view ten, examcode nao, diem bao nhieu -- 
BEGIN
	SELECT *
    FROM student_do_exam_code as S, user as U
    WHERE	S.user_id = U.id 
			AND sub_id = sub_id_param 
            AND semester_id = sem_id_param 
            AND exam_name = exam_name_param
            AND exam_code_id = exam_code_id_param
            AND user_id = student_id_param;
END; $$

-- call viewStudentDoExamCode('CO3005', 202, 'BTL', '004', '1111111');


DELIMITER $$
DROP PROCEDURE IF EXISTS createStudentDoExamCode $$
CREATE PROCEDURE createStudentDoExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55),
                IN user_id_param varchar(55),
                IN score_param double,
                IN student_answer_param varchar(55)
				)
BEGIN
	INSERT INTO student_do_exam_code(sub_id, semester_id, exam_name, exam_code_id, user_id, score, student_answer)
	VALUES (sub_id_param, sem_id_param, exam_name_param, exam_code_id_param, user_id_param, score_param, student_answer_param);
END; $$

-- call createStudentDoExamCode('CO3005', 202, 'BTL', '004', '1080', 9.5, 'ABACCB');

DELIMITER $$
DROP PROCEDURE IF EXISTS deleteStudentDoExamCode $$
CREATE PROCEDURE deleteStudentDoExamCode(
				IN sub_id_param varchar(55),
                IN sem_id_param INT,
                IN exam_name_param varchar(255),
                IN exam_code_id_param varchar(55),
                IN user_id_param varchar(55)
				)
BEGIN
	DELETE FROM student_do_exam_code
    WHERE sub_id = sub_id_param 
		AND semester_id = sem_id_param 
        AND exam_name = exam_name_param
        AND exam_code_id = exam_code_id_param
		AND user_id = user_id_param;
END; $$

-- call deleteStudentDoExamCode('CO3005', 202, 'BTL', '004', '1111111');

-- add content quiz
DROP PROCEDURE IF EXISTS `get_all_questions_and_answers_of_quiz`;
DELIMITER $$
CREATE PROCEDURE `get_all_questions_and_answers_of_quiz`
(
	sub_id varchar(55), semester_id int, quiz_name varchar(255)
)
BEGIN
	select 
		ques.question_id, 
        ques.content as question_content,
        an.answer_id,
        an.content as answer_content,
        an.right_answer
    from quiz q
    join question ques
		on q.sub_id = ques.sub_id
        and q.semester_id = ques.semester_id
        and q.quiz_name = ques.quiz_name
    join answer an
		on ques.sub_id = an.sub_id
        and ques.semester_id = an.semester_id
        and ques.quiz_name = an.quiz_name
        and ques.question_id = an.question_id
	where q.sub_id = sub_id
		and q.semester_id = semester_id
        and q.quiz_name = quiz_name;
END $$

-- call get_all_questions_and_answers_of_quiz('CO3005', 202, 'Quiz1: Lexical');

