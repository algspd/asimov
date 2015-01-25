#!/bin/bash
trap "exit 1" SIGTERM

if [ -z "$1" ];then
  echo "Usage: $0 filename printer"
  exit 1
fi

#rename 's/[^a-zA-Z0-9.]/_/g' "$1"
#file=$(echo "$1"|sed 's/[^a-zA-Z0-9.]/_/g')
out=$(rename -f -v 's/[^a-zA-Z0-9.]/_/g' "$1" | sed 's/.*renamed as //')
if [[ a$out == a ]] ; then
  file="$1"
else
  echo "Renombrando de $1 a $out"
  file="$out"
fi

filename=~/stl/$(basename "$file")
host=pulsar.unizar.es
printer=$2
remotehost=p_$printer@$host

echo $filename

# Script para lanzar sliceado en remoto
unlink $HOME/.skeinforge
ln -s /home/asimov/impresoras/$printer/dot-skeinforge ${HOME}/.skeinforge
python /home/asimov/software/Printrun/skeinforge/skeinforge_application/skeinforge.py
#echo "Borrando .skeinforge remoto"
#ssh $remotehost 'rm -rf .skeinforge'
echo "Copiando .skeinforge"
rsync -azPL ~/.skeinforge ${remotehost}:
#scp -r ~/.skeinforge/ $remotehost:

# Copio el .stl al home de pulsar del usuario corresponiente
echo "Copiando fichero stl"
scp "$file" $remotehost:stl/

ssh $remotehost "python /opt/skeinforge/skeinforge_application/skeinforge_utilities/skeinforge_craft.py \"stl/$(basename "$filename")\"" | strings

echo "Copiando fichero de $remotehost a localhost"
scp "$remotehost:\"stl/$(basename "${filename%.*}_export.gcode")\"" "$(basename "${filename%.*}_$printer.gcode")"

echo "Copiando fichero de localhost a octoprint@${printer}"
#echo "scp $(basename \"${filename%.*}_$printer.gcode\") octoprint@${printer}:/home/octoprint/.octoprint/uploads/"
#echo "scp $(basename \"${filename%.*}_$printer.gcode\") octoprint@${printer}:/home/octoprint/.octoprint/uploads/$(basename \"${filename%.*}_${printer}_$(date +%Y%m%d%H%M%S).gcode\")"
scp "$(basename "${filename%.*}_$printer.gcode")" "octoprint@${printer}:\"/home/octoprint/.octoprint/uploads/$(basename "${filename%.*}_${printer}_$(date +%Y%m%d%H%M%S).gcode")\""

echo "Copiado fichero a octoprint@${printer}"

#scp $remotehost:stl/$(basename "${filename%.*}_export.gcode") ${printer}@${printer}:gcode/$(basename "${filename%.*}_$printer.gcode")

