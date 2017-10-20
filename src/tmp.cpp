
// Get ready
std::string home = "/home/german/labo/17/pdz/";
std::string neq = "run/lb/neq/";
auto natoms = 2076;
auto natoms_pdz = 1944;
auto natoms_lig = natoms - natoms_pdz;

// NEQ trajectory
const static int frame_cnt = 400;
auto in_trj_filename = home + neq + "starting_frames/" + "starting_frames.nc";
chemfiles::Trajectory in_trj(in_trj_filename);
std::vector<chemfiles::Frame> in_frms(frame_cnt);
std::vector<chemfiles::span<chemfiles::Vector3D>> in_frms_xyz(frame_cnt);

// Average
auto in_avg_filename = home + neq + "pca/t0/" + "avg_t0_lb.pdb";
chemfiles::Trajectory in_avg_trj(in_avg_filename);
auto in_avg_frm = in_avg_trj.read();
chemfiles::span<chemfiles::Vector3D> in_avg_frm_xyz = in_avg_frm.positions();

std::vector<std::vector<double>> in_xyz(frame_cnt);
auto cnt = 0;


