#!/bin/bash

<<'COMMENT'

Compress folder to tar.gz archive

Copyright (C) 2020 Sergey Kolevatov

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

# $Revision: 13395 $ $Date:: 2020-07-10 #$ $Author: serge $

#<hb>***************************************************************************
#
# pack_folder_tar_gz.sh <source_folder> [<output_file>]
#
# source_folder       - folder to pack
#
# output_file         - potional archive name
#
# Example: ./pack_folder_tar_gz.sh /folder/name output.tar.gz
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
[[ -z "$dest" ]] && dest=$src.tar.gz;

test -d "$src" || { echo "ERROR: source directory $src doesn't exit"; exit; }

name=$(basename $src)

#echo "DBG: dest = $dest"

tar -zcvf $dest $src
