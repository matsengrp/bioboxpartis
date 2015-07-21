#!/usr/bin/env python
#This python generates a yaml file for Partis based on user input
#6-24-15

#Import necessary libraries
import sys
import argparse
import yaml

#The dictionary that will contain the input
output = {}

#the main function
def main():


	output['cacheparameters'] = {}

	print "Enter sub parameters for intermediat action - cache-parameters:\n"
	seqfile = raw_input('Enter the seqfile (i.e. test/A-every-100-subset-0.tsv.bz2): ')
	is_data = query_yes_no("Set is-data to True?: ") 
	skip_unproductive = query_yes_no("Set skip_unproductive to True?: ") 
	parameter_dir = raw_input('Enter parameter-dir (i.e. _output/example/data): ') 
	plotdir = raw_input('Enter plotdir (i.e. _plots/example): ')

	output['cacheparameters']['seqfile'] = seqfile
	output['cacheparameters']['isdata'] = is_data
	output['cacheparameters']['skipunproductive'] = skip_unproductive
	output['cacheparameters']['parameterdir'] = parameter_dir
	output['cacheparameters']['plotdir'] = plotdir

	action = raw_input("Enter the action(simulate, run-viterbi, run-forward): ")

	if action == 'simulate':
		outfname = raw_input('Enter outfname (i.e. _output/example/simu.csv): ')
		parameter_dir = raw_input('Enter parameter_dir (i.e. _output/example/data/hmm): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 10): ')

		output['simulate'] = {}
		output['simulate']['outfname'] = outfname
		output['simulate']['parameterdir'] = parameter_dir
		output['simulate']['nmaxqueries'] = n_max_queries

	elif action == 'runviterbi':
		seqfile = raw_input('Enter seqfile (i.e. test/A-every-100-subset-0.tsv.bz2): ')
		is_data = query_yes_no('Set is_data to True?"')
		parameter_dir = raw_input('Enter parameter_dir (i.e. _output/example/data/hmm): ')
		n_best_events = raw_input('Enter n_best_envets (i.e. 5): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 1): ')
		debug = raw_input('Use debug? (i.e. 1): ')

		output['runviterbi'] = {}
		output['runviterbi']['seqfile'] = seqfile
		output['runviterbi']['isdata'] = is_data
		output['runviterbi']['parameterdir'] = parameter_dir
		output['runviterbi']['nbestevents'] = n_best_events
		output['runviterbi']['nmaxqueries'] = n_max_queries
		output['runviterbi']['debug'] = debug

	elif action == 'runforward':
		seqfile = raw_input('Enter seqfile (i.e. test/A-every-100-subset-0.tsv.bz2): ')
		is_data = query_yes_no('Set is_data to True?"')
		parameter_dir = raw_input('Enter parameter_dir (i.e. _output/example/data/hmm): ')
		n_best_events = raw_input('Enter n_best_envets (i.e. 5): ')
		n_max_queries = raw_input('Enter n_max_queries (i.e. 1): ')
		debug = raw_input('Use debug? (i.e. 1): ')

		output['runforward'] = {}
		output['runforward']['seqfile'] = seqfile
		output['runforward']['isdata'] = is_data
		output['runforward']['parameterdir'] = parameter_dir
		output['runforward']['nbestevents'] = n_best_events
		output['runforward']['nmaxqueries'] = n_max_queries
		output['runforward']['debug'] = debug

	with open('biobox.yml', 'w') as f:
		f.write(yaml.dump(output, default_flow_style=False))

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



#Start of the script
if __name__ == '__main__':
   main()

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

