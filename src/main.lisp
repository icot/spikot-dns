(defpackage spikot-dns
  (:use :cl))

(in-package :spikot-dns)

(ql:quickload 'usocket)
(ql:quickload 'usocket-server)

;; Quick examples from the common lisp book

(defvar host "127.0.0.1")
(defvar port 1053)

; https://raw.githubusercontent.com/usocket/usocket/master/server.lisp

;; TODO Assert that input is actually an array of bytes
(defun bytes->int (input)
  (reduce #'+ (loop :for i :from (1- (length input)) :downto 0
                    :for byte :across input
                    :collecting (* (expt 256 i) byte))))
;; TODO
(defun parse-buffer (buffer)
  (if (> (length buffer) 11)
    (parse-header (subseq buffer 0 11))
    buffer))

(defmacro get-bit (position value)
  `(ldb (byte 1 ,position) ,value))

(defmacro get-bits (position nbits value)
  `(ldb (byte ,nbits ,position) ,value))

(defun parse-header-flags (flags)
  `(:qr ,(get-bit 15 flags)
    :opcode ,(get-bits 11 4 flags)
    :aa ,(get-bit 10 flags)
    :tc ,(get-bit 9 flags)
    :rd ,(get-bit 8 flags)
    :ra ,(get-bit 7 flags)
    :z ,(get-bit 6 flags)
    :ad ,(get-bit 5 flags)
    :cd ,(get-bit 4 flags)
    :rcode ,(get-bits 0 4 flags)))

(defun parse-header (header)
  (let ((transaction-id (bytes->int (subseq header 0 2)))
        (flags (bytes->int (subseq header 2 4)))
        (qdcount (bytes->int (subseq header 4 6)))
        (ancount (bytes->int (subseq header 6 8)))
        (nscount (bytes->int (subseq header 8 10)))
        (arcount (bytes->int (subseq header 9 11))))
    (progn
      (terpri (format t "ID: ~a" transaction-id))
      (terpri (format t "flags: ~a" (parse-header-flags flags)))
      (terpri (format t "qdcount: ~a" qdcount))
      (terpri (format t "ancount: ~a" ancount))
      (terpri (format t "nscount: ~a" nscount))
      (terpri (format t "arcount: ~a" arcount))
      nil)))

(defun my-udp-handler (buffer)
  (declare (type (simple-array (unsigned-byte 8) *) buffer))
  (progn
    (terpri (format t "[~{~a~^.~}:~a] ~{~a~^ ~}"
                    (loop :for byte :across usocket:*remote-host* :collecting byte)
                    usocket:*remote-port*
                    (loop :for byte :across buffer :collecting (format nil "~2,'0X" byte))))
    (parse-buffer buffer)
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
