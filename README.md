# MGRivetSetup
Setup of MadGraph and Rivet on UCL HEP cluster. Based on https://github.com/jguhit/MadGraph-.

INSTALLATIONS

All MadGraph tar files can be downloaded in this link: https://drive.google.com/drive/folders/1Rj31e2HTlckHM6OKe5Q5OLBm115o2sgZ?usp=sharing

I. Installing MG5_aMC_2.7.0 (Polarized Particles)

1) cd (if not already in home directory)
2) cp /home/guhitj/bsmxsec3/Madgraph/mg5_pol.tar .
3) tar -xvf mg5_pol.tar (this creates a directory with the MadGraph files and executables)
4) cd MG5_aMC_pol (or the name of the created directory)
5) Type ./bin/mg5_aMC (MadGraph Prompt)
[or to automate 5. you could create an alias in your .bashrc: alias Mad_Graph_pol='"Directory"/MG5_aMC_pol/bin/mg5_aMC']
6) After launching madgraph type the following:
  install lhapdf6 (for systematics)
  install pythia-pgs
  install pythia8
7) Type 'exit' to exit the program
8) In your .bashrc or .bash_profile, add the following lines:
   export PYTHIA8=path_to_PYTHIA8_installation
   export  LD_LIBRARY_PATH=$HOME/"Directory"/MG5_aMC_pol/HEPTools/hepmc/HepMC_install/lib:$LD_LIBRARY_PATH 
   export PATH=$PATH:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/bin
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include
   export  DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6
PYTHONPATH="/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include:/lustre/umt3/user/guhitj/New/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/bin:$PYTHONPATH"

export PYTHONPATH

II. Installing MadGraph5_v1.5.14 (Decay Package)

cp /home/guhitj/bsmxsec3/Madgraph/MadGraph5_v1.5.14.tar
tar -xvf MadGraph5_v1.5.14.tar
cd MadGraph5_v1_5_14
Type ./bin/mg5 (MadGraph Prompt)
or alias Mad_Graphv5='"Directory"/MadGraph5_v1_5_14/bin/mg5'
I.II Configuring the DECAY Package

cd MadGraph5_v1_5_14/DECAY
Replace the original decay_couplings.f and decay.f files by the ones attached in the repository
make (compile the decay code) This step creates an executable called "decay"
./decay or alias mad_decay='"Directory"/MadGraph5_v1_5_14/DECAY/decay'
III. RECIPE FOR GENERATING POLARIZED PARTICLES
Part 1: Generating the different polarization modes

Type MadGraph Prompt for version installed in I
Type 'generate p p > Z{L} Z{L} j j QCD=0' , {L} is for Longitudinal and {T} is for Transverse
To save process in an output file, type 'output "output folder"'
cd "output folder"
If you want to create multiple runs, then

./bin/madevent
Type multi_run 5 (5 is an arbitrary number)
Proceed to 7.
If you want to create just a single run, then proceed to 6.

./bin/generate_events
Five (1-5) switches containing which programs are run and you could choose which one to activate, e.g shower=Pythia8, activates the shower/hadronization program
When finished choosing the programs to run in 7., Type done
Prompts you to choose if you want to edit a Card (contains information about your process, the masses of particles, cuts, no. of events) e.g Type 2, and edit Events = 10000 to Events = 15000
When finished editing the Cards, Type done
Once the events are generated, Type exit
Part 2: Decaying Polarized Particles

In your output folder directory, cd /Events/run_01 (or the appropriate run folder)
Type 'gunzip unweighted_events.lhe.gz' to unzip the Les Houches Event Files
You should have an output called unweighted_events.lhe (you could choose to rename the .lhe file to something more specific if generating more than one .lhe file)
Execute the decay package, Type mad_decay or ./"Directory"/DECAY/decay
You are given a prompt to choose an "Input run mode", to decay events in the file, Type 1
Then you are asked the name of the event file to decay, Type unweighted_events.lhe (or the appropriate name of your .lhe file)
Type your desired output .lhe filename, Type "output.lhe"
Choose the particle you are decaying, e.g Type Z
Choose the appropriate decay mode, e.g Type 4 ( z -> l+ l-)
Done!
ANALYIS USING RIVET

Part 1: Converting .lhe to .hepmc file

Installing HepMC

Download source code from http://lcgapp.cern.ch/project/simu/HepMC/download/
Create a directory called 'hepmc' in your machine and save the above tar ball here. Type mkdir hepmc
On a terminal, cd to this 'hepmc' folder and type 'tar -xvf HepMC-2.06.09.gz'
Type 'mkdir HepMC_build HepMC_install'
Type 'cd HepMC_build' 6 ../HepMC-2.06.09/configure -prefix="Directory"/hepmc/HepMC_install -with-momentum=GEV -with-length=MM
Now type 'make'
Do 'make check'
Do 'make install'
If everything goes smooth, then done!
To continue with part 2, the following .h files have to be modified

GenEvent.h
GenVertex.h
GenParticle.h
SimpleVector.h
Polarization.h
IO-GenEvent.h
IO-BaseClass.h
When opening these .h file, change the "include" lines to the correct directory. For example, change #include "/home/HepMC-2.06.09/HepMC/GenVertex.h" to #include "/"directory"/hepmc/HepMC-2.06.09/HepMC/GenVertex.h"

These files are located in the following directories: (you must modify both files in these directories)

../hepmc/HepMC-2.06.09/HepMC
../hepmc/HepMC-2.06.09/include/HepMC
Part 2: Installing the lhef to hepmc converter

Make a directory lhef2hepmc, Type mkdir lhef2hepmc
cd lhef2hepmc
hg clone https://phab.hepforge.org/source/rivetcontribhg/browse/default/lhef2hepmc/
You should have four files in the directory: ChangeLog, Makefile, lhef2hepmc.cc, and ttbar.lhe

if hg command not found, instructions for installing hg (if working proceed to step 4)

Part 2.5: Installing Mercurial

Download source code at https://www.mercurial-scm.org/downloads (download the Mercurial 5.1 source release)
gunzip mercurial-5.1.tar.gz
tar -xvf mercurial-5.1.tar
cd mercurial-5.1
make local
check if working by ./hg --version
Leave directory and go back to lhef2hepmc directory and type ./mercurial-5.1/hg clone https://phab.hepforge.org/source/rivetcontribhg/browse/default/lhef2hepmc/
cd ../lhef2hepmc/
Type make HEPMC_PREFIX=/home/HepMC-2.06.09/
This should create an executable called "lhef2hepmc"
Part 3: Using the lhef to hepmc converter

In the lhef2hepmc directory, Type mkfifo fifo.hepmc
export LD_LIBRARY_PATH=$HOME/bsmxsec3/hepmc/HepMC_install/lib:$LD_LIBRARY_PATH
./lhef2hepmc ttbar.lhe fifo.hepmc &
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh or export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'
asetup 21.6.6,AthGeneration
source setupRivet.sh
mkdir Rivet
cd Rivet
Download files on the folder RivetFiles folder (uploaded in the repository)
rivet-buildplugin --with-root RivetATLAS_2019_I00001.so ATLAS_2019_I00001.cc
rivet -a ATLAS_2019_I00001 --pwd fifo.hepmc (The output file is a Rivet.yoda file)
rivet-mkhtml --mc-errs -o Test Rivet.yoda


