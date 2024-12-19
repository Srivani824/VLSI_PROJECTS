////////////////////////////////////ENV_CFG
class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	bit has_scoreboard = 1;
	bit has_srcagt=1;
	bit has_dstagt=1;
	bit has_virtual_sequencer = 1;
	src_config src_cfg;
	dst_config dst_cfg[];

	int no_of_srcagent=1;
	int no_of_dstagent=3;

function new(string name = "env_config");
  super.new(name);
endfunction

endclass

