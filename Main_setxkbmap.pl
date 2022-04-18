#!/usr/bin/env perl

# This script is useful for Cygwin/X, in order to change keyboard mapping.
# In Windows, we can create a shortcut to Main_setxkbmap_Go.bat (e.g. on the desktop)
# and associate it with a keyboard combination such as Ctrl+Alt+K.
# Then we can use that combination to switch keyboard mapping in Cygwin/X applications.
# (This includes applications running on another computer and displayed on this computer.)
#
# To do the same in `mintty` (which is not a Cygwin/X application),
# we have to change Character Set to "UTF-8" in System Menu -> Options -> Text
# and then we can use the Windows keyboard combination instead.
#
# An example of `~/.minttyrc` file:
#
#   ```
#   BoldAsFont=-1
#   Columns=128
#   Rows=60
#   FontHeight=10
#   ScrollbackLines=999999
#   Term=xterm-256color
#   Locale=C
#   Charset=UTF-8
#   ```

$s_command_base = 'export DISPLAY=":0.0"; setxkbmap';

$s_layout = "";
{
	$s_command_ex = "${s_command_base} -query";
	printf ("Running: `%s`...\n", $s_command_ex);
	@asLines = `${s_command_ex}`;
	foreach (@asLines)
	{
		chomp ($_);
		if (m/^ layout: \s* (\S+) $/x)
		{
			printf (": %s => %s\n", $_, $1);
			$s_layout = $1;
		}
	}
}

$s_command_ex = $s_command_base;

#printf ("s_layout ${s_layout}.\n");

if ($s_layout eq "us")
{
	#printf "us...\n";
	$s_command_ex .= " ro -variant winkeys";
}
else
{
	#printf "Not us...\n";
	$s_command_ex .= " us";
}

printf ("Running: `%s`...\n", $s_command_ex);
`${s_command_ex}`;
