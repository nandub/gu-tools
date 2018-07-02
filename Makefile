PACKAGE=gu-tools
VER=0.0.2

PREFIX=/usr/local

BINPROGS = \
	gprune \
	gucl \
	gucr \
	gume \

V_GEN = $(_v_GEN_$(V))
_v_GEN_ = $(_v_GEN_0)
_v_GEN_0 = @echo "  GEN     " $@;

edit = $(V_GEN) m4 -P $@.in | sed 's/@VERSION@/$(VER)/g' >$@ && chmod go-w,+x $@

all: $(BINPROGS)

%: %.in gu_tools.inc.sh
	$(edit)
	@bash -O extglob -n $@

install-bin: $(BINPROGS)
	install -dm755 $(DESTDIR)$(PREFIX)/bin
	install -m755 $(BINPROGS) $(DESTDIR)$(PREFIX)/bin

install: install-bin

clean:
	$(RM) $(BINPROGS)

dist:
	git archive --format=tar --prefix=$(PACKAGE)-$(VER)/ $(VER) | gzip -9 >$(PACKAGE)-$(VER).tar.gz

.PHONY: clean
