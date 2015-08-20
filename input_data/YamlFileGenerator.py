#!/usr/bin/env python
#This python generates a yaml file for Partis based on user input
#6-24-15
print '#==========================================================='
#Import necessary libraries
import sys
import argparse
import yaml
print '#==========================================================='
#The dictionary that will contain the input from 'biobox.yml'
output = {}
print '#==========================================================='
#the main function
#This function asks for parameters first for 'cache parameters', and then one of the following: simulation, run viterbi, run forward' 
#It then dumps the information in key value pairs into a file called 'biobox.yml'
def main():
	#asks for cache parameter action parameters
	output['cacheparameters'] = {}
	print "Enter sub parameters for intermediate action- \"cache-parameters:\"\n"

	seqfile = raw_input('Enter the location of your input sequential text file (i.e. ./test/A-subset-200.tsv): ')
	is_data = query_yes_no("Set is-data to true?: ") 
	skip_unproductive = query_yes_no("Set skip_unproductive to true?: ") 
	parameter_dir = raw_input('Enter the location of the parameter directory (i.e. /bbx/output/_output/example/data): ') 
	plotdir = raw_input('Enter the location of the plot directory (i.e. /bbx/output/_plots/example): ')
	n_max_queries = raw_input('Enter n_max_queries (i.e. 200): ')

	output['cacheparameters']['seqfile'] = seqfile
	output['cacheparameters']['isdata'] = is_data
	output['cacheparameters']['skipunproductive'] = skip_unproductive
	output['cacheparameters']['parameterdir'] = parameter_dir
	output['cacheparameters']['plotdir'] = plotdir
	output['cacheparameters']['nmaxqueries'] = n_max_queries

	#taking in parameters based on action entered
	action = raw_input("Enter the final action (simulate, runviterbi, runforward): ")

	if action == 'simulate':
		outfname = raw_input('Enter the name of the output file (i.e. /bbx/output/_output/example/simu.csv): ')
		parameter_dir = raw_input('Enter the location of the parameter directory (i.e. /bbx/output/_output/example/data/hmm): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 200): ')

		output['simulate'] = {}
		output['simulate']['outfname'] = outfname
		output['simulate']['parameterdir'] = parameter_dir
		output['simulate']['nmaxqueries'] = n_max_queries

	elif action == 'runviterbi':
		seqfile = raw_input('Enter the location of your input sequential text file (i.e. ./test/A-subset-200.tsv): ')
		is_data = query_yes_no('Set is_data to true?"')
		parameter_dir = raw_input('Enter the location of the parameter directory (i.e. /bbx/output/_output/example/data/hmm): ') 
		n_best_events = raw_input('Enter n_best_events (i.e. 5): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 1): ')
		debug = raw_input('Enter the debug level (i.e. 1): ')
		outfname = raw_input('Enter the name of the output file (i.e. /bbx/output/_output/example/viterbi.csv): ')
		plotdir = raw_input('Enter the location of the plot directory (i.e. /bbx/output/_plots/example): ')
		plotperformance = query_yes_no('Set --plot-performance to true?"')

		output['runviterbi'] = {}
		output['runviterbi']['seqfile'] = seqfile
		output['runviterbi']['isdata'] = is_data
		output['runviterbi']['parameterdir'] = parameter_dir
		output['runviterbi']['nbestevents'] = n_best_events
		output['runviterbi']['nmaxqueries'] = n_max_queries
		output['runviterbi']['debug'] = debug
		output['runviterbi']['outfname'] = outfname
		output['runviterbi']['plotdir'] = plotdir
		output['runviterbi']['plotperformance'] = plotperformance

	elif action == 'runforward':
		seqfile = raw_input('Enter the location of your input sequential text file (i.e. ./test/A-subset-200.tsv): ')
		is_data = query_yes_no('Set is_data to true?"')
		parameter_dir = raw_input('Enter the location of the parameter directory (i.e. /bbx/output/_output/example/data/hmm): ') 
		n_best_events = raw_input('Enter n_best_events (i.e. 5): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 1): ')
		debug = raw_input('Enter the debug level (i.e. 1): ')
		outfname = raw_input('Enter the name of the output file (i.e. /bbx/output/_output/example/forward.csv): ')
		plotdir = raw_input('Enter the location of the plot directory (i.e. /bbx/output/_plots/example): ')
		plotperformance = query_yes_no('Set --plot-performance to true?"')

		output['runforward'] = {}
		output['runforward']['seqfile'] = seqfile
		output['runforward']['isdata'] = is_data
		output['runforward']['parameterdir'] = parameter_dir
		output['runforward']['nbestevents'] = n_best_events
		output['runforward']['nmaxqueries'] = n_max_queries
		output['runforward']['debug'] = debug
		output['runforward']['outfname'] = outfname
		output['runforward']['plotdir'] = plotdir
		output['runforward']['plotperformance'] = plotperformance
	
	#write information into file called 'biobox.yml'
	with open('biobox.yml', 'w') as f:
		f.write(yaml.dump(output, default_flow_style=False))
print '#==========================================================='
#Method that returns true if yes and false if no for a given question
def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")
print '#==========================================================='
#Start of the script
if __name__ == '__main__':
   main()
print '#==========================================================='
#CODE FROM DEVELOPMENT
# output = {"is_data":True,
# 	"skip_unproductive":True,
# 	"seqfile":"input_data/A-subset-200.tsv",
# 	"plotdir":"_plots/example",
# 	"parameter_dir":"_output/example/data",
# 	"action":"cache-parameters"}

#prints contents of dictionary
#for key, value in output.items():
#	print key, value

# with open('biobox.yaml', 'w') as f:
# 	f.write(yaml.dump(output, default_flow_style=False))

