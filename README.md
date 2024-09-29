# swayvnc-chrome

swayvnc-chrome uses [Sway](https://swaywm.org) with [wayvnc](https://github.com/any1/wayvnc) to create a headless wayland desktop with a browser payload (Chrome), to display one or several web pages.

## Usage

Run with docker-compose:

```
docker-compose up
```

### Authentication

By default, the built-in VNC server has authentication enabled and the username/password both set to `wayvnc`. To disable authentication or change the credentials, edit the `docker-compose.yml` file:

```yaml
services:
  swayvnc-chrome:
    ...
    environment:
      - WAYVNC_ENABLE_AUTH=true  # enable/disable auth
      - WAYVNC_USERNAME=wayvnc  # set username here
      - WAYVNC_PASSWORD=wayvnc  # set password here
```

## Connect

Use a vnc client to connect to the server. [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) is recommended for windows, or:

```
$ wlvncc <vnc-server>
# or
$ vinagre [vnc-server:5910]
```
