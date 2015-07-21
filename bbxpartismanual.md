MANUAL FOR BIOBOX CONTAINING PROJECT PARTIS

Make sure you have the following files/directories: 
assemble.sh (file)
parse_yaml.sh (file)
Taskfile (file)
input_data (directory): inputfile, YamlFileGenerator.py
output_data (directory)

1. Git clone the partis project (git repository is here: https://github.com/psathyrella/partis).
2. Place all the files mentioned before into the main partis directory
3. Run YamlFileGenerator.py and enter in the parameters. Make sure the generated yaml file is inside of the input_data directory.
4. Copy the input data file into the 'input_data' directory.
5. Build the docker image from the docker file (docker build -t <name of image> .)
6. Run this docker command: docker run --volume="$(pwd)/input_data:/bbx/input:ro" --volume="$(pwd)/output_data:/bbx/output:rw" <name of image> default

You should now see the output files in the directory you specified. 
