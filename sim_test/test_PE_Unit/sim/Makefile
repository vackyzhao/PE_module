compile:
		vlogan \
		+v2k \
		-work WORK \
		+incdir+$(incfile) \
		-sverilog \
		+define+SIMULATION_EN -timescale=1ns/1ns \
		-error=noMPD \
		-f file.f

vcs_opts=-full64 \
		-sverilog \
		-timescale=1ns/1ns \
		+v2K \
		-lca \
		-debug_access+all \
		-fsdb
		
elaborate:
		vcs $(vcs_opts) \
		-top work.TESTBENCH \
		-o ./simv 