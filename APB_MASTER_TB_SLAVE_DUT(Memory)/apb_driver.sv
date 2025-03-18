//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_driver.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_DRIVER_SV
`define GUARD_APB_DRIVER_SV

import uvm_pkg::*;

class apb_driver extends uvm_driver#(apb_transaction);
  
  `uvm_component_utils(apb_driver)
    
    //  Group: Variables
    apb_transaction trans_drv;
    virtual apb_interface.DRV drv_intf;
    int i;
    event DRV_DONE;
  
    //  Constructor: new
    extern function new(string name ="apb_driver", uvm_component parent);
    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);    
    //  Function: run_phase
    extern task run_phase(uvm_phase phase);
      
    extern task drive ();
    extern task idle ();
    extern task setup ();
    extern task access ();
        
      
endclass :apb_driver //driver extends uvm_driver#(transaction)
      
//===================================================================================
// New
//===================================================================================
function apb_driver::new(string name = "apb_driver", uvm_component parent);
  super.new(name,parent);
endfunction: new  

//===================================================================================
// build_phase
//===================================================================================
function void apb_driver::build_phase(uvm_phase phase);
     if(!uvm_config_db#(virtual apb_interface)::get(this, "*", "vif", drv_intf))
        `uvm_fatal(get_name(), "Cant get interface")    
endfunction: build_phase

//===================================================================================
// run_phase
//===================================================================================
task apb_driver::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(trans_drv);
        drive();
        @(drv_intf.drv_cb);
        // ->DRV_DONE;
        seq_item_port.item_done();
    end
endtask: run_phase 
  
//  Below tasks are used inside the run phase task
  
// drive task - Switches b/w different operating states
task apb_driver::drive();
     if(!trans_drv.PRESETn) begin
          @(drv_intf.drv_cb);
          drv_intf.drv_cb.PRESETn <= trans_drv.PRESETn;
          #10;
          drv_intf.drv_cb.PRESETn <= 1;
     end
     else begin  
          @(drv_intf.drv_cb);
          for(i=0; i<trans_drv.PADDR.size(); i++) begin
              setup();
              @(drv_intf.drv_cb);
              access();
              wait(drv_intf.drv_cb.PREADY == 1);
          end
     end
      idle();
endtask : drive  
  
task apb_driver::idle();// idle task - IDLE operating state
     drv_intf.drv_cb.PSEL1   <= 0;
     drv_intf.drv_cb.PENABLE <= 0;
endtask :idle

task apb_driver::setup();// setup task - SETUP operating state (Sets all the input for the slave)
     // #2;
     drv_intf.drv_cb.PSEL1   <= 1;
     drv_intf.drv_cb.PENABLE <= 0;
     drv_intf.drv_cb.PRESETn <= trans_drv.PRESETn;
     drv_intf.drv_cb.PWRITE  <= trans_drv.PWRITE;
     drv_intf.drv_cb.PWDATA  <= trans_drv.PWDATA[i];
     drv_intf.drv_cb.PADDR   <= trans_drv.PADDR[i];
endtask :setup

task apb_driver::access();// access task - ACCESS operating state
     drv_intf.drv_cb.PSEL1   <= 1;
     drv_intf.drv_cb.PENABLE <= 1;
endtask : access
  
`endif //GUARD_APB_DRIVER_SV   
