#!/bin/bash
#SBATCH -A johnwayne
#SBATCH --job-name=turtle_assign
#SBATCH -N 1
#SBATCH -n 64
#SBATCH -t 12-00:00:00
#SBATCH -e %x_%j.err
#SBATCH -o %x_%j.out
#SBATCH --mail-user=allen715@purdue.edu
#SBATCH --mail-type=END,FAIL

module load anaconda
conda activate WGSassign

# can now run with WGSassign command
# https://github.com/mgdesaix/WGSassign

WGSassign --beagle whole_genome.beagle.gz --pop_af_IDs ref_ids.txt --get_reference_af --loo --out loo_turtles --threads 64

#ref_ids.txt:
F1150	Buller
F1153	Buller
F1154	Warren
F1155	Warren
F1157	Buller
F1158	Warren
F1159	Buller
F1160	Alazan 
F1161	Alazan 
F1162	Alazan 
F1163	Brazoria
F1164	Brazoria
F1165	Warren
F1166	Warren
F1169	Warren
F1170	Warren
F1171	Warren
F1172	Alazan 
F1177	Buller
F1178	Buller
F1180	Gordy
F1181	Gordy
F1182	Gordy
F1184	Buller
F1185	Warren
F1186	Gordy
F1187	Alazan 
F1188	Buller
F1189	Alazan 
F1192	Alazan 
F1193	Gordy
F1194	Buller
F1196	Alazan 
F1197	Gordy
F1200	Alazan 
F1207	Buller
F1210	Gordy
F1211	Gordy
F1212	Gordy
F1216	Buller
F1220	Buller
F1224	Warren
F1239	Gordy
F1240	Gordy
F1242	Gordy
F1243	Gordy
F1244	Gordy
F1245	Gordy
F1248	Gordy
F1252	Gordy
F1254	Gordy
F1258	Liberty
F1438	Warren
F1440	Alazan 
F1442	Alazan 
F1447	Warren
F1449	Warren
F1459	Alazan 
F1463	Alazan 
F1465	Alazan 
F1467	Alazan 
F1469	Alazan 
F1480	Alazan 
F1482	Alazan 
F1485	Alazan 
F1488	Wharton
F1489	Wharton
F1491	Wharton
F1494	Wharton
F1496	Wharton
F1501	Wharton
F1503	Wharton
F1504	Wharton
F1506	Wharton
F1507	Wharton
F1508	Wharton
F1510	Wharton
F1518	Wharton
F1521	Wharton
F1524	Wharton
F1525	Wharton
F1528	Wharton
F1529	Wharton
F1531	Wharton
F1539	Gordy
F1540	Gordy
F1541	Gordy
F1542	Gordy
F1543	Brazos
