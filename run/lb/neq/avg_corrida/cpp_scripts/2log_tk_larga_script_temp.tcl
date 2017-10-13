##############
# Correr así:
# vmd -f ~/labo/17/pdz/top_files/dry_lb.prmtop ../corta/full_fit_larga_neq_lb.nc 
# y luego sourcear este script
##############

color scale method BGR
set ke_file [open "/home/german/labo/17/pdz/run/lb/neq/avg_corrida/larga/log2_Tlarga_T_each_aa_vec" r] 
set frame_cnt [molinfo 0 get numframes] 
set nres 132
mol modcolor 0 0 User 
mol colupdate 0 0 1 
#mol scaleminmax 0 0 310.0 1350.0 
#mol scaleminmax 0 0 310.0 700.0 
mol scaleminmax 0 0 8.5 9.5
for {set i 0} {$i<$frame_cnt} {incr i} { 
  animate goto $i 
  puts "Setting User data for frame $i ..." 
  for {set j 0} {$j<($nres)} {incr j} { 
    set ke [gets $ke_file] 
    set atomsel [atomselect 0 "name CA and resid $j" frame $i] 
     $atomsel set user $ke 
     $atomsel delete 
  } 
}
animate speed 0.96 
animate goto start 
animate forward 
