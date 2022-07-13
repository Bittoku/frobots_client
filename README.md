# Frobots Client
The **frobots_client** repository contains the scenic elements that you need to run the FUBARs arena to develop your own Frobots locally.

# Getting Started
## 1. Clone the game client repository
```shell
git clone git@github.com:Bittoku/frobots_client.git
```

## 2. Get a Bearer Token
### Create an Account
In order to get a bearer token, you need to have a Frobots account. Please contact @digitsu on the discord channel 
and ask for a user account on the beta.frobots.io server.

Go to the server, log in and show your profile. 
Website is at `http://beta.frobots.io/`. 

Once you have created an account, you can obtain your Bearer Token by going to **User > Show** from the homepage.
You will see an API TOKEN. Copy this. You will need to set your ENV
with this token in order to connect to the backend game simulator.

# 3. Running the Client
### Using the Binary
1. Download the latest release [here](https://github.com/Bittoku/frobots_client/tags]).
2. Unzip the files and start a new terminal session in that directory.
3. Set your token:
    ```bash
    export CLIENT_TOKEN="<your-bearer-token>"
    ```
4. Run the client:
    ```bash
    bin/frobots_client start
    ```
5. If you have not created a frobot before, you should create a new frobot, create a `bots` dir at the below path, 
and create a .lua file.
   ```bash
   frobots_client<rel>/lib/frobots-<rel>/priv/bots
   ```
6. You can name your lua file whatever you like, that will be the name of your frobot.
7. After writing a frobot, you can upload it to the server with the **Upload** button.
8. Press the **Download** button to get the template Frobots and any previously saved Frobot. These template Frobots will then be located in the `frobots_client-<release-tag>-beta/lib/frobots--<release-tag>/priv` under `bots/` and `templates/`.
9. You can use your downloaded Frobot template Lua code as a base and create your own Frobot in the `priv/bots/` folder and name it anything you want.
10. Upload your Frobot to the server.
11. You should be able to see the Frobot in the dropdown list. If not restart the client.

### Building the binary locally

1. Ensure you have Elixir 1.13 installed and Erlang 24, as there are some incompatibilities with 25.
2. If you need to switch versions, install a version manager like [asdf](https://asdf-vm.com/guide/getting-started.html)
3. Build a release binary for the client using the following command:
   ```bash
   frobots_client$ mix deps.get
   
   frobots_client$ MIX_ENV=prod mix release 
    ```
4. Run the binary
    ```bash
   frobots_client<rel>/bin/frobots_client start
    ```
---
# Troubleshooting
1. You might need to install the libraries for the Scening to work:

   For Ubuntu users:
   ```bash
   apt-get install pkgconf libglfw3 libglfw3-dev libglew2.1 libglew-dev
   ```
   For macOS users:
   ```bash
   brew install glfw3 glew pkg-config
   ```