backupdate := $(shell date +%Y-%m-%d_%H-%M-%S)

all:
	cd ~ && tar czf .emacs.d.$(backupdate).tar.gz .emacs.d/
	rm -rf ~/.emacs.d
	mkdir -p ~/.emacs.d/lisp
	cp init.el -t ~/.emacs.d
	cp *.el -t ~/.emacs.d/lisp
	cp -R use-package/ -t ~/.emacs.d/lisp
	cp -R plugins/ -t ~/.emacs.d/lisp
	emacs --refresh-packages
