import synapseclient
import argparse

if __name__ == '__main__':

    parser = argparse.ArgumentParser("Gets file from synapse")

    parser.add_argument(
            '-s',
            '--synapse_id',
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

    entity = syn.get(args.synapse_id, downloadLocation = '.')
    entity_type = entity.properties["concreteType"]
    
    assert entity_type =="org.sagebionetworks.repo.model.FileEntity", (
        args.synapse_id + " is not a synapse file: " + entity_type)

