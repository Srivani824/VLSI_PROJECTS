///////////////////////////////////////SRC_IF
interface src_if(input clock);

bit resetn,pkt_valid,busy,err;
bit [7:0]data_in;

clocking drv_cb @(posedge clock);
	default input #1 output #1;
	output resetn;
	output data_in;
	output pkt_valid;
	input busy;
endclocking

clocking mon_cb @(posedge clock);
	default input #1 output #1;
	input resetn;
	input data_in;
	input pkt_valid;
	input busy;
	input err;
endclocking

modport SRC_DRV(clocking drv_cb);
modport SRC_MON(clocking mon_cb);

endinterface


