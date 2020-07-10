#!/bin/bash

<<'COMMENT'

Decrypt and list tar.gz archive

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
# gpg_list_archive_tar_gz.sh <archive_name>
#
# archive_name        - archive name
#
# Example: ./gpg_list_archive_tar_gz.sh input.tar.gz.gpg
#
#<he>***************************************************************************

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -c 3-
}


datum=$( date -u +"%Y%m%d_%H%M" )

src=$1

[[ -z "$src" ]]  && show_help && exit;

test -f "$src" || { echo "ERROR: source file $src doesn't exit"; exit; }

gpg -d $src | tar tz
