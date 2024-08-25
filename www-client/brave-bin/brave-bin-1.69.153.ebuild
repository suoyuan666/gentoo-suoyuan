EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop xdg

DESCRIPTION="Brave is a fast, private and secure web browser that blocks ads, trackers and pop-ups. It also offers built-in AI assistant, VPN, firewall and premium search features."
HOMEPAGE="https://github.com/brave/brave-browser"
SRC_URI="https://github.com/brave/brave-browser/releases/download/v${PV}/brave-browser-${PV}-linux-amd64.zip"

LICENSE="MIT-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keyring"

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-libs/libpthread-stubs
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	x11-libs/libXScrnSaver
	x11-libs/libXrandr
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXinerama
	x11-libs/libxkbcommon
	dev-libs/glib
	dev-libs/nss
	dev-libs/nspr
	net-print/cups
	sys-apps/dbus
	dev-libs/expat
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	dev-libs/gobject-introspection
	dev-libs/atk
	app-accessibility/at-spi2-core
	app-accessibility/at-spi2-atk
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf
	dev-libs/libffi
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/zlib
	dev-libs/fribidi
	media-libs/harfbuzz
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	>=media-libs/libpng-1.6.34
	media-libs/libepoxy
	dev-libs/libbsd
	dev-libs/libunistring
	dev-libs/libtasn1
	dev-libs/nettle
	dev-libs/gmp
	net-dns/libidn2
	media-gfx/graphite2
	app-arch/bzip2
"
BDEPEND=""

S=${WORKDIR}

src_prepare() {
	pushd "${S}/locales" > /dev/null || die
		chromium_remove_language_paks
	popd > /dev/null || die

	default
}

src_install() (
	shopt -s extglob

		declare BRAVE_HOME=/opt/${PN}

		dodir ${BRAVE_HOME%/*}

		insinto ${BRAVE_HOME}
			doins -r *
    # Brave has a bug in 1.27.105 where it needs crashpad_handler chmodded
    # Delete crashpad_handler when https://github.com/brave/brave-browser/issues/16985 is resolved.
			exeinto ${BRAVE_HOME}
				doexe brave chrome_crashpad_handler

		dosym ${BRAVE_HOME}/brave /usr/bin/${PN} || die

	# install-xattr doesnt approve using domenu or doins from FILESDIR
		cp "${FILESDIR}"/${PN}.desktop "${WORKDIR}"
		domenu "${S}"/${PN}.desktop
)

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

