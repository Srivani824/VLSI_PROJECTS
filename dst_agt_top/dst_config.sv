class dst_config extends uvm_object;
	`uvm_object_utils(dst_config)
	virtual dst_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	static int drv_data_sent_cnt=0;
	static int mon_rcvd_data_cnt=0;	

function new(string name = "dst_config");
  super.new(name);
endfunction

endclass

