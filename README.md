# Frobots Client
The **frobots_client** repository contains the scenic elements that you need to run the FUBARs arena to develop your own Frobots locally.

# Getting Started
## 1. Clone the repository
```shell
git clone git@github.com:Bittoku/frobots_client.git
```

## 2. Get a Bearer Token
### Create an Account
In order to get a bearer token, you need to have a Frobots account. Please contact @slopyjalopi in our Discord's #beta-group channel and give him your public SSH key.

Once your SSH keys are set up, you have to port forward to the Frobots server using the following command. (Replace the username with the account username that will be provided to you):
```bash
ssh -N -L 127.0.0.1:4000:127.0.0.1:4000 [username]@ec2-13-231-63-178.ap-northeast-1.compute.amazonaws.com

# Note: You have to keep this process running the background to proceed with the following steps.
```

After port forwarding, you can now access the development website through `http://localhost:4000/`. This will load the Frobots website on your local machine and where you can create an account.

Once you have created an account, you can obtain your Bearer Token by going to **User > Show** from the homepage.

# 3. Running the Server
### Running it Locally
1. Clone the backend repository [here](https://github.com/Bittoku/frobots_backend).
2. Start the backend server:
   ```bash
   frobots_backend$ iex -S mix phx.server
   ```

### Connecting to the dev server
1. Port forward to the dev server:
   ```bash
    ssh -N -L 127.0.0.1:4000:127.0.0.1:4000 [username]@ec2-13-231-63-178.ap-northeast-1.compute.amazonaws.com
    
    # Note: You have to keep this process running the background to proceed with the following steps.
    ```

# 4. Running the Client
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
5. Press the **Download** button to get the template Frobots and any previously saved Frobot. These template Frobots will then be located in the `frobots_client-<release-tag>-beta/lib/frobots--<release-tag>/priv` under `bots/` and `templates/`.
6. You can use your downloaded Frobot template Lua code as a base and create your own Frobot in the `priv/bots/` folder and name it anything you want.
7. Upload your Frobot to the server.
8. Restart the client to see your newly added Frobot and select it to start playing.

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
   _build/dev/rel/frobots_client/bin/frobots_client start
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