//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_random_sequence.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : It Generates random sequence
// Author  : Siba Kumar Panda
///////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_RANDOM_SEQUENCE_SV
`define GUARD_APB_RANDOM_SEQUENCE_SV

import uvm_pkg::*;

class apb_random_sequence extends uvm_sequence;
  
    `uvm_object_utils(apb_random_sequence);

    //  Group: Variables
    apb_transaction trans;
    int no_of_testcases;
  
    //Constructor: new   
    extern function new(string name = "apb_random_sequence");
    
    //  Task: pre_body- This task is a user-definable callback that is called before the execution of <body> ~only~ when the sequence is started with <start>.
    //  If <start> is called with ~call_pre_post~ set to 0, ~pre_body~ is not called.
    extern virtual task pre_body();

    //  Task: body-This is the user-defined task where the main sequence code resides.
    extern virtual task body();
    
endclass: apb_random_sequence
      
//===================================================================================
// New
//===================================================================================
function apb_random_sequence::new(string name = "apb_random_sequence");
     super.new(name);
     trans = apb_transaction::type_id::create("trans");
  
     if(!uvm_config_db#(int)::get(null, "apb_rand_seq.", "no_cases", no_of_testcases)) begin
        `uvm_warning(get_name(), "Cant get no of testcases, Using default no of test cases = 10")
         no_of_testcases = 10;
     end
endfunction: new      
      
//===================================================================================
// pre_body()
//===================================================================================
task apb_random_sequence::pre_body();
  
    start_item(trans);
  
    trans.p_id = 1;
    trans.f_id = 5; 
    trans.PRESETn = 0;
    trans.PADDR = {32'h0};
    trans.PWDATA = {32'h0};
  
    finish_item(trans);
  
endtask

//===================================================================================
// body()
//===================================================================================
task apb_random_sequence::body();
  
  for (int i = 0; i < no_of_testcases-1; i++) begin 
  //for (int i = 0; i < 10; i++) begin
        start_item(trans);
        if(!trans.randomize())
            `uvm_fatal(get_name(), "Randomization failed");
            `uvm_info(get_name(), trans.convert2string(), UVM_MEDIUM)
        
        finish_item(trans);
        $display("Number of Iteration completed =%0d",i);
   end
  
endtask: body
      
`endif //GUARD_APB_RANDOM_SEQUENCE_SV