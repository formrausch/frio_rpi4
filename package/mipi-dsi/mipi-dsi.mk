################################################################################
#
# mipi-dsi 
#
################################################################################

MIPI_DSI_VERSION = 1.0
MIPI_DSI_SITE = $(NERVES_DEFCONFIG_DIR)/package/mipi-dsi/src
MIPI_DSI_SITE_METHOD = local# Other methods like git,wget,scp,file etc. are also available.

$(eval $(kernel-module))
$(eval $(generic-package))
