## Load traj
#mol new {/home/german/labo/17/pdz/top_files/dry_lb.prmtop} type {parm7} first 0 last -1 step 1 waitfor 0
#animate style Loop
#display resetview
#mol addfile {/home/german/labo/17/pdz/run/lb/neq/avg_corrida/corta/full_fit_corta_neq_lb.nc} type {netcdf} first 0 last -1 step 1 waitfor 0 0
#
#mol modstyle 0 0 NewCartoon
#mol selection not protein

# Color Calphas by Temperature
color scale method BGR
set ke_file [open "/home/german/labo/17/pdz/run/lb/neq/avg_corrida/corta/Tcorta_T_each_aa_vec" r] 
set frame_cnt [molinfo top get numframes] 
set nres 132
mol modcolor 0 top User 
mol colupdate 0 top 1 
mol scaleminmax top 0 300.0 600.0 
#mol scaleminmax top 0 310.0 700.0 
#mol scaleminmax top 0 310.0 500.0 
for {set i 0} {$i<$frame_cnt} {incr i} { 
  animate goto $i 
  puts "Setting User data for frame $i ..." 
  for {set j 0} {$j<($nres)} {incr j} { 
    set ke [gets $ke_file] 
    set atomsel [atomselect top "name CA and resid $j" frame $i] 
     $atomsel set user $ke 
     $atomsel delete 
  } 
}
# Run it
animate speed 0.997
animate goto start 
animate forward 
