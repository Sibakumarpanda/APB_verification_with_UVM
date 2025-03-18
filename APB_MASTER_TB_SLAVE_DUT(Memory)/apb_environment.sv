//-------------------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_environment.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
/////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_ENVIRONMENT_SV
`define GUARD_APB_ENVIRONMENT_SV

import uvm_pkg::*;

class apb_environment extends uvm_env;
  `uvm_component_utils(apb_environment)

   apb_agent agnt;
   apb_scoreboard scb;
   
   // Constructor: new
   extern function new(string name = "apb_environment", uvm_component parent);
   //  Function: build_phase
   extern function void build_phase(uvm_phase phase);
   //  Function: connect_phase
   extern function void connect_phase(uvm_phase phase);  
    
endclass :apb_environment 

//===================================================================================
// New
//===================================================================================
function apb_environment::new(string name ="apb_environment", uvm_component parent);
    super.new(name, parent);
endfunction :new

//===================================================================================
// build_phase
//===================================================================================
function void apb_environment::build_phase(uvm_phase phase);
    agnt = apb_agent::type_id::create("agnt", this);
    scb = apb_scoreboard::type_id::create("scb", this);
endfunction: build_phase

//===================================================================================
// Connect_phase
//===================================================================================
function void apb_environment::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnt.ap.connect(scb.ap_exp);
endfunction: connect_phase

`endif //GUARD_APB_ENVIRONMENT_SV