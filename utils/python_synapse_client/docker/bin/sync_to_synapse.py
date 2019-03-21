import synapseclient
import argparse
import synapseutils

if __name__ == '__main__':

    parser = argparse.ArgumentParser("Stores files in Synapse")

    parser.add_argument(
            '-m',
            '--manifest_file',
            type = str,
            required=True)
    
    parser.add_argument(
            '-c', 
            '--synapse_config_file', 
            type = str, 
            required=True)   

    args = parser.parse_args()

    syn = synapseclient.Synapse(configPath=args.synapse_config_file)
    syn.login()

    synapseutils.sync.syncToSynapse(syn, args.manifest_file)
