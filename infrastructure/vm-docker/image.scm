(add-to-load-path (string-append (dirname (current-filename)) "/"))

(use-modules (system)
             (gnu)
             (gnu image)
             (gnu system image))
(image
  (format 'disk-image)
  (operating-system %system)
  (partitions (image-partitions mbr-hybrid-disk-image))
  (compression #f)
  ;(volatile-root #false)
  ; todo shared store with 9p mount! woohoo!
  )
