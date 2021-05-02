(defpackage spikot-dns
  (:use :cl))

(in-package :spikot-dns)

(ql:quickload "usocket")

;; Quick examples from the common lisp book

(defun create-server (port buffer)
  (let* ((socket (usocket:socket-connect nil nil
                                         :protocol :datagram
                                         :element-type '(unsigned-byte 8)
                                         :local-host "127.0.0.1"
                                         :local-port port)))
    (unwind-protect
         (multiple-value-bind (buffer size client receive-port)
             (usocket:socket-receive socket buffer 8)
           (format t "~A~%" buffer)
           (usocket:socket-send socket (reverse buffer) size
                                :port receive-port
                                :host client))
      (usocket:socket-close socket))))

(defun create-client (port buffer)
  (let ((socket (usocket:socket-connect "127.0.0.1" port
                                        :protocol :datagram
                                        :element-type '(unsigned-byte 8))))
    (unwind-protect
         (progn
           (format t "Sending data~%")
           (replace buffer #(1 2 3 4 5 6 7 8))
           (format t "Receiving data~%")
           (usocket:socket-send socket buffer 8)
           (usocket:socket-receive socket buffer 8)
           (format t "~A~%" buffer))
      (usocket:socket-close socket))))


