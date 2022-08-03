build:
	sbcl --load spikot\-dns\.asd \
         --eval '(ql:quickload :spikot-dns)' \
         --eval '(use-package :spikot-dns)' \ # not mandatory
         --eval "(sb-ext:save-lisp-and-die #p\"spikot-dns\" :toplevel #'main :executable t)"
