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
		
SELECT COUNT(title) as count_death_poems, 
		(SELECT COUNT(title) as count_love_poems
			FROM poem WHERE text ILIKE '%love%'),
		 		(SELECT AVG(char_count) AS avg_char_count_death
				FROM poem
				WHERE text ILIKE '%death%'),
						 (SELECT AVG(char_count) AS avg_char_count_love
				 			FROM poem
				 			WHERE text ILIKE '%love%')
			FROM poem
			WHERE text ILIKE '%death%'

--Answer: Total poems that mention love (4464)
--total poems that mention death (86)
--avg_char_count_love (226)
--avg_char_count_death (342)


--Question 3.a
SELECT emotion.name, AVG(intensity_percent) as avg_intensity, AVG(char_count) as avg_char_count
FROM poem_emotion
INNER JOIN emotion ON poem_emotion.emotion_id=emotion.id
INNER JOIN poem ON poem_emotion.id=poem.id
GROUP BY emotion.name
ORDER BY avg_char_count
--Answer 3.a: Joyful poems are associated with the longest poems and sadness are associated with the shortest poems

--Question 3.b

WITH joy_avg AS
	(SELECT emotion.name as emotion, AVG(char_count) as avg_joy_char_count
	FROM poem_emotion
			INNER JOIN emotion ON poem_emotion.emotion_id=emotion.id
			INNER JOIN poem ON poem_emotion.id=poem.id
	GROUP BY emotion.name)

SELECT emotion, avg_joy_char_count, title as poem_title, text as poem_text, char_count, intensity_percent
FROM joy_avg
LEFT JOIN emotion ON joy_avg.emotion=emotion.name
	INNER JOIN poem_emotion ON poem_emotion.emotion_id=emotion.id
	INNER JOIN poem ON poem_emotion.id=poem.id
WHERE emotion.name ILIKE 'Joy'
ORDER BY intensity_percent DESC
LIMIT 5;

/*Answer 3b - The most joyful poem shares the highest intensity at 98 but it has a character count of 336, 
which is much higher than the average character count for joyful poems. 
I do not think these are all classified correctly because it seems like a joyful topic is ambiguous. 
Is a poem classified as joyful if it's not obviously sad, angry or fearful? The category seems too broad.*/

--Question 4
WITH fifth_grade AS (SELECT title, text, intensity_percent, char_count, poem_emotion.emotion_id, author.grade_id, gender.name AS gender
				FROM poem
					INNER JOIN poem_emotion ON poem.id=poem_emotion.id
					INNER JOIN author ON poem.author_id=author.id
					INNER JOIN gender ON author.gender_id=gender.id
				WHERE poem_emotion.emotion_id = 1
				AND author.grade_id = 5
				ORDER BY intensity_percent DESC
				LIMIT 5),
				
   first_grade AS (SELECT title, text, intensity_percent, char_count, poem_emotion.emotion_id, author.grade_id, gender.name AS gender
				FROM poem
			INNER JOIN poem_emotion ON poem.id=poem_emotion.id
					INNER JOIN author ON poem.author_id=author.id
					INNER JOIN gender ON author.gender_id=gender.id
				WHERE poem_emotion.emotion_id = 1
				AND author.grade_id = 1
				ORDER BY intensity_percent DESC
				LIMIT 5)
	SELECT *
	FROM fifth_grade
	UNION ALL
	SELECT *
	FROM first_grade
	ORDER BY intensity_percent DESC;

/* Answers:
4a. Fifth graders write teh angriest poems
4b. Females appear more in the top-5 for grades 1 and 5
4c. The poem "Rabbits" is my favorite because it uses the phrase "chomp on carrots"*/

--Question 5:

SELECT author.grade_id as grade, 
		COUNT(CASE WHEN emotion.name = 'Joy' THEN 'joy' END) AS joy_count,
		COUNT (CASE WHEN emotion.name = 'Anger' THEN 'anger' END) as anger_count,
		COUNT(CASE WHEN emotion.name = 'Sadness' THEN 'sadness' END) AS sadness_count,
		COUNT(CASE WHEN emotion.name = 'Fear' THEN 'fear' END) AS fear_count
FROM poem
		INNER JOIN poem_emotion ON poem.id=poem_emotion.id
		INNER JOIN emotion ON poem_emotion.emotion_id=emotion.id
		INNER JOIN author ON poem.author_id=author.id
		INNER JOIN gender ON author.gender_id=gender.id
WHERE author.name ILIKE 'Emily'
GROUP BY author.grade_id, author.name

-- see excel file