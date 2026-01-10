PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share/hyprmenu

install:
	install -Dm755 bin/fzm $(DESTDIR)$(BINDIR)/fzm
	install -Dm644 share/hyprmenu/config.json.default $(DESTDIR)$(SHAREDIR)/config.json
	install -d $(DESTDIR)$(SHAREDIR)/options
	install -Dm755 share/fzm/options/*.sh $(DESTDIR)$(SHAREDIR)/options/

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/fzm
	rm -rf $(DESTDIR)$(SHAREDIR)
