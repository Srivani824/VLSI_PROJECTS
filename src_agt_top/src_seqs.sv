class src_seqs extends uvm_sequence #(src_xtn);  

	`uvm_object_utils(src_seqs)  

	function new(string name ="src_seqs");
		super.new(name);
	endfunction
endclass


class src_seqs1 extends src_seqs;

  	`uvm_object_utils(src_seqs1)

	bit[1:0]addr;

	function new(string name = "src_seqs1");
		super.new(name);
	endfunction

	task body();
   		repeat(1)
		   begin
			if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
				`uvm_fatal("SRC_SEQS","get failed")
			req= src_xtn::type_id :: create("req");
	   		start_item(req);
   	   		assert(req.randomize() with {header[7:2] inside {[2:13]}; header[1:0]==addr;} );
	   	   	finish_item(req);
	          end 
    	endtask
endclass

class src_seqs2 extends src_seqs;

  	`uvm_object_utils(src_seqs2)

	bit[1:0]addr;

	function new(string name = "src_seqs2");
		super.new(name);
	endfunction

	task body();
   		repeat(1)
		   begin
			if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
				`uvm_fatal("SRC_SEQS","get failed")
			req= src_xtn::type_id :: create("req");
	   		start_item(req);
   	   		assert(req.randomize() with {header[7:2] =='d14; header[1:0]==addr;} );
	   	   	finish_item(req);
	          end 
    	endtask
endclass

class src_seqs3 extends src_seqs;

  	`uvm_object_utils(src_seqs3)

	bit[1:0]addr;

	function new(string name = "src_seqs3");
		super.new(name);
	endfunction

	task body();
   		repeat(1)
		   begin
			if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
				`uvm_fatal("SRC_SEQS","get failed")
			req= src_xtn::type_id :: create("req");
	   		start_item(req);
   	   		assert(req.randomize() with {header[7:2] ==26 ; header[1:0]==addr;} );
	   	   	finish_item(req);
	          end 
    	endtask
endclass
