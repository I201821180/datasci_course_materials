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
    # input both relationships. Then we expect to find twice the names for symmetric relationships
    mr.emit_intermediate(key, value)
    mr.emit_intermediate(value, key)

def reducer(key, list_of_values):
    # key: name
    # values: list of friends (names are repeated twice if the relationship is symmetric)

#    this solution could be faster, but it does not return the results in the same order as the model solution 
#    sorted_list = sorted(list_of_values)
#    i = 0
#    while i < len(sorted_list):
#     if i< len(sorted_list)-1 and sorted_list[i] == sorted_list[i+1]: 
#        i+=2
#     else: 
#        mr.emit((key, sorted_list[i]))
#        i+=1

    for fr in list_of_values:
      finder = [ 1 for i in list_of_values if fr==i]
      # if there is a single match
      if finder == [1]:    
        mr.emit((key, fr))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
