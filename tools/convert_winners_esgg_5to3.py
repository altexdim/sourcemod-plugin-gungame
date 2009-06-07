#1) download and install http://www.python.org/ftp/python/2.6.2/python-2.6.2.msi
#2) copy your gg5 winners db file into some folder
#3) copy this file to the same folder
#4) run script and you got gg3 winners file 

import cPickle

gg5_file = open('winnersdata.db', 'r')
gg3_file = open('es_gg_winners_db.txt', 'w')

data1 = cPickle.load(gg5_file)

gg3_file.write("\"gg_PlayerData\"\n")
gg3_file.write("{\n")
for steamid in data1.copy():
    gg3_file.write("\t\"%s\"\n" % steamid)
    gg3_file.write("\t{\n")
    gg3_file.write("\t\t\"name\"\t\"%s\"\n" % data1[steamid]['name'])
    gg3_file.write("\t\t\"Wins\"\t\"%s\"\n" % data1[steamid]['wins'])
    gg3_file.write("\t\t\"TimeStamp\"\t\"%i\"\n" % data1[steamid]['timestamp'])
    gg3_file.write("\t}\n")
gg3_file.write("}\n")

gg5_file.close()
gg3_file.close()

