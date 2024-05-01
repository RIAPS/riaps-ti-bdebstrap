#!/bin/bash

# Set the desired locale
DESIRED_LOCALE="en_US.UTF-8"

# Ensure that the locale is available on the system
# Generate locale if it's not available
if ! grep -q "^$DESIRED_LOCALE" /usr/share/i18n/SUPPORTED; then
    echo "Locale $DESIRED_LOCALE is not supported. Exiting."
    exit 1
fi

# Uncomment the desired locale in /etc/locale.gen
sed -i "/^# $DESIRED_LOCALE /s/^# //" /etc/locale.gen

# Generate the locales
locale-gen

# Set the system-wide locale settings
echo "LANG=$DESIRED_LOCALE" > /etc/default/locale
update-locale LANG=$DESIRED_LOCALE

# Optionally set the LC_ALL to the same locale in /etc/environment (not recommended)
# echo "LC_ALL=$DESIRED_LOCALE" >> /etc/environment

# Inform the user to log out and log back in for changes to take full effect
echo ">>>>>Locale set to $DESIRED_LOCALE."