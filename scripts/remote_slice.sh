#!/bin/bash
trap "exit 1" SIGTERM

if [ -z "$1" ];then
  echo "Usage: $0 filename printer"
  exit 1
fi

out=$(basename "$1"|sed 's/[^a-zA-Z0-9.]/_/g'|sed 's/^_//'|sed 's/_*$//')
if [[ a$out == a$(basename "$1") ]] ; then
  file="$1"
else
  echo "Linked $1 as $out"
  ln -sf "$1" "$out"
  file="$out"
fi

host=pulsar.unizar.es
printer=$2
remotehost=p_$printer@$host

# Script para lanzar sliceado en remoto
# Preparamos el entorno para configurar el slicer
unlink $HOME/.skeinforge
ln -s /home/asimov/impresoras/$printer/dot-skeinforge ${HOME}/.skeinforge
# Lanzamos el menu de configuración
python /home/asimov/software/Printrun/skeinforge/skeinforge_application/skeinforge.py

# Sincronización de los ficheros de configuración
#echo "Borrando .skeinforge remoto"
#ssh $remotehost 'rm -rf .skeinforge'
echo "Copiando .skeinforge"
rsync -azPL ~/.skeinforge ${remotehost}:
#scp -r ~/.skeinforge/ $remotehost:

# Copio el .stl al home de pulsar del usuario corresponiente
echo "Copiando fichero stl"
scp "$file" $remotehost:stl/

echo "Slicing!"
ssh $remotehost "python /opt/skeinforge/skeinforge_application/skeinforge_utilities/skeinforge_craft.py \"stl/$(basename "$file")\"" | strings

echo "Copiando fichero de $remotehost a localhost"
scp "$remotehost:\"stl/$(basename "${file%.*}_export.gcode")\"" "$(basename "${file%.*}_$printer.gcode")"

echo "Copiando fichero de localhost a octoprint@${printer}"
scp "$(basename "${file%.*}_$printer.gcode")" "octoprint@${printer}:\"/home/octoprint/.octoprint/uploads/$(basename "${file%.*}_${printer}_$(date +%Y%m%d%H%M%S).gcode")\""
echo "Copiado fichero a octoprint@${printer}"

#scp $remotehost:stl/$(basename "${filename%.*}_export.gcode") ${printer}@${printer}:gcode/$(basename "${filename%.*}_$printer.gcode")

