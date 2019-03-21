import synapseclient
import argparse
import json

if __name__ == '__main__':

    parser = argparse.ArgumentParser("Creates a folder in synapse")

    parser.add_argument(
            '-n', 
            '--folder_name', 
            type = str,
            required=True)
    
    parser.add_argument(
            '-c',
            '--synapse_config_file', 
            type = str,
            required=True)
    
    parser.add_argument(
            '-p', 
            '--parent_synapse_id', 
            type = str,
            required=True)
    
    parser.add_argument(
            '-a',
            '--annotations_json_file',
            type=str)
    
    parser.add_argument(
            '-r', 
            '--results_json_file',
            type=str,
            default="properties.json")

    args = parser.parse_args()

    syn = synapseclient.Synapse(configPath=args.synapse_config_file)
    syn.login()

    if args.annotations_json_file is not None:
        annotations_json_file = open(args.annotations_json_file)
        annotations_json_str  = annotations_json_file.read()
        annotations_dict = json.loads(annotations_json_str)

    folder_entity = synapseclient.Folder(
        args.folder_name, 
        parent=args.parent_synapse_id, 
        annotations=annotations_dict)

    folder_entity = syn.store(folder_entity)

    with open(args.results_json_file, 'w') as o:
      o.write(json.dumps(folder_entity.properties))

