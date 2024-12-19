class dst_xtn extends uvm_sequence_item;
	`uvm_object_utils(dst_xtn)
	
	bit vld_out,read_enb;
	bit[7:0]header;
	bit[7:0]payload[];
	bit[7:0]parity;
	
	rand bit[5:0]cycles;

	function new(string name = "dst_xtn");
		super.new(name);
	endfunction

	function void do_print (uvm_printer printer);
    	   	printer.print_field( "vld_out",this.vld_out,1,UVM_DEC);
    	   	printer.print_field( "read_enb",this.read_enb,1,UVM_DEC);
    	   	printer.print_field( "header",this.header,8,UVM_DEC);
		foreach(this.payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
	 	printer.print_field( "parity",this.parity,8,UVM_DEC);
  	endfunction


endclass

