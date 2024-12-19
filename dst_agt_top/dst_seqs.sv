class dst_seqs extends uvm_sequence#(dst_xtn);
	`uvm_object_utils(dst_seqs)

	function new(string name="dst_seqs");
		super.new(name);
	endfunction

endclass

class dst_seqs1  extends dst_seqs;
	`uvm_object_utils(dst_seqs1);

	function new(string name="dst_seqs1");
		super.new(name);
	endfunction

	task body;
		req=dst_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {cycles<10;});
		finish_item(req);
	endtask
endclass


class dst_seqs2  extends dst_seqs;
	`uvm_object_utils(dst_seqs2);

	function new(string name="dst_seqs2");
		super.new(name);
	endfunction

	task body;
		req=dst_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {cycles==5;});
		finish_item(req);
	endtask
endclass

class dst_seqs3  extends dst_seqs;
	`uvm_object_utils(dst_seqs3);

	function new(string name="dst_seqs3");
		super.new(name);
	endfunction

	task body;
		req=dst_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {cycles<29;});
		finish_item(req);
	endtask
endclass
