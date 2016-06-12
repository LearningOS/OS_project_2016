.section .data
.align 4 # which either means 4 or 2**4 depending on arch!

.global _binary_obj_user_odc_start
.type _binary_obj_user_odc_start, @object
_binary_obj_user_odc_start:
.incbin "obj/user/odc"

.align 4
.global _binary_obj_user_odc_end
_binary_obj_user_odc_end:

