!#/home/pbarletta/julia-903644385b/bin/julia
using Chemfiles
using DataFrames

function meta_var(s::AbstractString,v::Any)
         s=symbol(s) 
         @eval (($s) = ($v))
end

function tognm(vtor_anm)
    vtor_gnm = Array{Float64}(convert(Int64, length(vtor_anm)/3));
    vtor_anm =  vtor_anm.^2
    for i=1:convert(Int64, length(vtor_anm)/3)
        vtor_gnm[i] = sqrt(vtor_anm[i*3-2] + vtor_anm[i*3-1] + vtor_anm[i*3])
    end
    return vtor_gnm
end

function pnum(vtor_in::Array{Float64})
    return 1 ./ sum(tognm(vtor_in).^4)
end

function read_ptraj_modes(file, modes_elements, norma::Bool=true)    
    modes_file=open(file, "r")
    modes_text = readdlm(modes_file, skipstart=0, skipblanks=true,
    comments=true, comment_char='\*')
    close(modes_file)

    nmodes = modes_text[1, 5]
    ncoords = convert(Int64, modes_elements)
    lines = ceil(Int64, ncoords/7)
    rest = convert(Int64, ncoords % 7)
    
    eval=Array{Float64}(nmodes);
    mode = Array{Float64}(ncoords, nmodes);
    j = lines + 1 + 2 # 1 p/ q lea la prox linea 2 por el header

    for i=1:nmodes
        eval[i] = modes_text[j, 2]
        tmp = map(x -> if x == "" x = 0 else x end, modes_text[(j+1):(lines+j), :])
        mode[:, i] = reshape(transpose(tmp), size(tmp)[1]*size(tmp)[2])[1:modes_elements]
        j = j + lines + 1
    end
    
    if norma == true
        for i=1:nmodes
            mode[: ,i] = mode[:, i] / norm(mode[:, i])
        end
    end
    
    return mode, eval
end

##########################################

# Get ready
home = "/scratch/pbarletta/pdz/"
neq = "run/lb/neq/";
natoms = 2076;
natoms_pdz = 1944;
natoms_lig = natoms - natoms_pdz;

# NEQ trajectory
frame_cnt = 400;

for paso = 1:180
    in_trj_filename = string(home, neq, "pca/larga/", "step_", paso, "plb_4.nc")
    in_trj = Trajectory(in_trj_filename)
    
    # Average.
    in_avg_filename = string(home, neq, "pca/t0/avg_t0_lb.pdb")

#    in_avg_filename = string(home, neq, "pca/larga/", "avg_step_", paso, "plb_4.pdb")

    in_avg_trj = Trajectory(in_avg_filename)
    in_avg_frm = read(in_avg_trj)
    in_avg_top = Topology(in_avg_frm)
    
    in_avg_frm_xyz = positions(in_avg_frm);
    natoms_system = size(in_avg_frm)
    # Obtengo los índices.
    ca_indices = [ name(Atom(in_avg_top, i)) for i=0:natoms_system-1 ] .== "CA";
    ca_indices_pdz = findn(ca_indices)[1:124]
    ca_indices_cut = findn(ca_indices)[12:112]
    ca_indices_lig = findn(ca_indices)[125:132]
    aa3_cut = length(ca_indices_cut) * 3
    aa36_cut = aa3_cut - 6
    
    # Obtengo las posiciones de los CA del average pdz.
    ca_avg_xyz = in_avg_frm_xyz[:, ca_indices_cut]
    # Obtengo los modos a t0
    t0_modes, t0_evals = read_ptraj_modes(string(home, neq, "pca/larga/", paso, "modes_larga"), aa3_cut);
    
    # Obtengo las posiciones de los CA de la corrida de NEQ y los vectores diferencia respecto
    # a su propio average
    ca_neq_xyz = Array{Array{Float64, 2}}(frame_cnt)
    Vdiff = Array{Array{Float64, 1}}(frame_cnt)
    dot_vdiff_modes = Array{Float64, 2}(aa36_cut, frame_cnt)
    pnum_t0 = Array{Float64, 1}(frame_cnt)
    
    for frame=1:frame_cnt
        # Obtengo las posiciones de este frame
        in_frm = read_step(in_trj, frame-1)
        in_frms_xyz = positions(in_frm)
        ca_neq_xyz[frame] = in_frms_xyz[:, ca_indices_cut]
        # Obtengo el vector diferencia normalizado de los Calpha no_loop del pdz entre el frame y el avg
        tmp = (reshape(ca_neq_xyz[frame] - ca_avg_xyz, 3 * length(ca_indices_cut)))
        Vdiff[frame] = tmp / norm(tmp)
        # Lo proyecto sobre todos los modos
        for i = 1:aa36_cut
            dot_vdiff_modes[i, frame] = dot(t0_modes[:, i], Vdiff[frame])
        end
    end
    # Arregla Nans
    dot_vdiff_modes[isnan.(dot_vdiff_modes)] = 0
    
    # Get Pnumbers
    for frame=1:frame_cnt
        pnum_t0[frame] = pnum(dot_vdiff_modes[:, frame])
    end
    
    # Round pnums to next natural number
    pnum_t0_rounded = convert.(Int64, ceil.(pnum_t0))
    # Sort modes according to projection against Vdiff
    top_modes = mapslices(x -> sortperm(x, rev =true), abs.(dot_vdiff_modes), 1);
    top_modes_indices = map(x -> range(1,x), pnum_t0_rounded);
    
    # Get every mode that appears at least once in the essential subspaces
    pnum_indices_t0_each_frame = Array{Int64, 1}(0)
    for frame = 1:frame_cnt
        pnum_indices_t0_each_frame = [ pnum_indices_t0_each_frame ; top_modes[:, frame][ top_modes_indices[frame] ]  ]
    end
    pnum_indices_t0 = sort(unique(pnum_indices_t0_each_frame));
    
    # Now, instead of sorting modes, sort their projections with Vdiff
    top_modes_pjtions = mapslices(x -> sort(x, rev =true), abs.(dot_vdiff_modes), 1)
    
    # Get projection values for each mode of each subspacec. Later, they 'll be used as weights
    pnum_pjtions_t0_each_frame = zeros(Float64, aa36_cut, frame_cnt)
    for frame = 1:frame_cnt
        tmp = top_modes[top_modes_indices[frame], frame]
        for i = 1:length(tmp)
            pnum_pjtions_t0_each_frame[tmp[i], frame] = dot_vdiff_modes[tmp[i], frame]
        end
    end
    
    # Con los valores de proyección a c/ frame, puedo sacar el peso de c/ modo p/ todo el paso
    weights_t0a = reshape(mapslices(x -> mean(x), pnum_pjtions_t0_each_frame.^2, 2), aa36_cut)
    
    # Ahora obtengo pesos, pero sólamente teniendo en cuenta la frecuencia de aparición en los subespacios
    # esenciales de c/ frame
    not0_each_frame = copy(pnum_pjtions_t0_each_frame)
    not0_each_frame[not0_each_frame .!= 0.] = 1.
    weights_t0b = reshape(mapslices(x -> mean(x), not0_each_frame, 2), aa36_cut);
    
    # Escribo pesos
    df_weights_t0a = DataFrame(Mode = collect(1:aa36_cut), Weights = weights_t0a)
    df_weights_t0b = DataFrame(Mode = collect(1:aa36_cut), Weights = weights_t0b)
    
    writetable(string(home, neq, "2pca/wlarga/", "weights_a_neq_step", paso), df_weights_t0a, separator = '\t')
    writetable(string(home, neq, "2pca/wlarga/", "weights_b_neq_step", paso), df_weights_t0b, separator = '\t')

    println("paso: ", paso)
end
