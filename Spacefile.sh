#=======================
# SYSTEMD_CREATE_SERVICE
#
# Add a systemd service.
#
# Parameters:
#   $1: root fs path
#   $2: service name
#   $3: description
#   $4: execstart
#   $5: enable
#
# Expects:
#   $SUDO: if not run as root set `SUDO=sudo`
#
# Returns:
#   0: success
#   1: failure
#
#=======================
SYSTEMD_CREATE_SERVICE()
{
    SPACE_SIGNATURE="root service description execstart"
    SPACE_DEP="PRINT"
    SPACE_ENV="SUDO=${SUDO-}"

    local root="${1}"
    shift

    local service="${1}"
    shift

    local description="${1}"
    shift

    local execstart="${1}"
    shift

    case "${root}" in
        */)
            root="${root%/}"
            ;;
    esac

    local servicecontents="
[Unit]
Description=${description}

[Service]
ExecStart=${execstart}

[Install]
WantedBy=multi-user.target
"

    local path="${root}/lib/systemd/system/${service}.service"

    PRINT "Write service file to: ${path}"
    printf "%s\n" "${servicecontents}" | ${SUDO} tee ${path} >/dev/null
    if [ "$?" -gt 0 ]; then
        PRINT "Could not write file, you need to be root/sudo." "error"
        return 1
    fi
    if [ ! -f "${root}${execstart}" ]; then
        PRINT "ExecStart executable does not exist: ${execstart}." "warning"
    fi
}

#=======================
# SYSTEMD_CREATE_TIMER
#
# Add a systemd timer.
#
# Parameters:
#   $1: root fs path
#   $2: timer name
#   $3: description
#   $4: persistent
#   $5: oncalendar
#
# Expects:
#   $SUDO: if not run as root set `SUDO=sudo`
#
# Returns:
#   0: success
#   1: failure
#
#=======================
SYSTEMD_CREATE_TIMER()
{
    SPACE_SIGNATURE="root timer description persistent oncalendar"
    SPACE_DEP="PRINT"
    SPACE_ENV="SUDO=${SUDO-}"

    local root="${1}"
    shift

    local timer="${1}"
    shift

    local description="${1}"
    shift

    local persistent="${1}"
    shift

    local oncalendar="${1}"
    shift

    case "${root}" in
        */)
            root="${root%/}"
            ;;
    esac

    local servicecontents="
[Unit]
Description=${description}

[Timer]
OnCalendar=${oncalendar}
Persistent=${persistent:-false}

[Install]
WantedBy=timers.target
"

    local path="${root}/lib/systemd/system/${timer}.timer"

    PRINT "Write timer file to: ${path}"
    printf "%s\n" "${servicecontents}" | ${SUDO} tee ${path} >/dev/null
    if [ "$?" -gt 0 ]; then
        PRINT "Could not write file, you need to be root/sudo." "error"
        return 1
    fi
}

#=======================
# SYSTEMD_ENABLE
#
# Enable or disable a systemd unit.
#
# Parameters:
#   $1: root fs path
#   $2: unit name
#   $3: enable or disable: 1/0
#   $4: type: service, timer, etc
#   $5: target: default, multi-user, timers, etc
#
# Expects:
#   $SUDO: if not run as root set `SUDO=sudo`
#
# Returns:
#   0: success
#   1: failure
#
#=======================
SYSTEMD_ENABLE()
{
    SPACE_SIGNATURE="root unit enable type target"
    SPACE_DEP="PRINT"
    SPACE_ENV="SUDO=${SUDO-}"

    local root="${1}"
    shift

    local unit="${1}"
    shift

    local enable="${1}"
    shift

    local type="${1}"
    shift

    local target="${1}"
    shift

    case "${root}" in
        */)
            root="${root%/}"
            ;;
    esac

    local path="${root}/lib/systemd/system/${unit}.${type}"

    if [ "${enable}" = "1" ]; then
        PRINT "Enable ${unit}.${type}"
        if [ ! -f "${path}" ]; then
            PRINT "Unit does not exist: ${path}." "error"
            return 1
        fi
        if [ ! -d "${root}/etc/systemd/system/${target}.target.wants" ]; then
            ${SUDO} mkdir "${root}/etc/systemd/system/${target}.target.wants" &&
            ${SUDO} chmod 755 "${root}/etc/systemd/system/${target}.target.wants" ||
            { PRINT "Could not create ${root}/etc/systemd/system/${target}.target.wants." "error"; return 1; }
        fi
        ${SUDO} ln -sf "${path}" "${root}/etc/systemd/system/${target}.target.wants/${unit}.${type}"
    else
        PRINT "Disable unit ${unit}.${type}"
        ${SUDO} rm -f "${root}/etc/systemd/system/${target}.target.wants/${unit}.${type}"
    fi
}

#=======================
# SYSTEMD_LIST_ENABLED
#
# List all enabled systemd units for a specific target.
#
# Parameters:
#   $1: root fs path
#   $2: target: default, multi-user, timers, etc
#
# Expects:
#   $SUDO: if not run as root set `SUDO=sudo`
#
# Returns:
#   0: success
#   1: failure
#
#=======================
SYSTEMD_LIST_ENABLED()
{
    SPACE_SIGNATURE="root target"
    SPACE_DEP="PRINT"
    SPACE_ENV="SUDO=${SUDO-}"

    local root="${1}"
    shift

    local target="${1}"
    shift

    case "${root}" in
        */)
            root="${root%/}"
            ;;
    esac

    ${SUDO} ls "${root}/etc/systemd/system/${target}.target.wants"
}
