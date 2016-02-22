# docker-parse-server-git-deploy

[![](https://badge.imagelayers.io/arnaudvalensi/docker-parse-server-git-deploy:latest.svg)](https://imagelayers.io/?images=arnaudvalensi/docker-parse-server-git-deploy:latest 'Get your own badge on imagelayers.io')

![](img/parse_logo.png)

Quickly and easily install a Parse server and deploy code using git push.

You should not have to write any code to have a production server, like you would with a parse.com service.

Pull-Request are welcomed

## Quick start

* Create a db on https://mongolab.com/

* Copy `example/data` to the machine you will use to deploy this container:

```
cp -r example/data /srv/parse-data
```

* Replace the ssh public key in `/srv/parse-data/keys` by yours

* Execute the following command:

```
docker run -d \
       -v /srv/parse-data:/srv \
       -e DATABASE_URI=mongodb://<user>:<password>@ds055885.mongolab.com:55885/codetown \
       -e APP_ID=<appId> \
       -e MASTER_KEY=<masterKey> \
       -p 1337:1337 \
       -p 2222:22 \
       --name parse arnaudvalensi/docker-parse-server-git-deploy:latest
```

> Replace `<user>` and `<password>` by yours.
Replace `<appId>` and `<masterKey>` too.

* The container now provides a git repository, clone it:

```
git clone ssh://root@<yourhost>:2222/srv/repo.git ~/parse-cloud
```

> Replace `<yourhost>` by your host

* Add the code in `example/parse-cloud` into your repo and push:

```
cp -r example/parse-cloud/* ~/parse-cloud
cd ~/parse-cloud
git add *
git commit -m "add base files"
git push
```

Your Parse server is now in production. Every time you want to modify the cloud, you just need to push to restart the server with the new files.

A file `cloud/server.js` allows you to configure the express server before it is started. You can configure new routes or any express behavior with it.

## Verification

```
curl -v http://<yourhost>:1337

curl -X POST \
  -H "X-Parse-Application-Id: <YOUR_APP_ID>" \
  -H "Content-Type: application/json" \
  -d '{"score":1337,"playerName":"Sean Plott","cheatMode":false}' \
  http://<yourhost>:1337/parse/classes/GameScore

curl -X GET \
  -H "X-Parse-Application-Id: <YOUR_APP_ID>" \
  -H "X-Parse-Master-Key: <YOUR_APP_MASTER_KEY>" \
  http://<yourhost>:1337/parse/classes/GameScore
```

You can use https://robomongo.org/ to see your db.

## Deploy with your own mongodb container

```sh
docker run -d -p 27017:27017 --name mongo mongo

docker run -d \
       -v /srv/parse-data:/srv \
       -e APP_ID=<appId> \
       -e MASTER_KEY=<masterKey> \
       -p 1337:1337 \
       -p 2222:22 \
       --link mongo \
       --name parse arnaudvalensi/docker-parse-server-git-deploy:latest
```

* api: localhost:1337
* ssh: localhost: 2222
* mongodb: localhost:27017

## More configuration with docker

* Specify application ID: `-e APP_ID`
* Specify master key: `-e MASTER_KEY=`
* Specify database uri: `-e DATABASE_URI=mongodb://mongodb.intra:27017/dev`
* Specify parse-server port on host: `-p 1338:1337`
* Specify database port on host: `-p 27018:27017`
* Specify parse cloud code volume container: `--volumes-from parse-cloud-code`
* Specify parse-server prefix: `-e PARSE_MOUNT=/parse`

## To build the container frm the `Dockerfile`

```
docker build -t parse-server .
```
