#############################################################
#
# reterminal-dm
#
#############################################################

# Remember to bump the version when anything changes in this
# directory.
RETERMINAL_DM_SOURCE =
RETERMINAL_DM_VERSION = 0.0.1
RETERMINAL_DM_DEPENDENCIES += host-dtc

define RETERMINAL_DM_BUILD_CMDS
	cp $(NERVES_DEFCONFIG_DIR)/package/reterminal-dm/*.dts* $(@D)
        for filename in $(@D)/*.dts; do \
            $(CPP) -I$(@D) -I $(LINUX_SRCDIR)include -I $(LINUX_SRCDIR)arch -nostdinc -undef -D__DTS__ -x assembler-with-cpp $$filename | \
              $(HOST_DIR)/usr/bin/dtc -Wno-unit_address_vs_reg -@ -I dts -O dtb -b 0 -o $${filename%.dts}.dtbo || exit 1; \
        done
endef

define RETERMINAL_DM_INSTALL_TARGET_CMDS
	echo "$(@D)/*.dtbo -> $(BINARIES_DIR)/rpi-firmware/overlays/"
	$(INSTALL) -D -m 0644 $(@D)/*.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/

endef

$(eval $(generic-package))
