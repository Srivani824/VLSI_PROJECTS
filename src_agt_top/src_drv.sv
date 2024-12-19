class src_drv extends uvm_driver#(src_xtn);
	`uvm_component_utils(src_drv)

     	virtual src_if.SRC_DRV vif;

       	src_config src_cfg;

  	function new(string name = "src_drv", uvm_component parent);
		super.new(name,parent);	
	endfunction

	function void build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(src_config)::get(this,"","src_config",src_cfg))
		`uvm_fatal("SRC_DRV","get failed") 
        endfunction

 	function void connect_phase(uvm_phase phase);
          vif = src_cfg.vif;
        endfunction
	
	task run_phase(uvm_phase phase);

		vif.drv_cb.resetn<='b0;
		@(vif.drv_cb);
		vif.drv_cb.resetn<='b1;

               	forever
		   begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		   end
	endtask

	task send_to_dut(src_xtn req);
          	`uvm_info("SRC_DRV",$sformatf("printing from source driver \n %s", req.sprint()),UVM_LOW)
		//@(vif.drv_cb);
			
		while(vif.drv_cb.busy!==0)
			@(vif.drv_cb);

		vif.drv_cb.pkt_valid<=1;
		vif.drv_cb.data_in<=req.header;

		@(vif.drv_cb);
		
		foreach(req.payload[i])
		   begin
			while(vif.drv_cb.busy!==0)
				@(vif.drv_cb);
			vif.drv_cb.data_in<=req.payload[i];
			@(vif.drv_cb);
		   end

		vif.drv_cb.pkt_valid<=0;
		vif.drv_cb.data_in<=req.parity;
		repeat(2)
			@(vif.drv_cb);
	
   	      	src_cfg.drv_data_sent_cnt++;
	
			
	endtask

	function void report_phase(uvm_phase phase);
    		`uvm_info(get_type_name(), $sformatf("Report: source driver sent %0d transactions", src_cfg.drv_data_sent_cnt), UVM_LOW)
 	 endfunction

endclass
