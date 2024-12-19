class dst_mon extends uvm_monitor;
	`uvm_component_utils(dst_mon)

     	virtual dst_if.DST_MON vif;

       	dst_config dst_cfg;

  	uvm_analysis_port #(dst_xtn) monitor_port;

	function new(string name = "dst_mon", uvm_component parent);
		super.new(name,parent);
 		monitor_port = new("monitor_port", this);		
	endfunction

	function void build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(dst_config)::get(this,"","dst_config",dst_cfg))
		`uvm_fatal("DST_MON","get failed") 
        endfunction

 	function void connect_phase(uvm_phase phase);
          vif = dst_cfg.vif;
        endfunction

	task run_phase(uvm_phase phase);
        	forever
          	     collect_data();     
        endtask

        task collect_data();
		dst_xtn xtn;
		xtn=dst_xtn::type_id::create("xtn");

		while(!vif.mon_cb.read_enb)
			@(vif.mon_cb);
	
		@(vif.mon_cb);
		xtn.header= vif.mon_cb.data_out;
		xtn.payload=new[xtn.header[7:2]];

	 	@(vif.mon_cb);
		foreach(xtn.payload[i])
		   begin
			xtn.payload[i]=vif.mon_cb.data_out;
			@(vif.mon_cb);
		   end

		xtn.parity= vif.mon_cb.data_out;
		@(vif.mon_cb);

         	`uvm_info("DST_MON",$sformatf("printing from dst monitor \n %s", xtn.sprint()),UVM_LOW) 
		
  	  	monitor_port.write(xtn);

  	  	dst_cfg.mon_rcvd_data_cnt++;
	
	endtask

	//function void report_phase(uvm_phase phase);
    	//	`uvm_info(get_type_name(), $sformatf("Report: dst Monitor Collected %0d Transactions", dst_cfg.mon_rcvd_data_cnt), UVM_LOW)
 	 //endfunction 		

endclass

