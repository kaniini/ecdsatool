dnl
dnl  This is an example configure.ac that demonstrates how to use the buildsys.
dnl  You should not just copy it, but edit it to fit your needs!
dnl
dnl  To generate the configure script, call:
dnl    aclocal -I m4
dnl    autoconf
dnl

dnl Specify name, version and contact e-mail of the package.
AC_INIT([ecdsatool], [0.1], [http://github.com/atheme/ecdsatool])

dnl Specifies where your sources are.
AC_CONFIG_SRCDIR(libecdsaauth)

dnl If your package uses C, you want a C compiler and a C preprocessor
AC_PROG_CC
AC_PROG_CPP
AC_PROG_INSTALL

dnl The buildsys might require ln -s to install libraries.
dnl Uncomment if you are compiling a library.
AC_PROG_LN_S

dnl If you want to build static libraries (for example build part of your
dnl project as a static library and link it to the final program later so you
dnl can easier split your program into multiple directories), you need to
dnl uncomment the following line.
AC_PATH_TOOL(AR, ar)
AC_PATH_TOOL(RANLIB, ranlib)

dnl If you want to build a shared library, you need to call BUILDSYS_SHARED_LIB.
dnl It will automatically set the required LIB_* and PLUGIN_* variables.
dnl See m4/buildsys.m4 for more details.
dnl Uncomment the following line if you want to build a shared library.
dnl BUILDSYS_SHARED_LIB

dnl If your program uses plugins and should run on win32 as well, you need to
dnl uncomment the following line
dnl BUILDSYS_PROG_IMPLIB

AC_CHECK_LIB(ssl, SSL_read, [
	AC_CHECK_HEADERS(openssl/ssl.h openssl/err.h, [
		SSL_LIBS="-lssl -lcrypto"
		AC_SUBST(SSL_LIBS)
		SSL=yes
	],,[-])
], [
	AC_CHECK_LIB(eay32, DH_generate_key, [
		AC_CHECK_HEADERS(openssl/ssl.h openssl/err.h, [
		# Ugh.
		SSL_LIBS="-leay32 /mingw/lib/ssleay32.a"
		AC_SUBST(SSL_LIBS)
		SSL=yes
	],,[-])
], [], [])
], -lcrypto)

if test "$SSL" != "yes"; then
	AC_ERROR([openssl is required])
fi

dnl We need this in order to run some initialization needed by the buildsys
BUILDSYS_INIT
dnl You need to call this to generate the .deps files required by the buildsys.
BUILDSYS_TOUCH_DEPS

dnl If you don't need any extra variables
AC_CONFIG_FILES(buildsys.mk)
dnl If you need any extra variables, they go to extra.mk.
dnl If you use extra variables, comment the line above and uncomment the line
dnl below.
dnl AC_CONFIG_FILES([buildsys.mk extra.mk])

dnl Generate config.h if we did some defines.
AC_CONFIG_HEADERS(config.h)

dnl Write out configure script
AC_OUTPUT
