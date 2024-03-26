################################################################################
#
# thin-edge
#
################################################################################

THIN_EDGE_VERSION = 1.0.1
THIN_EDGE_SITE = https://github.com/thin-edge/thin-edge.io.git
THIN_EDGE_SITE_METHOD = git
THIN_EDGE_LICENSE = Apache-2.0
THIN_EDGE_LICENSE_FILES = LICENSE.txt

define THIN_EDGE_INSTALL_TARGET_CMDS
    $(INSTALL) -D \
        $(@D)/target/$(RUSTC_TARGET_NAME)/release/tedge \
        $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D \
        $(@D)/configuration/contrib/collectd/collectd.conf \
        $(TARGET_DIR)/etc/tedge/contrib/collectd
endef

THIN_EDGE_DEPENDENCIES += ca-certificates mosquitto libxcrypt sudo 

define THIN_EDGE_INSTALL_INIT_SYSTEMD
    $(foreach service, $(wildcard $(@D)/configuration/init/systemd/*.service), \
        $(INSTALL) -D -m 0644 $(service) $(TARGET_DIR)/usr/lib/systemd/system/$(notdir $(service))
    )
endef

define THIN_EDGE_USERS
	tedge -1 tedge -1 * - - - Tedge user
endef

define THIN_EDGE_CREATE_SUDOERS
    mkdir -p $(TARGET_DIR)/etc/sudoers.d ; \
    echo "tedge    ALL = (ALL) NOPASSWD: /usr/bin/tedge, /etc/tedge/sm-plugins/[a-zA-Z0-9]*, /bin/sync, /sbin/init" \
    > $(TARGET_DIR)/etc/sudoers.d/tedge ; \
    echo "tedge    ALL = (ALL) NOPASSWD: /usr/bin/tedge-write /etc/*" \
    >> $(TARGET_DIR)/etc/sudoers.d/tedge
endef

THIN_EDGE_POST_INSTALL_TARGET_HOOKS += THIN_EDGE_CREATE_SUDOERS

define THIN_EDGE_MOSQUITTO_CONF
    if [ -f $(TARGET_DIR)/etc/mosquitto/mosquitto.conf ]; then \
        if ! grep -q "include_dir /etc/tedge/mosquitto-conf" "$(TARGET_DIR)/etc/mosquitto/mosquitto.conf"; then \
            echo "include_dir /etc/tedge/mosquitto-conf" \
            >> $(TARGET_DIR)/etc/mosquitto/mosquitto.conf ; \
        fi ; \
    fi
endef

THIN_EDGE_POST_INSTALL_TARGET_HOOKS += THIN_EDGE_MOSQUITTO_CONF

define THIN_EDGE_CREATE_SYMLINK
    mkdir -p $(TARGET_DIR)/etc/tedge/sm-plugins
	ln -sr $(TARGET_DIR)/usr/bin/tedge-apt-plugin $(TARGET_DIR)/etc/tedge/sm-plugins/apt
endef

THIN_EDGE_POST_INSTALL_TARGET_HOOKS += THIN_EDGE_CREATE_SYMLINK

$(eval $(cargo-package))