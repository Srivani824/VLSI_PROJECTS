/*////////////////////Package////////////////////////*/
package pkg;
int no_of_transactions=1;
endpackage
/*////////////////////RTL/////////////////////////*/
module mod12_count(input clk,rst,load,mode,input [3:0]data_in,output reg [3:0]data_out);
always@(posedge clk)
begin
if(rst)
data_out<=0;
else if(load)
data_out<=data_in;
else if(mode==0)
begin
if(data_out==4'd11)
data_out<=0;
else
data_out<=data_out+1'b1;
end
else if(mode==1)
begin
if(data_out==0)
data_out<=11;
else
data_out<=data_out-1'b1;
end
else
data_out<=data_out;
end
endmodule


/*//////////////////////////INTERFACE//////////////////////////////*/
interface count_if(input bit clk);
logic rst;
logic load;
logic mode;
logic [3:0]data_in;
logic [3:0]data_out;

clocking wr_drv_cb@(posedge clk);
default input #1 output #1;
output rst;
output load;
output mode;
output data_in;
endclocking

clocking wr_mon_cb@(posedge clk);
default input #1 output #1;
input rst;
input load;
input mode;
input data_in;
endclocking

clocking rd_mon_cb@(posedge clk);
default input #1 output #1;
input data_out;
endclocking

modport WR_DRV_MP(clocking wr_drv_cb);
modport WR_MON_MP(clocking wr_mon_cb);
modport RD_MON_MP(clocking rd_mon_cb);
endinterface

/*///////////////////////////Transaction/////////////////////////////////////*/
class count_trans;
rand bit rst;
rand bit load;
rand bit mode;
rand bit [3:0]data_in;
bit [3:0]data_out;
constraint c1{data_in inside{[0:11]};}
constraint c2{rst dist{0:=10,1:=1};}
constraint c3{load dist{0:=10,1:=2};}
constraint c4{mode dist{[0:1]:/10};}

static int no_of_rst_trans;
static int no_of_load_trans;
static int no_of_mod1_trans;
static int trans_id;

function void display(input string s);
$display("%s",s);
$display("=========================================");
$display("transaction id is %d",trans_id);
$display("reset=%d,load=%d,mode=%d",rst,load,mode);
$display("Data in =%d",data_in);
$display("Data out =%d",data_out);
$display("=========================================");
endfunction

function void post_randomize;
if(rst==1)
no_of_rst_trans++;
if(load==1)
no_of_load_trans++;
if(mode==1)
no_of_mod1_trans++;
display("Randomized data");
endfunction

endclass

/*///////////////////////////Generator/////////////////*/
class count_gen;
count_trans data1;
count_trans data2;
mailbox #(count_trans) gen2wr;

function new(mailbox #(count_trans) gen2wr);
this.gen2wr=gen2wr;
data1=new();
endfunction

virtual task start();
fork
begin
for(int i=0;i<pkg::no_of_transactions;i++)
//while(1)
begin
data1.trans_id++;
assert(data1.randomize());
data2=new data1;
gen2wr.put(data2);
end
end
join_none
endtask
endclass

/*//////////////////////////Write Driver//////////////////*/
class count_wr_drv;
virtual count_if.WR_DRV_MP wr_drv_if;
mailbox #(count_trans) gen2wr;
count_trans data2duv;
function new(virtual count_if.WR_DRV_MP wr_drv_if,mailbox #(count_trans) gen2wr);
this.wr_drv_if=wr_drv_if;
this.gen2wr=gen2wr;
endfunction

virtual task drive();
repeat(2)
begin
@(wr_drv_if.wr_drv_cb);
end
wr_drv_if.wr_drv_cb.rst<=data2duv.rst;
wr_drv_if.wr_drv_cb.load<=data2duv.load;
wr_drv_if.wr_drv_cb.mode<=data2duv.mode;
wr_drv_if.wr_drv_cb.data_in<=data2duv.data_in;
endtask

virtual task start();
fork
forever
begin
gen2wr.get(data2duv);
drive();
end
join_none
endtask
endclass

/*///////////////////////////////Write Monitor///////////////////////*/
class count_wr_monitor;
virtual count_if.WR_MON_MP wr_mon_if;
mailbox #(count_trans) wr2rm;
count_trans data2rm;
function new(virtual count_if.WR_MON_MP wr_mon_if,mailbox #(count_trans) wr2rm);
this.wr_mon_if=wr_mon_if;
this.wr2rm=wr2rm;
data2rm=new();
endfunction

virtual task monitor();
repeat(2)
@(wr_mon_if.wr_mon_cb);
begin
data2rm.rst=wr_mon_if.wr_mon_cb.rst;
data2rm.load=wr_mon_if.wr_mon_cb.load;
data2rm.mode=wr_mon_if.wr_mon_cb.mode;
data2rm.data_in=wr_mon_if.wr_mon_cb.data_in;
end
endtask

virtual task start();
fork
forever
begin
monitor();
wr2rm.put(data2rm);
end
join_none
endtask
endclass

/*//////////////////////////////////////Read Monitor///////////////////////*/
class count_rd_monitor;
virtual count_if.RD_MON_MP rd_mon_if;
mailbox #(count_trans) rm2sb;
count_trans data2sb;
function new(virtual count_if.RD_MON_MP rd_mon_if,mailbox #(count_trans) rm2sb);
this.rd_mon_if=rd_mon_if;
this.rm2sb=rm2sb;
data2sb=new();
endfunction

virtual task monitor();
@(rd_mon_if.rd_mon_cb);
begin
data2sb.data_out=rd_mon_if.rd_mon_cb.data_out;
end
endtask

virtual task start();
fork
forever
begin
monitor();
rm2sb.put(data2sb);
end
join_none
endtask
endclass

/*///////////////////////Reference model////////////////////*/
class count_model;
count_trans mon_data;
mailbox #(count_trans) wr2rm;
mailbox #(count_trans) rm2sb;
logic [3:0]ref_out;
function new(mailbox #(count_trans) wr2rm,mailbox #(count_trans) rm2sb);
this.wr2rm=wr2rm;
this.rm2sb=rm2sb;
endfunction

virtual task count_rm(count_trans mon_data);
begin
if(mon_data.rst)
ref_out<=0;
else if(mon_data.load)
ref_out<=mon_data.data_in;
else if(mon_data.mode==0)
begin
if(ref_out==4'd11)
ref_out<=0;
else
ref_out<=ref_out+1'b1;
end
else if(mon_data.mode==1)
begin
if(ref_out==0)
ref_out<=11;
else
ref_out<=ref_out-1'b1;
end
else
ref_out<=ref_out;
end
endtask

virtual task start();
fork
begin
forever
begin
wr2rm.get(mon_data);
count_rm(mon_data);
mon_data.data_out=ref_out;
rm2sb.put(mon_data);
end
end
join_none
endtask

endclass

/*//////////////////////////////Score board////////////////////*/
class count_sb;
      event DONE; 
   int data_verified = 0;
   int rm_data_count = 0;
   int mon_data_count = 0;
   
   count_trans rm_data;  
   count_trans cov_data;
   count_trans mon_sb;

  mailbox #(count_trans) rm2sb;
  mailbox #(count_trans) mon2sb;  
  covergroup mem_coverage;
           

      A : coverpoint cov_data.mode{
                     bins ZERO ={0};
                     bins ONE ={1} ;}

      B : coverpoint cov_data.data_out{
                       bins ZE={0};
                       bins ON={1};
                       bins TW={2};
                       bins THR={3};  
                       bins FO={4};
                       bins FI={5};
                       bins SI={6};
                       bins SE={7};
                       bins EI={8};
                       bins NI={9};
                       bins TE={10};
                       bins EL={11};
                                 }
      READxADD: cross A,B; 
      
   endgroup : mem_coverage
   
  function new(mailbox #(count_trans) rm2sb,
                mailbox #(count_trans) mon2sb);
      this.rm2sb    = rm2sb;
      this.mon2sb = mon2sb;
      mem_coverage  = new;    
   endfunction: new
  virtual task check(count_trans rddata);
   begin
     if(rm_data.data_out == rddata.data_out)
       //begin
            $display("Count Matches %d",rddata.data_out);
            //$finish;end
     else
        $display("Count Not matches");
end
data_verified++;
cov_data=new rm_data;
mem_coverage.sample();
if(data_verified>=pkg::no_of_transactions)
begin
->DONE;
end
endtask

virtual task start();
fork
forever
begin
rm2sb.get(rm_data);
rm_data_count++;
mon2sb.get(mon_sb);
mon_data_count++;
check(mon_sb);
end
join_none
endtask

virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display(" %0d Model Data Generated, %0d Monito Data Recevied, %0d  Data Verified \n",
                                             rm_data_count,mon_data_count,data_verified);
      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report
    
endclass

/*///////////////////////////////Environment/////////////////////////*/
class count_env;

virtual count_if.WR_DRV_MP wr_drv_if;
virtual count_if.WR_MON_MP wr_mon_if;
virtual count_if.RD_MON_MP rd_mon_if;

mailbox #(count_trans) gen2wr =new();
mailbox #(count_trans) wr2rm = new();
mailbox #(count_trans) rd2sb=new();
mailbox #(count_trans) rm2sb=new();

count_gen gen_h;
count_wr_drv wr_drv_h;
count_rd_monitor rd_mon_h;
count_wr_monitor wr_mon_h;
count_model ref_mod_h;
count_sb sb_h;

function new(virtual count_if.WR_DRV_MP wr_drv_if,virtual count_if.WR_MON_MP wr_mon_if,virtual count_if.RD_MON_MP rd_mon_if);
   this.wr_drv_if=wr_drv_if;
   this.wr_mon_if=wr_mon_if;
   this.rd_mon_if=rd_mon_if;
   endfunction          

virtual task build;
    gen_h=new(gen2wr);
    wr_drv_h=new(wr_drv_if,gen2wr);
    wr_mon_h=new(wr_mon_if,wr2rm);
    rd_mon_h=new(rd_mon_if,rd2sb);
    ref_mod_h=new(wr2rm,rm2sb);
    sb_h=new(rm2sb,rd2sb);
    endtask
task start();
    gen_h.start();
    wr_drv_h.start();
    wr_mon_h.start();
    rd_mon_h.start();
    ref_mod_h.start();
    sb_h.start();
   endtask
  
   task stop();
      wait(sb_h.DONE.triggered);
   endtask : stop 
task run();
     start();
     stop();
     sb_h.report();
   endtask
endclass 
/*///////////////////////// tEST cASE////////////////////*/
class test;
//int no_of_transactions=1;
virtual count_if.WR_DRV_MP wr_drv_if;
virtual count_if.WR_MON_MP wr_mon_if;
virtual count_if.RD_MON_MP rd_mon_if;

count_env env_h;
function new(virtual count_if.WR_DRV_MP wr_drv_if,virtual count_if.WR_MON_MP wr_mon_if,virtual count_if.RD_MON_MP rd_mon_if);
   this.wr_drv_if=wr_drv_if;
   this.wr_mon_if=wr_mon_if;
   this.rd_mon_if=rd_mon_if;
   env_h=new(wr_drv_if,wr_mon_if,rd_mon_if);
endfunction    
task build();
begin
pkg::no_of_transactions =500;
env_h.build;
end
endtask

task run();
begin
env_h.run();
$finish;
end
endtask
endclass

/*///////////////////////////////////Top module////////////////////*/

module top();
import pkg::*;
parameter cycle=10;
reg clock;
count_if DUV_IF(clock);
test test_h;
mod12_count DUV(clock,DUV_IF.rst,DUV_IF.load,DUV_IF.mode,DUV_IF.data_in,DUV_IF.data_out);
initial
begin
test_h=new(DUV_IF,DUV_IF,DUV_IF);
test_h.build();
test_h.run();
end

initial
begin
clock=1'b0;
forever #(cycle/2)clock=~clock;
end
endmodule
