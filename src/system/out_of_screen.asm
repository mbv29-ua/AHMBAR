



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine deletes the 
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;delete_out_out_of_screen_entities::
;	ld hl, vertical_speed_to_zero_if_grounded_to_entity
;	call man_entity_for_each ;;; Cambiar por man_entity_for_each_out_of_screen
;	ret