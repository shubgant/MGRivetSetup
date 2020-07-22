#!/usr/bin/python

import sys
import yoda

def yoda_chisq(hist1, hist2):
    # function to calculate chisquare for all hists between two yoda files
    # first argument is the SM yoda file, second is the non-SM yoda file


    # read in yoda files
    h1 = yoda.read(hist1)
    h2 = yoda.read(hist2)

    # remove non histograms (ones that don't start with /ATLAS)
    for item in h1.keys():
        if "/ATLAS" not in str(item):
            non_hist = h1.pop(item)
            print("Removing {item}".format(item=non_hist))

    for item in h2.keys():
        if "/ATLAS" not in str(item):
            non_hist = h2.pop(item)
            print("Removing {item}".format(item=non_hist))

    chisquare_all = {}
    # loop over all histograms
    for hist in h1.keys():
        # get name of histogram
        hist_name = str(h1[hist]).split('/')[-1].split("'")[0]
        # check if histogram name matches between yoda files
        if hist_name != str(h2[hist]).split('/')[-1].split("'")[0]:
            sys.stderr.write("***\n")
            sys.stderr.write("Error: Yodas are probably from different analyses\n")
            sys.stderr.write("***\n")
            return
        print("Processing histogram " + hist_name + "...")

        # get bins of histogram
        hb1 = h1[hist].bins()    
        hb2 = h2[hist].bins()    

        # loop over bins, adding to the chisquare sum each iteration
        chisquare_all[hist_name] = 0
        for i in range(0, len(hb1)-1):
            error = hb1[i].numEntries() ** 0.5 # error is sqrt(N) for bins in yoda1
            # if error is 0, add 0 to chisquare
            if error == 0:
                continue
            # add to the chisquare value for the current histogram
            chisquare_all[hist_name] += (hb1[i].numEntries() - hb2[i].numEntries()) ** 2 / error ** 2

    print(chisquare_all)

yoda_chisq("EWK_total_output.yoda","QCD_total_output.yoda")
