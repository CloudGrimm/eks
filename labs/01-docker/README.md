# Lab 01 - Building & Running a Docker Image

For this lab, you'll need to be in the `~/environment/eks/labs/01-docker` directory in Cloud9:

```bash
cd ~/environment/eks/labs/01-docker
```

## Build an image based off the Dockerfile

```bash
docker build -t python-app .
```

## Run a container from the image

```bash
$ docker run -i --rm -p 5000:5000 python-app
* Serving Flask app "server" (lazy loading)
...
* Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

The container is now running and the application is exposed on port `5000`.

## Access the web application

In Cloud9, click on `Window` at the top -> `New Terminal` then run the following command:

```bash
$ curl http://0.0.0.0:5000/
{"time":"2021-04-24T07:28:52.677979"}
```

You should see a response with the current time as well as a log entry in the old terminal window where the container is running.

Press CTRL+C to quit.
