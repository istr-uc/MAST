
# reference -> test
analysis_map = {
                "classic_rm" : "classic_rm",
                "varying_priorities" : "varying_priorities",
                "holistic" : "holistic",
                "holistic_local_edf" : "holistic -l",
                "holistic_global_edf" : "holistic",
                "offset_based_optimized" : "offset_based_approx_w_pr",
                "offset_based" : "offset_based_approx",
                "edf_monoprocessor" : "edf_monoprocessor",
                "edf_within_priorities" : "edf_within_priorities"
                }

assignment_map = {
                "" : "",
                "-p -t hopa" : "-p -t hospa",
                "-p -t hosda_local" : "-l -p -t hospa",
                "-p -t hosda_global" : "-p -t hospa",
                "-p -t pd_local" : "-l -p -t pd",
                "-p -t pd_global" : "-p -t pd",
                "-p -t npd_local" : "-l -p -t npd",
                "-p -t npd_global" : "-p -t npd"
#                "annealing" : "annealing"
                }

filename_map = {"parse" : "parse",
                "classic_rm" : "rm",
                "varying_priorities" : "vp",
                "holistic" : "ho",
                "holistic_local_edf" : "ho_l",
                "holistic_global_edf" : "ho",
                "offset_based_optimized" : "off_opt",
                "offset_based" : "off",
                "edf_monoprocessor" : "edf",
                "edf_within_priorities" : "edf_p",
		        "" : "",
		        "-p -t hopa" : "hopa",
		        "-p -t hosda_local" : "hospa_l",
                "-p -t hosda_global" : "hospa",
                "-p -t pd_local" : "pd_l",
                "-p -t pd_global" : "pd",
                "-p -t npd_local" : "npd_l",
                "-p -t npd_global" : "npd"}
#                "annealing" : "annealing"}

