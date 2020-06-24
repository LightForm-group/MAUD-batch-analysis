#! /bin/sh -f
MAUD_PATH=`dirname "$0"`
cd $MAUD_PATH
MAUD_PATH=`pwd`
./jrel.8.0_131/bin/java -mx8192M -Duser.dir=$MAUD_PATH -cp lib/Maud.jar:lib/ij.jar com.radiographema.MaudText -file $MAUD_PATH/instruction.ins

./jdk/bin/java -mx8192M --add-opens java.base/java.net=ALL-UNNAMED -Duser.dir=$MAUD_PATH -cp lib/Maud.jar:lib/ij.jar:lib/jgap.jar:lib/Help.jar:lib/EsquiClient.jar:lib/com.github.tschoonj.xraylib.jar:lib/joone-engine.jar:lib/newt.all.jar:lib/jdic.jar:lib/jdom.jar:lib/sqlite-jdbc.jar:lib/jmol.jar:lib/jgaec.jar:lib$ar:lib/Files.jar:lib/xgridlib.jar:lib/xgridagent.jar:lib/jogl.all.jar:lib/Examples.jar:lib/commons-math.jar:lib/rome.jar:lib/nativewindow.all.jar:lib/Images.jar:lib/swingx.jar:lib/jdic_stub.jar:lib/MySQL-ConnectorJ.jar:lib/HTTPClient.jar:lib/miscLib.jar:lib/gluegen-rt.jar com.radiographema.Maud

./jdk/bin/java -mx8192M -Duser.dir=$MAUD_PATH -cp lib/Maud.jar:lib/ij.jar com.radiographema.MaudText -file $MAUD_PATH/instruction.ins

Write a shell script to launch MAUD in batch mode. Note, although the shell script includes the path of an instruction file that doesn't exist, it should prompt MAUD to load a window to click and select an instruction file in a different directory (or at least this is what happens on my mac) and run in batch mode.

ssh -X mbcx9cd4@incline256.itservices.manchester.ac.uk
cd /opt/gridware3/apps/binapps/maud/2.93
nano maud_batch.sh

#! /bin/sh -f
MAUD_PATH=`dirname "$0"`
cd $MAUD_PATH
MAUD_PATH=`pwd`
./jdk/bin/java -mx8192M -Duser.dir=$MAUD_PATH -cp lib/Maud.jar:lib/ij.jar com.radiographema.MaudText -file $MAUD_PATH/instruction.ins

Then save using CTRL+X, Y, Enter

Error writing maud_batch.sh: Permission denied

