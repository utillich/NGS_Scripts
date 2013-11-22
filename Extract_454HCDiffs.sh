#!/bin/bash 

if [ ! -f 454HCDiffs.txt ]; then echo "454HCDiffs.txt not found in working directory, aborting!"; exit 1; fi;



grep '>' 454HCDiffs.txt > 454HCDiffs_pre

sed -i 's/>gi|16329170|ref|NC_000911.1|/NC_000911/g' 454HCDiffs_pre
sed -i 's/>gi|38505535|ref|NC_005229.1|/NC_005229/g' 454HCDiffs_pre
sed -i 's/>gi|38505825|ref|NC_005232.1|/NC_005232/g' 454HCDiffs_pre
sed -i 's/>gi|38505668|ref|NC_005230.1|/NC_005230/g' 454HCDiffs_pre
sed -i 's/>gi|38505775|ref|NC_005231.1|/NC_005231/g' 454HCDiffs_pre
sed -i 's/>pCA2.4/pCA2.4/g' 454HCDiffs_pre
sed -i 's/>pCB2.4/pCB2.4/g' 454HCDiffs_pre

echo "done!"
