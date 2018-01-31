#!/bin/bash

<<'COMMENT'

Compress and backup tool to TrueCrypt container

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

# $Revision: 8675 $ $Date:: 2018-01-31 #$ $Author: serge $

#<hb>***************************************************************************
#
# make_backup_truecrypt.sh <source_folder> <container>
#
# source_folder       - folder to be backed up
#
# container           - TrueCrypt container
#
# Example: make_backup_truecrypt.sh /folder/to/backup /media/container
#
#<he>***************************************************************************

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -c 3-
}


src=$1
container=$2

[[ -z "$src" ]]        && show_help && exit;
[[ -z "$container" ]]  && show_help && exit;

[[ ! -f "$container" ]] && echo "ERROR: container $container not found" && exit

datum=$( date -u +"%Y%m%d_%H%M" )

mount_point=/tmp/mb_${datum}_${RANDOM}

mkdir $mount_point
res=$?

[[ $res -ne 0 ]] && echo "ERROR: cannot create mount point $mount_point" && exit

sudo truecrypt $container $mount_point
res=$?

[[ $res -ne 0 ]] && echo "ERROR: cannot mount container $container" && rmdir $mount_point && exit

echo "MB: mounted $container to $mount_point"

name=$(basename $src)

make_backup.sh "$src" "$mount_point/$name"

sudo truecrypt -d $mount_point
res=$?

[[ $res -ne 0 ]] && echo "ERROR: cannot unmount container $container" && exit

echo "MB: unmounted $container from $mount_point"

rmdir $mount_point
