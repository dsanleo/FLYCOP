#!/bin/bash

# FLYCOP 
# Author: Beatriz García-Jiménez
# April 2018

dirScripts="../../Scripts"

suffix=$1
met1=$2
met2=$3
strain1=$4
strain2=$5

outFile="biomass_vs_"${met1}_${met2}_${suffix}".txt"
plotFile="biomass_vs_"${met1}_${met2}_${suffix}"_plot.pdf"

numMet1=`head -n1 media_log_${suffix}.txt | sed "s/.*{ //" | sed "s/}.*//" | sed "s/'//g" | sed "s/, /\n/g" | egrep -w -n ${met1} | cut -d: -f1`
numMet2=`head -n1 media_log_${suffix}.txt | sed "s/.*{ //" | sed "s/}.*//" | sed "s/'//g" | sed "s/, /\n/g" | egrep -w -n ${met2} | cut -d: -f1`

met1File="media_log_substrate_"${met1}".txt"
egrep '\{'$numMet1'\}' media_log_${suffix}.txt | sed "s/media_//" | sed "s/{$numMet1}//" | sed "s/(1, 1)//" | sed "s/sparse.*/0.0/" | sed "s/;$//" | sed "s/\ =\ /\t/" | awk -F"\t" 'BEGIN{oldCycle=0;value=-1}{if($1!=oldCycle){print value; oldCycle=$1; value=$2}else{value=$2}}END{print value}' > $met1File
met2File="media_log_substrate_"${met2}".txt"
egrep '\{'$numMet2'\}' media_log_${suffix}.txt | sed "s/media_//" | sed "s/{$numMet2}//" | sed "s/(1, 1)//" | sed "s/sparse.*/0.0/" | sed "s/;$//" | sed "s/\ =\ /\t/" | awk -F"\t" 'BEGIN{oldCycle=0;value=-1}{if($1!=oldCycle){print value; oldCycle=$1; value=$2}else{value=$2}}END{print value}' > $met2File

paste -d'\t' total_biomass_log_${suffix}.txt ${met1File} ${met2File} > $outFile
rm ${met1File} ${met2File}

Rscript --vanilla ${dirScripts}/plot.biomassX2.vs.2substrate_higher.r $outFile $plotFile $met1 $met2 $strain1 $strain2



