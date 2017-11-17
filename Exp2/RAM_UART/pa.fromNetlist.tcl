
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name RAM_UART -dir "E:/Exp2/RAM_UART/planAhead_run_5" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/Exp2/RAM_UART/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/Exp2/RAM_UART} }
set_property target_constrs_file "main.ucf" [current_fileset -constrset]
add_files [list {main.ucf}] -fileset [get_property constrset [current_run]]
link_design
