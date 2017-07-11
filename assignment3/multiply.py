import MapReduce
import sys


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):

    table = record [0]
    i = record[1]
    j = record[2]
    value = record[3]

    N = M = 4 # the dimensions of the final matrix. We need to know these, but they are not given.
    if table == 'a':
      for n in range(N+1):
        mr.emit_intermediate((i,n), ('a', j, value))

    if table == 'b':
      for m in range(M+1):
        mr.emit_intermediate((m,j), ('b', i, value))

def reducer(key, list_of_values):
    # key: index of the result matrix cell
    # values: all the values of the original matrices that will affect this cell
  
    a_values = [ r for r in list_of_values if r[0]=='a']
    b_values = [ r for r in list_of_values if r[0]=='b']

    total = 0
    for a in a_values:
      for b in b_values:
        if a[1]==b[1]: 
          total += a[2]*b[2]

    mr.emit((key[0], key[1], total))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
