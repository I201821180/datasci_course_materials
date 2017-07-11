

  SELECT sum(A.count * B.count)
  FROM frequency as A
  INNER JOIN frequency as B
  ON A.term = B.term
  WHERE A.docid = '10080_txt_crude' AND B.docid = '17035_txt_earn';