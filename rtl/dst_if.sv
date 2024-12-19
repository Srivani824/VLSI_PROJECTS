///////////////////////////////////////DST_IF
interface dst_if(input clock);

bit vld_out,read_enb;
bit [7:0]data_out;

clocking drv_cb @(posedge clock);
	default input #1 output #1;
	input vld_out;
	output read_enb;
endclocking

clocking mon_cb @(posedge clock);
	default input #1 output #1;
	input vld_out;
	input data_out;
	input read_enb;
endclocking

modport DST_DRV(clocking drv_cb);
modport DST_MON(clocking mon_cb);

endinterface
