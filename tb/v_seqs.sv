class v_seqs extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(v_seqs)  
  
       src_seqr src_seqrh;
       dst_seqr dst_seqrh[];
 
        v_seqr vsqrh;
  
	env_config env_cfg; 

	bit[1:0]addr;

	function new(string name ="v_seqs");
		super.new(name);
	endfunction

	task body();
	  	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
			`uvm_fatal("VSEQS","get failed")
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
				`uvm_fatal("VSEQ","get failed")

  	  	if($cast(vsqrh,m_sequencer)) 
    			`uvm_info("BODY", "$cast success",UVM_LOW)
		else
			`uvm_error("BODY","$cast failed")

 		if(env_cfg.has_srcagt)
  			src_seqrh = vsqrh.src_seqrh;
 		if(env_cfg.has_dstagt)
		   begin
 			dst_seqrh= new[env_cfg.no_of_dstagent];
 			foreach(dst_seqrh[i])
  				dst_seqrh[i] = vsqrh.dst_seqrh[i];
 		   end
	endtask
endclass
   
class vseq1 extends v_seqs;
	`uvm_object_utils(vseq1)  
 	src_seqs1 src_seqsh;
	dst_seqs1 dst_seqsh[];


	function new(string name ="vseq1");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_seqsh= src_seqs1::type_id::create("src_seqsh");
		dst_seqsh= new[env_cfg.no_of_dstagent];
		foreach(dst_seqsh[i])
			dst_seqsh[i]= dst_seqs1::type_id :: create($sformatf("dst_seqsh[%0d]",i));
		fork
			src_seqsh.start(src_seqrh);
			dst_seqsh[addr].start(dst_seqrh[addr]);
		join
	endtask
endclass

class vseq2 extends v_seqs;
	`uvm_object_utils(vseq2) 
 
 	src_seqs2 src_seqsh;
	dst_seqs2 dst_seqsh[];

	function new(string name ="vseq2");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_seqsh= src_seqs2::type_id::create("src_seqsh");
		dst_seqsh= new[env_cfg.no_of_dstagent];
		foreach(dst_seqsh[i])
			dst_seqsh[i]= dst_seqs2::type_id :: create($sformatf("dst_seqsh[%0d]",i));
		fork
			src_seqsh.start(src_seqrh);
			dst_seqsh[addr].start(dst_seqrh[addr]);
		join
	endtask
endclass

class vseq3 extends v_seqs;
	`uvm_object_utils(vseq3) 
 
 	src_seqs3 src_seqsh;
	dst_seqs3 dst_seqsh[];

	function new(string name ="vseq3");
		super.new(name);
	endfunction

	task body();
		super.body();
		src_seqsh= src_seqs3::type_id::create("src_seqsh");
		dst_seqsh= new[env_cfg.no_of_dstagent];
		foreach(dst_seqsh[i])
			dst_seqsh[i]= dst_seqs3::type_id :: create($sformatf("dst_seqsh[%0d]",i));
		fork
			src_seqsh.start(src_seqrh);
			dst_seqsh[addr].start(dst_seqrh[addr]);
		join
	endtask
endclass



