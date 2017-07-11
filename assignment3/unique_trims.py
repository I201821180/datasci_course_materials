import MapReduce
import sys


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: name 
    # value: friend's name
    key = record[1][:-10] # cut the last 10 characters of the dna seq
    value = record[0]  # this is the name of the dna seq, we don't reaaly need it, but I keep it here
    mr.emit_intermediate(key, value)

def reducer(key, list_of_values):
    # key: trimmed dna seq
    # values: list of seq ids
  
    mr.emit(key)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
