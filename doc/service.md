---
modulename: Systemd
title: /service/
giturl: gitlab.com/space-sh/systemd
editurl: /edit/master/doc/service.md
weight: 200
---
# Systemd module: Manage services

## create

Adds a systemd service to the file system, which can be any local disk or mounted file system e.g. SD card.


### Example

```sh
space -m systemd /service/create/ -e service="httpd" -e description="Personal HTTP server" -e execstart="/home/space/bin/httpd"
```

Exit status code is expected to be 0 on success.


## enable

Enables an existing service.


### Example

```sh
space -m systemd /service/enable/ -e service="httpd"
```

Exit status code is expected to be 0 on success.

## disable

Disables a given service.

### Example

```sh
space -m systemd /service/disable/ -e service="httpd"
```

Exit status code is expected to be 0 on success.

## list

Lists all available services.

### Example

```sh
space -m systemd /service/list/
```

Exit status code is expected to be 0 on success.



