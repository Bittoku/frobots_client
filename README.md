# Frobots Client

This is the Scenic client front end enough for you to run the FUBARs arena and develop your own frobots

## To install

```
git@github.com:Bittoku/frobots_client.git
```
You also need to grab the backend if you plan to run your local version of the frobots backend as well.

This instructions assumes you will run locally though eventually you will only be able to connect to the 
shared backend dev server.



1. Create an account on your backend 
2. Get the bearer token for API access to your account
3. Set the env with your token

```shell
export CLIENT_TOKEN="SFMyNTY.g2gDbQAAAB...."
```
4. Start the backend
```shell
frobots_backend$ iex -S mix phx.server
```

5. Built a release binary for the Client

```shell
frobots_client$ MIX_ENV=prod mix release 
```
Which will build the Frobots client. Instructions will follow on how to run the binary

6. Start the Client
```shell
_build/dev/rel/frobots/bin/frobots start
```
There will be a "Download" button on the GUI, which will read all .lua files in your bots directory, and write them to 
the db.  You 
should be aware 
that this will 
update any frobots in the db with the same name.

frobots are downloaded into your 
`_build/<MIX_ENV>/lib/frobots/priv/[bots|templates]` directory.
