#set -x
__main() {
    # The file doesn't have executable permissions, so this shouldn't really happen.
    # Doing this in case someone tries to chmod +x it and execute...

    # shellcheck disable=SC2128,SC2169,SC2039 # ignore array expansion warning
    if [ -n "${BASH_SOURCE-}" ] && [ "${BASH_SOURCE[0]}" = "${0}" ]
    then
        echo "This script should be sourced, not executed:"
        # shellcheck disable=SC2039  # reachable only with bash
        echo ". ${BASH_SOURCE[0]}"
        return 1
    fi

    export COMPORT=ttyUSB0
    export ESPPORT=/dev/$COMPORT
    . env/bin/activate
#    export TARGET_BUILD_NAME=ESPC3-16MFlash
    export TARGET_BUILD_NAME=ESP32-1732S019

    echo "TARGET BUILD: ${TARGET_BUILD_NAME}"
    default_sdkconfig=build-scripts/${TARGET_BUILD_NAME}-sdkconfig.defaults
    grep 'CONFIG_IDF_TARGET="esp32s3' ${default_sdkconfig} > /dev/null
    config_is_s3=$?
    grep 'CONFIG_IDF_TARGET="esp32s3' sdkconfig > /dev/null
    current_is_s3=$?

    if [ ${config_is_s3} -ne ${current_is_s3} ]; then
        echo "Warning: Configured processor has changed"
    fi

    if [ ${config_is_s3} -eq 0 ]; then
    # esp32s3 build requires IDF 4.4.x
        echo "Using IDF version 4.4.7"
        . ~/esp/esp-idf.4.4.7/export.sh > /dev/null
    else
        echo "Using IDF version 4.3.5"
        . ~/esp/esp-idf.4.3.5/export.sh /dev/null
    fi
    export PYTHONPATH=$IDF_PATH/tools/ci/python_packages
}

__main $*

