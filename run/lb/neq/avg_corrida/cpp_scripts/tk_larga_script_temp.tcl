## Load traj
#mol new {/home/german/labo/17/pdz/top_files/dry_lb.prmtop} type {parm7} first 0 last -1 step 1 waitfor 0
#animate style Loop
#display resetview
#mol addfile {/home/german/labo/17/pdz/run/lb/neq/avg_corrida/larga/full_fit_larga_neq_lb.nc} type {netcdf} first 0 last -1 step 1 waitfor 0 0
#
#mol modstyle 0 0 NewCartoon
#mol selection not protein

color scale method BGR
set ke_file [open "/home/german/labo/17/pdz/run/lb/neq/avg_corrida/larga/Tlarga_T_each_aa_vec" r] 
set frame_cnt [molinfo 0 get numframes] 
set nres 132
mol modcolor 0 0 User 
mol colupdate 0 0 1 
#mol scaleminmax 0 0 310.0 1350.0 
#mol scaleminmax 0 0 310.0 700.0 
mol scaleminmax 0 0 310.0 500.0 
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
