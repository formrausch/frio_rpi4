# Zhangqun Ming <north_sea@qq.com>
# Copyright (c) 2021 Seeed Studio
#
# MIT License
#
KVERSION ?= $(shell uname -r)

obj-m = ili9881d.o

ili9881d: all

all:
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) modules

install:
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=$(shell pwd) modules_install

clean:
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) clean
