#!/bin/sh 

out1=`basename $0`_$$
out2=${out1}_demangle

nm $* > /tmp/${out1}
cat /tmp/${out1} | awk '{print $3}' | c++filt  > /tmp/${out2}

paste /tmp/${out1} /tmp/${out2}

