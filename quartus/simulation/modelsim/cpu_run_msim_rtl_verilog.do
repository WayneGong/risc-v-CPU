transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/machinectl.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/machine.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/irregister.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/datactl.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/cpu.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/counter.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/CLKSOURCE.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/alu.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/adr.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/src {D:/00_GitHub/risc-v-CPU/src/accum.v}

vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/quartus/../sim {D:/00_GitHub/risc-v-CPU/quartus/../sim/addr_decode.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/quartus/../sim {D:/00_GitHub/risc-v-CPU/quartus/../sim/cputop.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/quartus/../sim {D:/00_GitHub/risc-v-CPU/quartus/../sim/ram.v}
vlog -vlog01compat -work work +incdir+D:/00_GitHub/risc-v-CPU/quartus/../sim {D:/00_GitHub/risc-v-CPU/quartus/../sim/rom.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  cputop

add wave *
view structure
view signals
run -all
