class dst_seqr extends uvm_sequencer#(dst_xtn);
	`uvm_component_utils(dst_seqr)

	function new(string name="dst_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
