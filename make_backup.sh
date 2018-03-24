#!/bin/bash

<<'COMMENT'

Compress and backup tool

Copyright (C) 2018 Sergey Kolevatov

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

COMMENT

# $Revision: 8828 $ $Date:: 2018-03-23 #$ $Author: serge $

#<hb>***************************************************************************
#
# make_backup.sh <source_folder> <destination_folder>
#
# source_folder       - folder to be backed up
#
# destination_folder  - forder to store archive
#
# Example: make_backup.sh /folder/to/backup /media/backup
#
#<he>***************************************************************************

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -c 3-
}


datum=$( date -u +"%Y%m%d_%H%M" )

src=$1
dest=$2

[[ -z "$src" ]]  && show_help && exit;
[[ -z "$dest" ]] && show_help && exit;

test -d "$src" || { echo "ERROR: source directory doesn't exit"; exit; }

name=$(basename $src)

#echo "DBG: dest = $dest"

test -d "$dest" || mkdir -p "$dest"

arch_name=${name}_${datum}.tar.gz

echo "MB: dest = $dest/$arch_name"

tar -zcvf $arch_name -C $src . --transform "s/^\./$name/"

cp $arch_name "$dest"

rm $arch_name

echo "MB: checking ..."

ls -alF $dest/$arch_name

echo "MB: copied $src to $dest/$arch_name"
