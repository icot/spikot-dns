(defpackage spikot-dns
  (:use :cl))

(in-package :spikot-dns)

(ql:quickload 'usocket)
(ql:quickload 'usocket-server)

;; Quick examples from the common lisp book

(defvar host "127.0.0.1")
(defvar port 1053)

; https://raw.githubusercontent.com/usocket/usocket/master/server.lisp

(defun my-udp-handler (buffer)
  (declare (type (simple-array (unsigned-byte 8) *) buffer))
  (progn
    (terpri (format t "[~{~a~^.~}:~a] ~{~a~^ ~}"
                    (loop for byte :across usocket:*remote-host* :collecting byte)
                    usocket:*remote-port*
                    (loop :for byte :across buffer :collecting (format nil "~2,'0X" byte))))
    buffer))

(defun echo-tcp-handler (stream)
  (loop
     (when (listen stream)
       (let ((line (read-line stream nil)))
     (write-line line stream)
     (force-output stream)))))

;; TCP
;(usocket:socket-server host port #'my-tcp-handler)

;; UDP
(defun server ()
  (usocket:socket-server host port #'my-udp-handler nil :protocol :datagram))
