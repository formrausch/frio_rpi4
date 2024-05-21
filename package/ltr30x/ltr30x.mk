################################################################################
#
# ltr30x
#
################################################################################

LTR30X_VERSION = 1.0
LTR30X_SITE = $(NERVES_DEFCONFIG_DIR)/package/ltr30x/src
LTR30X_SITE_METHOD = local# Other methods like git,wget,scp,file etc. are also available.

$(eval $(kernel-module))
$(eval $(generic-package))
