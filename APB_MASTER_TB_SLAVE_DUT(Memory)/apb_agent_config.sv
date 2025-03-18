//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_agent_config.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_AGENT_CONFIG_SV
`define GUARD_APB_AGENT_CONFIG_SV

import uvm_pkg::*;

class apb_agent_config extends uvm_object;
  
  `uvm_object_utils(apb_agent_config)

   virtual apb_interface intf;
   uvm_active_passive_enum active = UVM_ACTIVE; // active
   bit has_fun_cov = 1;                         // has_fun_cov
    
  //Function new  
  extern function new(string name = "apb_agent_config");
       
  
endclass :apb_agent_config

//===================================================================================
// New
//===================================================================================

function apb_agent_config::new(string name = "apb_agent_config");
    super.new(name);
endfunction :new

`endif //GUARD_APB_AGENT_CONFIG_SV 