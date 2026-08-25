# AirPlay Receiver

Bar widget with a panel for controlling a UxPlay AirPlay receiver in Omarchy.

The receiver runs as a child process of the Omarchy shell. Left-click the bar icon to open the panel. Use the switch to start or stop UxPlay. The panel also selects window or full-screen mode and 30 or 60 FPS. While a Mac is connected, it shows the client's name, model, and device ID.

## Dependencies

The Omarchy plugin installer does not install external packages or run install hooks. Install these requirements before enabling the plugin:

- Omarchy Quattro
- UxPlay available as `uxplay`
- Avahi enabled as `avahi-daemon`
- PipeWire running for audio output
- Mac and Linux on the same local network

Install UxPlay from the AUR with:

```sh
omarchy pkg aur add uxplay
```

The UxPlay package pulls its required Arch dependencies, including `openssl`, `libplist`, `avahi`, `gst-plugins-base`, `gst-plugins-good`, `gst-plugins-bad`, and `gst-libav`. `gstreamer-vaapi` is optional for some GPUs.

Enable Avahi if it is not already running:

```sh
sudo systemctl enable --now avahi-daemon
```

If UFW is enabled, allow AirPlay discovery and the UxPlay ports from the local network. Replace the detected network with the network used by the Mac if necessary:

```sh
LAN_IFACE="$(ip -4 route show default | awk 'NR == 1 { print $5 }')"
LAN_CIDR="$(ip -4 route show dev "$LAN_IFACE" scope link | awk 'NR == 1 { print $1 }')"
sudo ufw allow from "$LAN_CIDR" to any port 5353 proto udp
sudo ufw allow from "$LAN_CIDR" to any port 53317:53319 proto tcp
sudo ufw allow from "$LAN_CIDR" to any port 53317:53319 proto udp
```

## Install

This plugin is not yet published in the Omarchy catalog. To install it directly from GitHub:

```sh
omarchy plugin add https://github.com/Ryannnkl/omarchy-airplay-receiver.git --enable
```

## Usage

Open the panel from the AirPlay icon in the bar. The switch controls whether the receiver is advertised on the local network. When it is enabled, choose the configured receiver from Control Center > Screen Mirroring on the Mac.

The connection section is populated from UxPlay's live connection events. It is hidden when no client is connected. When a Mac is connected, `Disconnect` ends the current session and keeps the receiver available for another connection.

## Configure

The default AirPlay receiver name is `Linux AirPlay`, the default port base is `53317`, full-screen mode is disabled, and the default frame-rate limit is 30 FPS. These values can be changed through the bar entry:

```sh
omarchy bar set io.github.ryannnkl.airplay-receiver name "Linux AirPlay"
omarchy bar set io.github.ryannnkl.airplay-receiver port 53317
omarchy bar set io.github.ryannnkl.airplay-receiver fullscreen true --json
omarchy bar set io.github.ryannnkl.airplay-receiver fps 60 --json
```

Changing display mode or FPS while the receiver is active keeps the current session alive and shows a restart button. Press it when you are ready for the new command-line options to take effect.

On the Mac, open Control Center, choose Screen Mirroring, and select the configured receiver. macOS can mirror the built-in display or use the receiver as an extended display.

## Remove

```sh
omarchy plugin remove io.github.ryannnkl.airplay-receiver
```

Removing the plugin stops its UxPlay child process. It does not remove UxPlay, Avahi, or firewall rules installed separately.

## Security

The plugin does not use root privileges, install packages, or change firewall rules. Review the UxPlay and firewall setup before enabling the receiver on an untrusted network.
