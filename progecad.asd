(defsystem "progecad"
  :version "0.1.0"
  :description "Минимальная ASDF-система для проекта progeCAD"
  :author "mnas"
  :license "MIT"
  :depends-on ("mnas-path")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "core" :depends-on ("package"))))))
