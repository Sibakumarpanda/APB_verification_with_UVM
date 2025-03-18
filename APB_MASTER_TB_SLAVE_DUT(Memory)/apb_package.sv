//------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright Siba Kumar Panda, All rights reserved
// File    : apb_package.sv 
// Project : APB design & verification Infra Development, where Master is TB and Slave is DUT (a memory)
// Purpose : 
// Author  : Siba Kumar Panda
////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef GUARD_APB_PACKAGE_SV
`define GUARD_APB_PACKAGE_SV

package apb_package;

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "apb_interface.sv" - Inside Package "interface" is not allowed to write
//`include "tb_define.sv" - We can include when this file is in use , at current its not used

`include "apb_agent_config.sv"
`include "apb_transaction.sv"
`include "apb_random_sequence.sv"
//`include "apb_basic_write_read_sequence.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_fun_cov.sv"
`include "apb_agent.sv"
`include "apb_reference_model.sv"
`include "apb_scoreboard.sv"
`include "apb_environment.sv"
`include "apb_base_test.sv"
//`include "apb_basic_write_read_test.sv"


endpackage : apb_package

`endif //GUARD_APB_PACKAGE_SV 