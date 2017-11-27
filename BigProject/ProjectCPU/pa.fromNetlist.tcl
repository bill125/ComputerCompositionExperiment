
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ProjectCPU -dir "D:/ComputerCompositionExperiment/BigProject/ProjectCPU/planAhead_run_1" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/ComputerCompositionExperiment/BigProject/ProjectCPU/CPUOverall.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/ComputerCompositionExperiment/BigProject/ProjectCPU} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "CPUOverall.ucf" [current_fileset -constrset]
add_files [list {CPUOverall.ucf}] -fileset [get_property constrset [current_run]]
link_design
