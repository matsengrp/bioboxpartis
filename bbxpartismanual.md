#Manual for biobox for partis
#NOTE: paths in places (i.e. Taskfile) will most likely have to be altered according to your specific directory

Make sure you have the following files/directories all in one directory:
assemble.sh (file)
parse_yaml.sh (file)
Taskfile (file)
input_data (directory): inputfile, YamlFileGenerator.py
output_data (directory)
partis project (directory)

1. Build the docker image from the docker file (docker build -t <name of image> .) 
2. Run YamlFileGenerator.py and enter in the parameters. Make sure the generated yaml file is inside of the input_data directory.
3. Run this docker command: docker run --volume="$(pwd)/input_data:/bbx/input:ro" --volume="$(pwd)/output_data:/bbx/output:rw" <name of image> default
