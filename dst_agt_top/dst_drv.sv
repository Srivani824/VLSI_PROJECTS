class dst_drv extends uvm_driver#(dst_xtn);
	`uvm_component_utils(dst_drv)

     	virtual dst_if.DST_DRV vif;

       	dst_config dst_cfg;

  	function new(string name = "dst_drv", uvm_component parent);
		super.new(name,parent);	
	endfunction

	function void build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal("DST_DRV","get failed") 
        endfunction

 	function void connect_phase(uvm_phase phase);
          vif = dst_cfg.vif;
        endfunction

	task run_phase(uvm_phase phase);
               	forever
		   begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		   end
	endtask

	task send_to_dut(dst_xtn req);
          	`uvm_info("DST_DRV",$sformatf("no_of_clk_cycles=%0d",req.cycles),UVM_LOW)
		@(vif.drv_cb);

		while(!vif.drv_cb.vld_out)
			@(vif.drv_cb);
		repeat(req.cycles)
			@(vif.drv_cb);
		vif.drv_cb.read_enb<=1;

		while(vif.drv_cb.vld_out)
			@(vif.drv_cb);

		vif.drv_cb.read_enb<=0;

		dst_cfg.drv_data_sent_cnt++;
	endtask

	
	//function void report_phase(uvm_phase phase);
    	//	`uvm_info(get_type_name(), $sformatf("Report: dst driver sent %0d transactions", dst_cfg.drv_data_sent_cnt), UVM_LOW)
 	 //endfunction

endclass

