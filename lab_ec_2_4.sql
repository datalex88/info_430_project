USE UNIVERSITY
/*
Alex Davis
Feb 04 2020

If you have the letters "GH" anywhere in your last name, tblStudent, "Silent"
If you have a combination, "BG" in your last name, "Difficult"
"AS" as "Common"
"F" as "Funny"
else "Unknown"
*/
GO

SELECT COUNT(StudentID) AS CountOfAliases,
CASE 
    WHEN StudentLname LIKE '%AS%' THEN 'Silent'
    WHEN StudentLname LIKE '%BG%' THEN 'Difficult'
    WHEN StudentLname LIKE '%AS%' THEN 'Common'
    WHEN StudentLname LIKE '%F%' THEN 'Funny'
    ELSE 'Unknown'

END AS QuantityOfNickNames
FROM tblSTUDENT
GROUP BY
(
    CASE
    WHEN StudentLname LIKE '%AS%' THEN 'Silent'
    WHEN StudentLname LIKE '%BG%' THEN 'Difficult'
    WHEN StudentLname LIKE '%AS%' THEN 'Common'
    WHEN StudentLname LIKE '%F%' THEN 'Funny'
    ELSE 'Unknown'
    END
)
ORDER BY QuantityOfNickNames DESC

SELECT * FROM tblSTUDENT