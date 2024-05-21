################################################################################
#
# ili9881d
#
################################################################################

ILI9881D_VERSION = 1.0
ILI9881D_SITE = $(NERVES_DEFCONFIG_DIR)/package/ili9881d/src
ILI9881D_SITE_METHOD = local# Other methods like git,wget,scp,file etc. are also available.


$(eval $(kernel-module))
$(eval $(generic-package))
