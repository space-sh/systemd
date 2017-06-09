---
modulename: Systemd
title: /timer/
giturl: gitlab.com/space-sh/systemd
editurl: /edit/master/doc/timer.md
weight: 200
---
# Systemd module: Manage timers

## create

Adds a systemd timer to the file system, which can be any local disk or mounted file system e.g. SD card.


### Example

Create a daily timer for a service called `httpd`:

```sh
space -m systemd /timer/create/ -e timer="httpd" -e description="Daily timer for HTTP server service" -e oncalendar="daily"
```

Create a weekly persistent timer, which takes into account overdue timer events that could not be executed because the system was powered off:
```sh
space -m systemd /timer/create/ -e timer="httpd" -e description="Weekly timer for HTTP server service" -e oncalendar="weekly" -e persistent="true"
```
Exit status code is expected to be 0 on success.


## enable

Enables an existing timer.


### Example

```sh
space -m systemd /timer/enable/ -e timer="httpd"
```

Exit status code is expected to be 0 on success.

## disable

Disables an existing timer..

### Example

```sh
space -m systemd /timer/disable/ -e timer="httpd"
```

Exit status code is expected to be 0 on success.

## list

Lists all enabled timers.

### Example

```sh
space -m systemd /timer/list/
```

Exit status code is expected to be 0 on success.



