import MapReduce
import sys


mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: order id
    # value: the whole record
    key = record[1]
    mr.emit_intermediate(key, record)

def reducer(key, list_of_values):
    # key: order_id
    # values: records of orders or list_items

    # Separate the orders from the list items
    orders = []
    line_items = []
    for r in list_of_values:
      if r[0] == 'order':
        orders.append(r)
      elif r[0] == 'line_item':
        line_items.append(r)

    # Do their cross product
    for o in orders:
      for li in line_items:
        mr.emit(o+li)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
