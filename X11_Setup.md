# Setting up X11 on HEP Cluster PC

## Requirements
- X11 server software (Exceed on UCL computers, there are other options if downloading on personal laptop)
- PuTTY

## Steps
1) Start X11 server (e.g. open Exceed), should start minimised with no windows.
2) Open PuTTY and save configuration connecting to HEP cluster:
  - Hostname: USERNAME@plus1.hep.ucl.ac.uk (or plus2) 
  - Port: 22
  - Options (left side) > Connection > SSH > Tunnels > Add new forwarded port
    - Source port: 8888 (or any high 4 digit number should work)
    - Destination: 128.40.4.178:22 (the IP address to the left of the colon is of pc195, can be set to another PC by connecting to the PC manually and typing `hostname -i` to check its IP)
3) Save configuration with an indicative name
4) Open this connection with above settings and log in
5) Open another instance of PuTTY and save the following configuration:
  - Hostname: USERNAME@127.0.0.1 (localhost IP address)
  - Port: 8888 (or whatever was specified above)
  - Options > Connection > SSH > X11 > Enable X11 Forwarding
6) Save this configuration with a different name, then connect.
7) After logging in, this connection will tunnel through the first connection to the specified PC, and X11 forwarding will be enabled.
8) To test, type `firefox` or `xclock` into terminal.
