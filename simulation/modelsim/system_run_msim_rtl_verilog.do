transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/My\ Drive/SHA-1\ Final\ Project/clean_up/verilog {G:/My Drive/SHA-1 Final Project/clean_up/verilog/controller.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/SHA-1\ Final\ Project/clean_up/verilog {G:/My Drive/SHA-1 Final Project/clean_up/verilog/datapath.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/SHA-1\ Final\ Project/clean_up/verilog {G:/My Drive/SHA-1 Final Project/clean_up/verilog/system.v}
vlog -vlog01compat -work work +incdir+G:/My\ Drive/SHA-1\ Final\ Project/clean_up/verilog {G:/My Drive/SHA-1 Final Project/clean_up/verilog/ram.v}

