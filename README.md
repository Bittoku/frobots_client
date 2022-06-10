# Frobots Client

This is the Scenic client front end enough for you to run the FUBARs arena and develop your own frobots

## To install

```
git@github.com:Bittoku/frobots_client.git
```
You also need to grab the backend if you plan to run your local version of the frobots backend as well.

This instructions assumes you will run locally though eventually you will only be able to connect to the 
shared backend dev server.



1. Create an account on the website 
2. Get the bearer token for API access to your account (See Users->Show)
3. Set the env with your token

```shell
export CLIENT_TOKEN="SFMyNTY.g2gDbQAAAB...."
```
4. Start the backend (if you want to connect locally)
```shell
frobots_backend$ iex -S mix phx.server
```
5. Or just connect to the dev server, you need to give @slopyjalopi your pubkey and run a port forward
6. `ssh -N -L 127.0.0.1:4000:127.0.0.1:4000 player@ec2-13-231-63-178.ap-northeast-1.compute.amazonaws.com`

7. Build a release binary for the Client

```shell
frobots_client$ mix deps.get
frobots_client$ MIX_ENV=prod mix release 
```
Which will build the Frobots client. Instructions will follow on how to run the binary

8. Or just unzip a binary for your system `https://github.com/Bittoku/frobots_client/releases`
9. Start the Client from your build
```shell
_build/dev/rel/frobots_client/bin/frobots_client start
```
or if you unzipped it
```shell
frobots_client-0.1.0/bin/frobots_client start
```
There will be a "Download" button on the GUI, which will read all .lua files in your bots directory, and write them to 
the db.  You 
should be aware 
that this will 
update any frobots in the db with the same name.

frobots are downloaded into your 
`_build/<MIX_ENV>/lib/frobots/priv/[bots|templates]` directory.
or 
`frobots_client-0.1.0/lib/frobots-0.1.0/priv/bots` if you are running from the archive
