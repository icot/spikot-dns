(defpackage spikot-dns/tests/main
  (:use :cl
        :spikot-dns
        :rove))
(in-package :spikot-dns/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :spikot-dns)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
