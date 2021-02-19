--Question 1.a
SELECT COUNT(author.name) AS number_students, grade.name AS grade
FROM author
	INNER JOIN grade ON author.grade_id=grade.id
GROUP BY grade.name	
ORDER BY grade.name
/* 1st grade(623), 2nd grade(1437), 3rd grade(2344), 4th grade (3288), 5th grade (3464) */

	
--Question 1.b
SELECT grade.name AS grade, 
		COUNT(CASE WHEN gender.name = 'Female' THEN 'Female' END) AS female_count,
		COUNT(CASE WHEN gender.name = 'Male' THEN 'Male'END) AS total_males
FROM author
	INNER JOIN grade ON author.grade_id=grade.id
	INNER JOIN gender ON author.gender_id=gender.id
GROUP BY grade.name
ORDER BY grade.name
/*Answer:
1st grade (243 females/163 males)
2nd grade (605 females/412 males)
3rd grade (948 females/577 males
4th grade (1241 females/723 males)
5th grade (1294 females/757 males) */

/*Question 1.c Answer: There are consistently more females than males across all grades - almost double the amount for some grades!*/

--Question 2
SELECT * 
FROM emotion
