
  SELECT COUNT(DISTINCT docid)
  FROM frequency
  WHERE term = 'law' OR term = 'legal';