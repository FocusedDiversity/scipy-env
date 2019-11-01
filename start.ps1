docker image build -t scipy-env:latest .
docker container run -ti -P `
    -e PORT=51000 `
    -p 127.0.0.1:51000:51000 `
    -v ${PWD}/data:/home/jupyter/data:ro `
    -v ${PWD}/src:/home/jupyter/src `
    -v ${PWD}/notebooks:/home/jupyter/notebooks `
    -v ${PWD}/scratch:/home/jupyter/scratch `
    scipy-env:latest
