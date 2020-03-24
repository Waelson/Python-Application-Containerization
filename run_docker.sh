
#!/bin/bash

# Build image
docker build --tag=aplicacao .

# List docker images
docker image ls

# Run flask app
docker run -p 8000:5001 aplicacao
