#!/bin/bash

#      Copyright (C) 2005-2008 Team XBMC
#      http://www.xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with XBMC; see the file COPYING.  If not, write to
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.html

xbmcUser=$1
xbmcParams=$2

#
# AMD Fusion (E-350) detection
#

AMDFusion=$(lspci -nn | grep '0403' | grep '1002:4383') # ATI Technologies Inc SBx00 Azalia

if [ ! -n "$AMDFusion" ] ; then
        exit 0
fi

activationToken="noalsaconfig"

# if strings are NOT the same the token is part of the parameters list
# here we want to stop script if the token is there
if [ "$xbmcParams" != "${xbmcParams%$activationToken*}" ] ; then
        exit 0
fi

#
# Setup .asoundrc
#

if [ ! -f /home/$xbmcUser/.asoundrc ] ; then
        cat > /home/$xbmcUser/.asoundrc << 'EOF'
pcm.!default {
	type plug
	slave {
		pcm "hdmi"
	}
}
EOF
        chown $xbmcUser:$xbmcUser /home/$xbmcUser/.asoundrc
fi

exit 0
