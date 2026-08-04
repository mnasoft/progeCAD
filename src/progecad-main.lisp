;;;; Программа конвертирования проектов MNAS_Acad_Utils под загрузку в progeCAD

(defparameter *prjs-00*
  (directory "z:/develop/MNAS_acad_utils/src/lsp/*/*.prj")
  "FAS - проекты MNAS_Acad_Utils")

(defparameter *prjs-01*
  (directory "z:/develop/MNAS_acad_utils/src/lsp/*/*/*.prj")
  "FAS - проекты MNAS_Acad_Utils")

(defun vlisp-project-list-prj-lsp (prjs)
  (loop :for prj :in prjs
        :collect (let* ((prj-name (namestring prj))
                        (dir      (mnas-path:directory-directory prj))
                        (vlisp-project-list (with-open-file (in prj)
                                              (read in)))
                        (own-list (cadr (member :OWN-LIST vlisp-project-list))))
                   (with-open-file (out
                                    (concatenate
                                     'string
                                     prj-name ".lsp")
                                    :direction :output
                                    :if-exists :supersede
                                    )
                     (loop :for i :in own-list
                           :do
                              (format out "(load ~S)~%"
                                      (concatenate 'string dir i ".lsp"))))
                   (list dir prj-name own-list))))

(defun vlisp-project-list-prj-lsp-relative (prjs root-path)
  (loop :for prj :in prjs
        :collect (let* ((prj-name (namestring prj))
                        (dir      (mnas-path:directory-directory prj))
                        (vlisp-project-list (with-open-file (in prj)
                                              (read in)))
                        (own-list (cadr (member :OWN-LIST vlisp-project-list))))
                   (format t "------------------------------------~%") 
                   (format t "~S~%" prj-name) 
                   (with-open-file (out
                                    (concatenate
                                     'string
                                     prj-name ".lsp")
                                    :direction :output
                                    :if-exists :supersede)
                     (loop :for i :in own-list
                           :do
                              (format t "~S~%" (concatenate 'string dir i ".lsp"))
                              (format out "(load (strcat MNASoft ~S))~%"
                                      (mnas-path:pathname-relative
                                       root-path
                                       (concatenate 'string dir i ".lsp")))))
                   (list dir prj-name own-list))))


(defparameter *prjs* (append *prjs-00* *prjs-01*))

#+nil
(vlisp-project-list-prj-lsp *prjs*)

(vlisp-project-list-prj-lsp-relative *prjs* "z:/develop/MNAS_acad_utils/")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *prjs-lsp-00*
  (directory "z:/develop/MNAS_acad_utils/src/lsp/*/*.prj.lsp")
  "FAS - проекты MNAS_Acad_Utils")

(defparameter *prjs-lsp-01*
  (directory "z:/develop/MNAS_acad_utils/src/lsp/*/*/*.prj.lsp")
  "FAS - проекты MNAS_Acad_Utils")

(defparameter *prjs-lsp*
  (append *prjs-lsp-00* *prjs-lsp-01*))

(length *prjs-lsp*)

(defun mk-progeCAD-prv-lsp (root-path)
  (with-open-file (prv "z:/develop/MNAS_acad_utils/src/lsp/progeCAD.prv.lsp"
                       :direction :output
                       :if-exists :supersede
                       )
    (format prv "(setq MNASost ~S)~%" root-path) 

    (loop :for i :in *prjs-lsp*
          :collect
          (format prv "(load (strcat MNASoft ~S))~%"
                  (mnas-path:pathname-relative root-path i)
                  ))))

(mk-progeCAD-prv-lsp "z:/develop/MNAS_acad_utils/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

