class src_xtn extends uvm_sequence_item;
	`uvm_object_utils(src_xtn)
	
	bit err,busy,pkt_valid,resetn;
	rand bit[7:0]header;
	rand bit[7:0]payload[];
	bit[7:0]parity;

	constraint addr1 {header[1:0]!='b11;}
	constraint plen {payload.size==header[7:2];}
	constraint max {header[7:2] inside {[1:63]};}
	
	function new(string name = "src_xtn");
		super.new(name);
	endfunction:new

	function void post_randomize();
		parity=header;
		foreach(payload[i])
			parity=parity^payload[i];
	endfunction

	function void do_print (uvm_printer printer);
       		printer.print_field( "err",this.err,1,UVM_DEC);
    	   	printer.print_field( "busy",this.busy,1,UVM_DEC);
    	   	printer.print_field( "pkt_valid",this.pkt_valid,1,UVM_DEC);
    	   	printer.print_field( "resetn",this.resetn,1,UVM_DEC);
    	   	printer.print_field( "header",this.header,8,UVM_DEC);
		foreach(this.payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
	 	printer.print_field( "parity",this.parity,8,UVM_DEC);
  	endfunction

endclass

class src_xtn1 extends src_xtn;
	`uvm_object_utils(src_xtn1)
	
	function void post_randomize();
		parity=header;
		foreach(payload[i])
			parity=parity && payload[i];
	endfunction

endclass

