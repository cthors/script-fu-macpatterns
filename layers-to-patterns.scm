
; note: to use in the script-fu console (can display print statements for debugging?):
; for no scaling:
; (script-fu-layers-to-patterns RUN-NONINTERACTIVE (vector-ref (cadr (gimp-image-list)) 0) 0)
; for 8x scaling:
; (script-fu-layers-to-patterns RUN-NONINTERACTIVE (vector-ref (cadr (gimp-image-list)) 0) 1)

; todo: create better feedback / UI. Ex: can add interpolation options with SF-ENUM

(define (rid-spaces myName)
  (define (fixup charList)
    (cond
        ((null? charList) '()) ; note: can't use square brackets in R5RS
        ((char=? (car charList) #\space) (cons #\_ (fixup (cdr charList))))
        (else (cons (car charList) (fixup (cdr charList))))
    )
  )
  (list->string (fixup (string->list myName)))
)

(define (layers-to-pat layersList requestedScale)
  (cond
    ((null? layersList) (gimp-message "done"))
    (else
      (let*
        (
        (layerId (car layersList))                    ; get a reference to the first layer in the list
        (layerName (car(gimp-item-get-name layerId))) ; get the layer name
        (fileName (rid-spaces layerName))             ; make the filename & then the file path out of the layer name:
        (filePath (string-append "C:/Users/bonbon/AppData/Roaming/GIMP/2.10/patterns/" fileName ".pat"))
        )
        (gimp-edit-copy layerId) ; copy the layer to the clipboard
        (let*
          (
          (layerImg (car (gimp-edit-paste-as-new-image))) ; create a new image object from what's on the clipboard
          (layerDrawable (car (gimp-image-get-active-drawable layerImg))) ;create a new drawable object from the image
          )
          (cond ((not (equal? 0 requestedScale)) ; scale the image if requested
              (let*
                (
                (lookup '#(1 4 8)) ; translate from the 0 1 2... return vals of the dropdown, to whatever values are actually offered
                (scaleFactor (vector-ref lookup requestedScale))
                )  
                (gimp-image-scale layerImg (* scaleFactor (car (gimp-image-width layerImg))) (* scaleFactor (car (gimp-image-height layerImg))))
              )
            ) 
          )
          (file-pat-save  RUN-NONINTERACTIVE layerImg layerDrawable filePath filePath fileName) ; create the new .pat file
          (gimp-image-delete layerImg) ; do need to do this (can comment it out and run test-sphere.scm to see)
        ) 
      )
      (layers-to-pat (cdr layersList) requestedScale) ; recurse on the rest of the list
    )
  )
)

(define (script-fu-layers-to-patterns autoImage inScale)
  (gimp-context-set-interpolation INTERPOLATION-NONE)
  (layers-to-pat (vector->list (cadr (gimp-image-get-layers autoImage))) inScale)
  (gimp-patterns-refresh)
  (print "done done?")
)

(script-fu-register
          "script-fu-layers-to-patterns"              ;function name
          "Layers to Patterns"                        ;menu label
          "Export every layer as a pattern file"      ;description
          "Casey Thorsen"                             ;author
          "Casey Thorsen"                             ;copyright notice
          "November 24 2023"                          ;date created
          ""                                          ;image type that the script works on
          SF-IMAGE        "Image"           0
          SF-OPTION       "Scale Factor"    '("1" "4" "8")
)
(script-fu-menu-register "script-fu-layers-to-patterns" "<Image>/Filters")