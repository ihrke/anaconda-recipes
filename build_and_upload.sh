# get conda info about root_prefix and platform
function conda_info {
    conda info --json | python -c "import json, sys; print(json.load(sys.stdin)['$1'])"
}

CONDA_ENV=$(conda_info root_prefix)
PLATFORM=$(conda_info platform)
BUILD_PATH=$CONDA_ENV/conda-bld/$PLATFORM

for f in `ls | grep r-`;
do 
echo "BUILDING $f"
echo "==========================================="
conda build $f; 
conda install $f --use-local; 

echo "CONVERTING $f"
echo "==========================================="
conda convert $BUILD_PATH/$f*.tar.bz2 -p all

echo "UPLOADING $f"
echo "==========================================="
anaconda -t ${ANACONDA_TOKEN} upload $BUILD_PATH/$f*.tar.bz2 --force

done
