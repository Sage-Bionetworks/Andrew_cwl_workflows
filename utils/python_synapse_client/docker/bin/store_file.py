import synapseclient
import argparse
import json

if __name__ == '__main__':

    parser = argparse.ArgumentParser("Stores a file in synapse")

    parser.add_argument('-f', '--file', type = str, required=True)
    parser.add_argument('-c', '--synapse_config_file', type = str, required=True)
    parser.add_argument('-p', '--parent_synapse_id', type = str, required=True)
    
    parser.add_argument('-a', '--annotations_json_file', type=str)
    parser.add_argument('-n', '--activity_name', type = str)
    parser.add_argument('-d', '--activity_description', type = str)
    parser.add_argument('-u', '--used_list', type = str, nargs = '+')
    parser.add_argument('-e', '--executed_list', type = str, nargs = '+')
    parser.add_argument('-r', '--results_json_file', type=str, default="properties.json")

    args = parser.parse_args()

    syn = synapseclient.Synapse(configPath=args.synapse_config_file)
    syn.login()

    if args.annotations_json_file is not None:
        annotations_json_file = open(args.annotations_json_file)
        annotations_json_str  = annotations_json_file.read()
        annotations_dict = json.loads(annotations_json_str)
    else:
        annotations_dict = None

    file_entity = synapseclient.File(
        args.file, 
        parent=args.parent_synapse_id, 
        annotations=annotations_dict)

    activity_entity = synapseclient.Activity(
        name=args.activity_name, 
        description=args.activity_description, 
        used=args.used_list, 
        executed=args.executed_list)

    file_entity = syn.store(file_entity, activity=activity_entity)

    with open(args.results_json_file, 'w') as o:
      o.write(json.dumps(file_entity.properties))

