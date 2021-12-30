# BITRONIT API DOCUMENTATION

## To run on local using docker:
```shell
docker run --rm --name slate -v $(pwd)/build:/srv/slate/build -v $(pwd)/source:/srv/slate/source slatedocs/slate build
docker run --rm --name slate -p 4567:4567 -v $(pwd)/source:/srv/slate/source slatedocs/slate serve 
http://localhost:4567/
```
