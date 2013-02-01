#!/bin/bash
filename=~/stl/$(basename $1)
outname=$2
remotehost=p_daneel@pulsar.unizar.es
# Script para lanzar sliceado en remoto
#echo "Borrando .skeinforge remoto"
#ssh $remotehost 'rm -rf .skeinforge'
echo "Copiando .skeinforge"
rsync -avzPL ~/.skeinforge p_ester@pulsar.unizar.es:
#scp -r ~/.skeinforge/ $remotehost:

# Copio el .stl al home de pulsar del usuario corresponiente
echo "Copiando fichero stl"
scp "$1" $remotehost:stl/

ssh $remotehost "python /opt/skeinforge/skeinforge_application/skeinforge_utilities/skeinforge_craft.py stl/$(basename $filename)" | strings

scp $remotehost:stl/$(basename "${filename%.*}_export.gcode") $outname

