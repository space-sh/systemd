# Manage systemd via file system | [![build status](https://gitlab.com/space-sh/systemd/badges/master/build.svg)](https://gitlab.com/space-sh/systemd/commits/master)

Manage systemd services, timers, etc directly via filesystem,
this makes it so that we can manage systemd on an offline OS
which disk/sd card we have mounted.



## /service/
	

+ create
+ disable
+ enable
+ list

## /timer/
	

+ create
+ disable
+ enable
+ list

# Functions 

## SYSTEMD\_CREATE\_SERVICE()  
  
  
  
Add a systemd service.  
  
### Parameters:  
- $1: root fs path  
- $2: service name  
- $3: description  
- $4: execstart  
- $5: enable  
  
### Returns:  
- 0: success  
- 1: failure  
  
  
  
## SYSTEMD\_CREATE\_TIMER()  
  
  
  
Add a systemd timer.  
  
### Parameters:  
- $1: root fs path  
- $2: timer name  
- $3: description  
- $4: persistent  
- $5: oncalendar  
  
### Returns:  
- 0: success  
- 1: failure  
  
  
  
## SYSTEMD\_ENABLE()  
  
  
  
Enable or disable a systemd unit.  
  
### Parameters:  
- $1: root fs path  
- $2: unit name  
- $3: enable or disable: 1/0  
- $4: type: service, timer, etc  
- $5: target: default, multi-user, timers, etc  
  
### Returns:  
- 0: success  
- 1: failure  
  
  
  
## SYSTEMD\_LIST\_ENABLED()  
  
  
  
List all enabled systemd units for a specific target.  
  
### Parameters:  
- $1: root fs path  
- $2: target: default, multi-user, timers, etc  
  
### Returns:  
- 0: success  
- 1: failure  
  
  
  
