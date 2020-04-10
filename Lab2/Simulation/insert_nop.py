fin = open('1testAll.inst', 'r')
fout = open('1testAll.bubble', 'w')
for line in fin:
    fout.write(line)
    fout.write("00000000\r\n")
    fout.write("00000000\r\n")
    fout.write("00000000\r\n")
    fout.write("00000000\r\n")