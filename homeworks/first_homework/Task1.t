ls -l | perl -naF'\s+' -e '$i=0;while($i<8){print shift(@F).";"; $i++;}print "@F", "\n"'>123.txt