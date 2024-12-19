///////////////////////////////////TEST
class test extends uvm_test;
	`uvm_component_utils(test)

    	 env envh;

         env_config env_cfg;
         src_config src_cfg;
         dst_config dst_cfg[];

	 bit has_srcagt=1;
	 bit has_dstagt=1; 
         int no_of_srcagent = 1;
         int no_of_dstagent = 3;

	extern function new(string name = "test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass
//fn def
   	function test::new(string name = "test" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test::build_phase(uvm_phase phase);
               	env_cfg = env_config::type_id::create("env_cfg");
                if(has_srcagt)
		   begin
                	src_cfg= src_config :: type_id :: create("src_cfg");
                	src_cfg.is_active= UVM_ACTIVE;
     	                if(!uvm_config_db #(virtual src_if) :: get(this," ","vif",src_cfg.vif))
              			`uvm_fatal("TEST","get failed in test(src interface)") 
               		env_cfg.src_cfg=src_cfg;
                   end
                if(has_dstagt) 
		   begin
                	env_cfg.dst_cfg = new[no_of_dstagent];
                	dst_cfg=new[no_of_dstagent];
                	foreach(dst_cfg[i]) 
			   begin
				dst_cfg[i]= dst_config :: type_id :: create($sformatf("dst_cfg[%0d]",i));
				dst_cfg[i].is_active= UVM_ACTIVE;
				if(!uvm_config_db #(virtual dst_if) :: get(this," ",$sformatf("vif%0d",i), dst_cfg[i].vif))
                			`uvm_fatal("TEST","get failed in test(dst interface)") 
                		env_cfg.dst_cfg[i]= dst_cfg[i];
                    	   end
                   end
		env_cfg.has_srcagt= has_srcagt;
                env_cfg.has_dstagt= has_dstagt;

       	 	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
     	
                super.build_phase(phase);
		
		envh=env::type_id::create("envh", this);
	endfunction



class test1 extends test;
	`uvm_component_utils(test1)

	vseq1 vseq1h;

	bit[1:0]addr;

	function new(string name = "test1" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		repeat(100)
		    begin
			randomize(addr) with {addr inside {[0:2]};};
			uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
			`uvm_info("TEST",$sformatf("addr=%0d",addr),UVM_LOW)
          		vseq1h=vseq1::type_id::create("vseq1h");
           		vseq1h.start(envh.v_sequencer);
		    end
                #50;
          	phase.drop_objection(this);
	endtask

endclass 

class test2 extends test;
	`uvm_component_utils(test2)

	vseq2 vseq2h;

	bit[1:0]addr;

	function new(string name = "test2" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		repeat(100)
		    begin
			randomize(addr) with {addr inside {[0:2]};};
			uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
			`uvm_info("TEST",$sformatf("addr=%0d",addr),UVM_LOW)
          		vseq2h=vseq2::type_id::create("vseq2h");
           		vseq2h.start(envh.v_sequencer);
		    end
                #50;
          	phase.drop_objection(this);
	endtask

endclass 

class test3 extends test;
	`uvm_component_utils(test3)

	vseq3 vseq3h;

	bit[1:0]addr;

	function new(string name = "test3" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
            super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		set_type_override_by_type(src_xtn::get_type(),src_xtn1::get_type(),1);
		
		repeat(100)
		    begin
			randomize(addr) with {addr inside {[0:2]};};
			uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
			`uvm_info("TEST",$sformatf("addr=%0d",addr),UVM_LOW)
          		vseq3h=vseq3::type_id::create("vseq3h");
           		vseq3h.start(envh.v_sequencer);
		    end
                #50;
          	phase.drop_objection(this);
	endtask

endclass 
