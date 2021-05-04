(defsystem "spikot-dns"
  :version "0.1.0"
  :author "icot"
  :license "GPLv3"
  :depends-on ("usocket"
               "usocket-server")
  :components ((:file "package")
               (:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "spikot-dns/tests"))))

(defsystem "spikot-dns/tests"
  :author "icot"
  :license "GPLv3"
  :depends-on ("spikot-dns"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for spikot-dns"
  :perform (test-op (op c) (symbol-call :rove :run c)))
