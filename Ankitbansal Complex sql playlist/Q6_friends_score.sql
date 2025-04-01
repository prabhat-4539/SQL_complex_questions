/* Q 6> Write a query to find Person_id, Name,Number of friends, sum of marks of person who have friends with total score greater than 100. */
/* Input Table


DROP TABLE friend
Create table friend (Person_id int, fid int)
insert into friend (Person_id , fid ) values ('1','2');
insert into friend (Person_id , fid ) values ('1','3');
insert into friend (Person_id , fid ) values ('2','1');
insert into friend (Person_id , fid ) values ('2','3');
insert into friend (Person_id , fid ) values ('3','5');
insert into friend (Person_id , fid ) values ('4','2');
insert into friend (Person_id , fid ) values ('4','3');
insert into friend (Person_id , fid ) values ('4','5');
DROP TABLE person
create table person (PersonID int,	Name varchar(50),	Score int)
insert into person(PersonID,Name ,Score) values('1','Alice','88')
insert into person(PersonID,Name ,Score) values('2','Bob','11')
insert into person(PersonID,Name ,Score) values('3','Devis','27')
insert into person(PersonID,Name ,Score) values('4','Tara','45')
insert into person(PersonID,Name ,Score) values('5','John','63')
select * from person
select * from friend

*/
select * from person;
select * from friend;

WITH friend_score_count AS
(
	SELECT 
		f.Person_id,
		COUNT(*) AS number_of_friends,
		SUM(p.Score) AS sum_friends_score
	FROM friend f
	JOIN person p
	ON f.fid = p.PersonID
	GROUP BY f.Person_id
)
--SELECT * FROM friend_score_count
--Person_id, Name,Number of friends, sum of marks of person
SELECT 
	fsc.Person_id,
	p.Name,
	p.Score,
	fsc.number_of_friends,
	SUM(p.Score) OVER (ORDER BY Person_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS sum_person_score,
	fsc.sum_friends_score
FROM person p
LEFT JOIN friend_score_count fsc
ON p.PersonID = fsc.Person_ID
WHERE sum_friends_score > 100



