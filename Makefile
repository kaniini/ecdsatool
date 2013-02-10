SUBDIRS = libecdsaauth tool

tool: libecdsaauth

include buildsys.mk
