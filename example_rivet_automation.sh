#!/bin/sh

# Script to run analysis via rivet on a lhe file.
# Input: zipped lhe file OR fifo file from pythia pipe, analysis name (default is lhe file name), folder name (default is creating new dir based on analysis name if needed)
# Output: [analysis name].yoda

if [[ "$#" -lt 1 ]]; then
	echo 'Need some arguments' >&2
	exit 1
fi

zipname=$1
name="${2:-${zipname%%.*}}"
foldername="${3:-$name}"

function initsetup() {
	# loading stuff, decode input file names, create analysis directory folder if needed
	mkdir -p /unix/bsmxsec/sgantayet/Analyses/$foldername
	if [[ "${zipname: -2}" == "gz" ]]; then
		gunzip $zipname
		zipname="${zipname%.*}"
	fi

	if [[ "${zipname: -3}" == "pmc" ]] || [[ "${zipname: -3}" == "ifo" ]]; then
		fn=$zipname
	else
		cp *.log $zipname /unix/bsmxsec/sgantayet/Analyses/$foldername
		fn=$zipname
		cd /unix/bsmxsec/sgantayet/Analyses/$foldername
	fi

	echo "Beginning analysis process on ${fn}..."
}

function lhef2hepmc() {
	# run lhef2hepmc if input is lhe and NOT fifo
	if [[ ${fn: -3} == "lhe" ]]; then
		fifoname="${name}.hepmc"
		mkfifo $fifoname
		~/lhef2hepmc/lhef2hepmc/lhef2hepmc $fn $fifoname &
	else
		# cp $fn "RUN${fn}"
		fifoname=${fn}
	fi

}

function rivetrun() {
	# run rivet analysis (atlas setup needs to be done alraedy)
	cp /home/sgantayet1/SFNP/Code/OutputTest/RivetATLAS_2019_I00001.so .
	rivet -a ATLAS_2019_I00001 --pwd $fifoname -o "${name}.yoda" 

}

function deletefiles() {
	# remove unecessary files
	rm RivetATLAS_2019_I00001.so
	rm $fifoname

}

function outputManage() {

	# move output files from script to the right folders
	if [[ "${zipname: -3}" == "pmc" ]] || [[ "${zipname: -3}" == "ifo" ]]; then
		ffolder="/unix/bsmxsec/sgantayet/Analyses/$foldername"
		mv *.yoda test*.txt *weights*.txt $ffolder
		cp *.log $ffolder
		cd $ffolder
	fi

	mkdir -p LHEFiles
	mkdir -p LogFiles
	[ ! -f $fn ] || mv $fn LHEFiles
		
	for log in *.log; do
		mv "$log" "${log%.log}_${name}.log"
	done
	mv *.log LogFiles

	mkdir -p OutputFiles	

	outputname="${name}_output.txt"
	outputnamelate="${name}_output_late.txt"
	# effname="${name}Eff.txt"

	mv test.txt $outputname 
	mv $outputname OutputFiles/

	mv test2.txt $outputnamelate
	mv $outputnamelate OutputFiles/

	mv weights*.txt OutputFiles/
}

echo '**********************************************'
initsetup
echo 'Done'
echo '**********************************************'
echo 'Running lhef2hepmc...'
lhef2hepmc
echo 'Done'
echo '**********************************************'
echo 'Running Rivet...'
rivetrun
echo 'Done'
echo '**********************************************'
echo 'Cleaning up files...'
deletefiles
outputManage
echo 'All done!'
echo '**********************************************'


