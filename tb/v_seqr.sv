//////////////////////////////////VSEQR
class v_seqr extends uvm_sequencer #(uvm_sequence_item) ;
	`uvm_component_utils(v_seqr)

        src_seqr src_seqrh;
	dst_seqr dst_seqrh[];

  	env_config env_cfg;

 	extern function new(string name = "v_seqr",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

////fn def
	function v_seqr::new(string name="v_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void v_seqr::build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("VSEQR","get failed")
         	src_seqrh=src_seqr::type_id::create("src_seqrh",this);
         	dst_seqrh=new[env_cfg.no_of_dstagent];
		foreach(dst_seqrh[i])
			dst_seqrh[i]= dst_seqr::type_id::create($sformatf("dst_seqrh[%0d]",i),this);  
	endfunction
