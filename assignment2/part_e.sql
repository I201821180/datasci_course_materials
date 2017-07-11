SELECT count(*) FROM (
  SELECT docid, sum(count)
  FROM frequency
  GROUP BY docid 
  HAVING sum(count) > 300
) x;