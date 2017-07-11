SELECT MAX(similarity) FROM(
    SELECT A.docid, sum(A.count * B.count) as similarity
    FROM frequency as A
    INNER JOIN (SELECT 'q' as docid, 'washington' as term, 1 as count 
        UNION
        SELECT 'q' as docid, 'taxes' as term, 1 as count
        UNION 
        SELECT 'q' as docid, 'treasury' as term, 1 as count) AS B
    ON A.term = B.term
    GROUP BY A.docid);


SELECT A.docid, sum(A.count * B.count) as similarity
FROM frequency as A
INNER JOIN (SELECT 'q' as docid, 'washington' as term, 1 as count 
        UNION
        SELECT 'q' as docid, 'taxes' as term, 1 as count
        UNION 
        SELECT 'q' as docid, 'treasury' as term, 1 as count) AS B
ON A.term = B.term
GROUP BY A.docid
ORDER BY similarity DESC
LIMIT 10;