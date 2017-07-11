
SELECT count(*) FROM (
  SELECT A.docid
  FROM frequency as A
  INNER JOIN frequency as B
  ON A.docid = B.docid AND A.term = 'transactions' AND B.term = 'world'
) x;