# Frobots Client
The **frobots_client** repository contains the scenic elements that you need to run the FUBARs arena to develop your own Frobots locally.

# Getting Started

## 1. Login to Beta Server
Website is at `http://beta.frobots.io/`. 

But you need to login with the invite link you recieved in your email. First time you login, you will be asked to change your password.

## 2. Running the Client

### Dependencies
The client uses the Scenic library for Elixir, which is a thin gui library for IoT interfaces, but works well for our purposes. 

Install OpenGL dependencies
https://hexdocs.pm/scenic/install_dependencies.html#content

### Running the pre-built binary
1. Download the latest release [here](https://github.com/Bittoku/frobots_client/tags]).
2. Unzip the files and start a new terminal session in that directory.
3. Run the client:
    ```bash
    bin/frobots_client start
    ```
    or
    ```bash
    ./frobots_client
    ```
    if you downloaded the prebuilt binary

4. Login by entering your username and password on the client landing page. You only need to do this once.
5. If you have not created a frobot before, you should create a new frobot, create a `bots` dir in your $HOME dir, 
and create a .lua file. The name of the file will be your FROBOT name
   ```bash
   $HOME/bots
   ```
6. You can use any editor to create and edit the .lua file, you may find it easiest to keep it open. Save it.
7. Upload your FROBOT to the beta server with the **Upload** button. The client looks for all `*.lua` files in your `$HOME/bots` dir.
8. If you previously updoaded FROBOTS but have deleted the local copies of their brain files, you can press the **Download** button to get saved Frobots. These FROBOTs will overwrite any in your `/bots` directory.
9. Once uploaded, you should be able to see you FROBOT in the dropdown list, to choose to battle.
10. Click FIGHT to start the match.

## 4. OPTIONAL Building locally

1. Clone the game client repository

```shell
git clone git@github.com:Bittoku/frobots_client.git
```

2. Ensure you have Elixir 1.13 installed and Erlang 24, as there are some incompatibilities with 25.
3. If you need to switch versions, install a version manager like [asdf](https://asdf-vm.com/guide/getting-started.html)
4. Build a release binary for the client using the following command:

   ```bash
   frobots_client$ mix deps.get
   
   frobots_client$ MIX_ENV=prod mix release 
    ```
5. Run the binary

    ```bash
   frobots_client<rel>/bin/frobots_client start
    ```