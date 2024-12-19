class src_mon extends uvm_monitor;
	`uvm_component_utils(src_mon)

     	virtual src_if.SRC_MON vif;

       	src_config src_cfg;

  	uvm_analysis_port #(src_xtn) monitor_port;

	function new(string name = "src_mon", uvm_component parent);
		super.new(name,parent);
 		monitor_port = new("monitor_port", this);		
	endfunction

	function void build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(src_config)::get(this,"","src_config",src_cfg))
		`uvm_fatal("SRC_MON","get failed") 
        endfunction

 	function void connect_phase(uvm_phase phase);
          vif = src_cfg.vif;
        endfunction

	task run_phase(uvm_phase phase);
        	forever
          	     collect_data();     
        endtask

        task collect_data();
		src_xtn xtn;
		xtn=src_xtn::type_id::create("xtn");

		while(vif.mon_cb.busy!==0 || vif.mon_cb.pkt_valid!==1)
			@(vif.mon_cb);
 
		xtn.header= vif.mon_cb.data_in;
		xtn.payload=new[xtn.header[7:2]];

		@(vif.mon_cb);
		foreach(xtn.payload[i])
		   begin
			while(vif.mon_cb.busy!==0)
				@(vif.mon_cb);

			xtn.payload[i]=vif.mon_cb.data_in;
			@(vif.mon_cb);
		   end

		xtn.parity= vif.mon_cb.data_in;

		repeat(2)
			@(vif.mon_cb);

		xtn.err= vif.mon_cb.err;
		@(vif.mon_cb);
						
		
         	`uvm_info("SRC_MON",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW) 
		
  	  	monitor_port.write(xtn);

  	  	src_cfg.mon_rcvd_data_cnt++;
	
	endtask
	
	function void report_phase(uvm_phase phase);
    		`uvm_info(get_type_name(), $sformatf("Report: source Monitor Collected %0d Transactions", src_cfg.mon_rcvd_data_cnt), UVM_LOW)
 	 endfunction 		
		
endclass




	
