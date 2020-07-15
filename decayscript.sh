#!/usr/bin/env bash

gunzip unweighted_events.lhe
~/testfolder/decaypkg/MadGraph5_v1_5_14/DECAY/decay << EOF
1
unweighted_events.lhe
decayed.lhe
z
4
EOF
mv unweighted_events.lhe old.lhe
mv decayed.lhe unweighted_events.lhe
gzip unweighted_events.lhe
mkfifo myfifo.hepmc.fifo
sleep 1s
rm tag_1_pythia8.cmd
cp ~/SFNP/Code/tag_1_pythia8.cmd .
sleep 1s
# ./run_shower.sh &
# mv myfifo.hepmc.fifo myfifo.hepmc

