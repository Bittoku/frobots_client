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
5. Setup the bots local directory or load up any frobots you already created from the db
```shell
frobots_client$ cd apps/frobots
frobots_client/apps/frobots$ iex -S mix
```
Then you have to manuall call this function
```shell
iex(1)> Frobots.load_player_frobots()
```
which will create the priv/bots directory and write all your frobots into that directory.
You can then exit this iex session and run the FUBARs client.
```shell
iex(2)> CTRL-C CTRL-C
frobots_client/apps/frobots$ cd ../..
frobots_client$ iex -S mix
```
Which will run the Frobots_Scenic client.

When you are done editing your frobots and want to save them back to the db, in an iex session run this command
```shell
iex(1)> Frobots.save_player_frobots()
```
Which will read all .lua files in your bots directory, and write them to the db.  You should be aware that this will 
update any frobots in the db with the same name.
