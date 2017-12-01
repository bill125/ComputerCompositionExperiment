import sys
from struct import pack
def hex2dec(string_num):
    return int(string_num.strip().upper(), 16)

with open(sys.argv[1], 'r') as fin, open(sys.argv[2], 'wb') as fout:
    for i in fin:
        val = chr(hex2dec(i))
        fout.write(pack('<c', val))
