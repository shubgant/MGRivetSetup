# MGRivetSetup
Setup of MadGraph and Rivet on UCL HEP cluster. Based on https://github.com/jguhit/MadGraph- with minor changes and formatting.

## INSTALLATIONS

All MadGraph tar files can be downloaded in this link: https://drive.google.com/drive/folders/1Rj31e2HTlckHM6OKe5Q5OLBm115o2sgZ?usp=sharing

### I. Installing MG5_aMC_2.7.0 (Polarized Particles)

1) `cd` (if not already in home directory)
2) `cp /home/guhitj/bsmxsec3/Madgraph/mg5_pol.tar .`
3) `tar -xvf mg5_pol.tar` (this creates a directory with the MadGraph files and executables)
4) `cd MG5_aMC_pol` (or the name of the created directory, might be nested i.e. ~/~maddevelopers/mg5amcnlo/2.6.5_polarization/)
5) Type `./bin/mg5_aMC` (MadGraph Prompt)
   a) (or to automate 5. you could create an alias in your .bashrc: alias Mad_Graph_pol='"Directory"/MG5_aMC_pol/bin/mg5_aMC')
6) After launching madgraph type the following:
   - install lhapdf6
   - install pythia-pgs
   - install pythia8
7) Type 'exit' to exit the program
8) In your .bashrc or .bash_profile, add the following lines, replacing `"Directory"` with the correct path, and `MG5_aMC_pol` with correct folder name:

```
export PYTHIA8=~/"Directory"/HEPTools/
   
export LD_LIBRARY_PATH=$HOME/"Directory"/MG5_aMC_pol/HEPTools/hepmc/HepMC_install/lib:$LD_LIBRARY_PATH 
   
export PATH=$PATH:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/bin
   
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include
   
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6
   
PYTHONPATH="/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/include:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/lib:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6:/"Directory"/MG5_aMC_pol/HEPTools/lhapdf6/bin:$PYTHONPATH"

export PYTHONPATH
```

### II.I Installing MadGraph5_v1.5.14 (Decay Package)

1) `cd` (if not already in home directory)
2) `cp /home/guhitj/bsmxsec3/Madgraph/MadGraph5_v1.5.14.tar`
3) `tar -xvf MadGraph5_v1.5.14.tar`
4) `cd MadGraph5_v1_5_14`
5) Type `./bin/mg5` (MadGraph Prompt)
   a) or `alias Mad_Graphv5='"Directory"/MadGraph5_v1_5_14/bin/mg5'` in bashrc

### II.II Configuring the DECAY Package

1) `cd` (if not already in home directory)
2) `cd MadGraph5_v1_5_14/DECAY`
3) Replace the original decay_couplings.f and decay.f files by the ones attached in the repository (use git or winscp)
4) `make` (compile the decay code). This step creates an executable called "decay"
5) `./decay` or `alias mad_decay='"Directory"/MadGraph5_v1_5_14/DECAY/decay'` in bashrc

### III. RECIPE FOR GENERATING POLARIZED PARTICLES

#### Part 1: Generating the different polarization modes

1) Type MadGraph Prompt for version installed in I.5
2) Type 'generate p p > Z{L} Z{L} j j QCD=0' , {L} is for Longitudinal and {T} is for Transverse
3) To save process in an output file, type 'output foldername', replace foldername with desired output folder name
4) cd foldername
5) If you want to create just a single run, then proceed to 6. If you want to create multiple runs, then
   - `./bin/madevent`
   - Type `multi_run 5` (5 is an arbitrary number)
   - Proceed to 7.
6) `./bin/generate_events`
7) Five (1-5) switches containing which programs are run and you could choose which one to activate, e.g shower=Pythia8, activates the shower/hadronization program
8) When finished choosing the programs to run in 7., Type done
9) Prompts you to choose if you want to edit a Card (contains information about your process, the masses of particles, cuts, no. of events) e.g Type 2, and edit Events = 10000 to Events = 1000
10) When finished editing the Cards, Type done
11) Once the events are generated, Type exit

#### Part 2: Decaying Polarized Particles

1) In your output folder directory, `cd /Events/run_01` (or the appropriate run folder)
2) Type 'gunzip unweighted_events.lhe.gz' to unzip the Les Houches Event Files
3) You should have an output called unweighted_events.lhe (you could choose to rename the .lhe file to something more specific if generating more than one .lhe file)
4) Execute the decay package, Type mad_decay or ./"Directory"/DECAY/decay
5) You are given a prompt to choose an "Input run mode", to decay events in the file, Type 1
6) Then you are asked the name of the event file to decay, Type unweighted_events.lhe (or the appropriate name of your .lhe file)
7) Type your desired output .lhe filename, Type "output.lhe"
8) Choose the particle you are decaying, e.g Type Z
9) Choose the appropriate decay mode, e.g Type 4 ( z -> l+ l-)
Done!

### IIII. ANALYSIS USING RIVET

#### Part 1: Converting .lhe to .hepmc file

**Installing HepMC**

1) Download source code from http://lcgapp.cern.ch/project/simu/HepMC/download/
2) Create a directory called 'hepmc' in your home directory and save the above tar ball here (type `cd; mkdir hepmc`)
3) On a terminal, cd to this 'hepmc' folder and type `tar -xvf HepMC-2.06.09.gz`
4) Type `mkdir HepMC_build HepMC_install`
5) Type 'cd HepMC_build' 
6) Type `../HepMC-2.06.09/configure -prefix="Directory"/hepmc/HepMC_install -with-momentum=GEV -with-length=MM`
7) Now type 'make'
8) Do 'make check'
9) Do 'make install'
10) If everything goes smooth, then done!

To continue with part 2, the following .h files have to be modified

- GenEvent.h
- GenVertex.h
- GenParticle.h
- SimpleVector.h
- Polarization.h
- IO_GenEvent.h
- IO_BaseClass.h

When opening these .h file, change the "include" lines to the correct directory. For example, change `#include "/home/HepMC-2.06.09/HepMC/GenVertex.h"` to `#include "/"directory"/hepmc/HepMC-2.06.09/HepMC/GenVertex.h"`

These files are located in the following directories: (you must modify both files in these directories)

- ../hepmc/HepMC-2.06.09/HepMC
- ../hepmc/HepMC_install/include/HepMC

#### Part 2: Installing the lhef to hepmc converter

1) Make a directory lhef2hepmc, i.e. `cd; mkdir lhef2hepmc`
2) `cd lhef2hepmc`
3) hg clone https://phab.hepforge.org/source/rivetcontribhg/browse/default/lhef2hepmc/
   - You should have four files in the directory: ChangeLog, Makefile, lhef2hepmc.cc, and ttbar.lhe

if hg command not found, instructions for installing hg (if working proceed to step 4)

----

#### Part 2.5: Installing Mercurial

1) Download source code at https://www.mercurial-scm.org/downloads (download the latest version supporting the system's Python version, check with `python --version` in terminal)
2) `gunzip mercurial-5.1.tar.gz` (or whatever the zipped file is named)
3) `tar -xvf mercurial-5.1.tar`
4) `cd mercurial-5.1`
5) `make local`
6) check if working by `./hg --version`
7) Leave directory and go back to lhef2hepmc directory and type `./mercurial-5.1/hg clone https://phab.hepforge.org/source/rivetcontribhg/browse/default/lhef2hepmc/`

---- 

4) `cd ../lhef2hepmc/`
5) Type `make HEPMC_PREFIX=$HOME/hepmc/HepMC_install`
6) This should create an executable called "lhef2hepmc"

#### Part 3: Using the lhef to hepmc converter

1) In the lhef2hepmc directory, Type mkfifo fifo.hepmc
2) Type `export LD_LIBRARY_PATH="Directory"/hepmc/HepMC_install/lib:$LD_LIBRARY_PATH`
3) Type `./lhef2hepmc ttbar.lhe fifo.hepmc &` (include the ampersand at the end)
4) Type the following (or add to an alias in bashrc to run quicker in future):
   - `export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase`
   - `alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'`
   - `setupATLAS`
5) `asetup 21.6.6,AthGeneration`
6) `source setupRivet.sh`
7) `mkdir Rivet`
8) `cd Rivet`
9) Download files on the folder RivetFiles folder (uploaded in the repository), use WinSCP or Git
10) `rivet-buildplugin --with-root RivetATLAS_2019_I00001.so ATLAS_2019_I00001.cc`
11) `rivet -a ATLAS_2019_I00001 --pwd fifo.hepmc` (The output file is a Rivet.yoda file)
12) `rivet-mkhtml --mc-errs -o Test Rivet.yoda`

If all setup was successful, look at Example.md to run a trial generation/analysis process.


