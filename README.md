# My Box IP (Client)

Service to report the IP address of digital signage clients (Linux TV boxes) to the server.

## Installation

Install with:

```
chmod +x install.sh
SERVER_ADDR=127.0.0.1:8008 ./install.sh
```

Note: Change SERVER_ADDR to the address and port of your server!

## Compilation

Install the required tools:

```
sudo apt install build-essential pkg-config libssl-dev curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Compile with:

```
chmod +x build.sh
./build.sh
```
