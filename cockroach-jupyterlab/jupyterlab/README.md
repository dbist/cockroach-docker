# This a multi-stage build to create a jupyterlab container based on this [tutorial](https://www.datacamp.com/community/tutorials/sql-interface-within-jupyterlab)

Running the container individually requires 2 steps.

1. build the container

```bash
docker build -t dbist/jupyterlab:031720 .
```

2. run the container

```bash
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work dbist/jupyterlab
```
