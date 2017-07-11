import MapReduce
import sys


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: name 
    # value: friend's name
    key = record[0]
    value = record[1]
    mr.emit_intermediate(key, 1)

def reducer(key, list_of_values):
    # key: name
    # values: list of 1's

    mr.emit((key, sum(list_of_values)))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
