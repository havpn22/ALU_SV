`include "defines.sv"
//`include "transaction.sv"

class alu_driver;
        alu_transaction drv_trans;

        mailbox #(alu_transaction)mbx_gd;
        mailbox #(alu_transaction)mbx_dr;

        virtual alu_if.DRV vif;

        covergroup drv_cg;
                OPA: coverpoint drv_trans.opa {bins opa = {[0:2**`DATA_WIDTH-1]};}
                OPB: coverpoint drv_trans.opb {bins opb = {[0:2**`DATA_WIDTH-1]};}
                CE: coverpoint drv_trans.ce;
                CIN: coverpoint drv_trans.cin;
                MODE: coverpoint drv_trans.mode;
                INP_VALID: coverpoint drv_trans.inp_valid;
                CMD_1: coverpoint drv_trans.cmd {bins cmd = {[0:10]} iff (drv_trans.mode == 1); }
                CMD_0: coverpoint drv_trans.cmd {bins cmd = {[0:13]} iff (drv_trans.mode == 0); }

                //cross mode, cmd_1
                //cross mode, cmd_0

        endgroup

        function new(mailbox #(alu_transaction)mbx_gd, mailbox #(alu_transaction)mbx_dr, virtual alu_if.DRV vif);
                this.mbx_gd = mbx_gd;
                this.mbx_dr = mbx_dr;
                this.vif = vif;
                drv_cg = new();
        endfunction

        task start();
                repeat(3) @(vif.drv_cb);
                        for(int i = 0; i < `no_of_trans; i++) begin
                                        @(vif.drv_cb);
                                        drv_trans = new();
                                        mbx_gd.get(drv_trans);
                                        drv_trans.rand_mode(1);
                                        drv_trans.rand_mode(1);
                                        if(vif.drv_cb.reset ==1) begin
                                                vif.drv_cb.ce <= 0;
                                                vif.drv_cb.mode <= 0;
                                                vif.drv_cb.cmd <= 0;
                                                vif.drv_cb.inp_valid <= 0;
                                                vif.drv_cb.opa <= 0;
                                                vif.drv_cb.opb <= 0;
                                                vif.drv_cb.cin <= 0;
                                                $display("Time: %0t, RESET IS ON ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                mbx_dr.put(drv_trans);
                                        end
                                        if(drv_trans.ce) begin
                                                if((drv_trans.inp_valid == 2'b11 || drv_trans.inp_valid == 2'b00))
                                                begin
                                                        vif.drv_cb.ce <= drv_trans.ce;
                                                        vif.drv_cb.mode <= drv_trans.mode;
                                                        vif.drv_cb.cmd <= drv_trans.cmd;
                                                        vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                        vif.drv_cb.opa <= drv_trans.opa;
                                                        vif.drv_cb.opb <= drv_trans.opb;
                                                        vif.drv_cb.cin <= drv_trans.cin;
                                                        $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                        drv_cg.sample();
                                                        if(((drv_trans.mode == 1)) && (drv_trans.cmd == 4'b1010 || drv_trans.cmd == 4'b1001))
                                                                repeat(2) @(vif.drv_cb);
                                                        mbx_dr.put(drv_trans);
                                                end
                                                else begin
                                                        if(drv_trans.inp_valid == 2'b01 || drv_trans.inp_valid == 2'b10) begin
                                                                if(drv_trans.mode == 0) begin
                                                                        if(drv_trans.cmd == 4'b0110 || drv_trans.cmd == 4'b0111 || drv_trans.cmd == 4'b1000 || drv_trans.cmd == 4'b1001 || drv_trans.cmd == 4'b1010) begin
                                                                                vif.drv_cb.ce <= drv_trans.ce;
                                                                                vif.drv_cb.mode <= drv_trans.mode;
                                                                                vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                vif.drv_cb.opa <= drv_trans.opa;
                                                                                vif.drv_cb.opb <= drv_trans.opb;
                                                                                vif.drv_cb.cin <= drv_trans.cin;
                                                                                $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                        drv_cg.sample();
                                                                                mbx_dr.put(drv_trans);
                                                                        end
                                                                        else begin
                                                                                vif.drv_cb.ce <= drv_trans.ce;
                                                                                vif.drv_cb.mode <= drv_trans.mode;
                                                                                vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                vif.drv_cb.opa <= drv_trans.opa;
                                                                                vif.drv_cb.opb <= drv_trans.opb;
                                                                                vif.drv_cb.cin <= drv_trans.cin;
                                                                                $display("Time: %t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                drv_cg.sample();
                                                                                drv_trans.mode.rand_mode(0);
                                                                                drv_trans.cmd.rand_mode(0);
                                                                                mbx_dr.put(drv_trans);
                                                                                for(int i = 0; i < 16; i++) begin
                                                                                        @(vif.drv_cb);
                                                                                        void'(drv_trans.randomize());
                                                                                        vif.drv_cb.ce <= drv_trans.ce;
                                                                                        vif.drv_cb.mode <= drv_trans.mode;
                                                                                        vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                        vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                        vif.drv_cb.opa <= drv_trans.opa;
                                                                                        vif.drv_cb.opb <= drv_trans.opb;
                                                                                        vif.drv_cb.cin <= drv_trans.cin;
                                                                                        drv_cg.sample();
                                                                                        $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                        mbx_dr.put(drv_trans);

                                                                                        if(drv_trans.inp_valid == 2'b11) begin
                                                                                                break;
                                                                                        end
                                                                                end
                                                                        end
                                                                end
                                                                else begin
                                                                        if(drv_trans.cmd == 4'b0100 || drv_trans.cmd == 4'b0101 || drv_trans.cmd == 4'b0110 || drv_trans.cmd == 4'b0111) begin
                                                                                vif.drv_cb.ce <= drv_trans.ce;
                                                                                vif.drv_cb.mode <= drv_trans.mode;
                                                                                vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                vif.drv_cb.opa <= drv_trans.opa;
                                                                                vif.drv_cb.opb <= drv_trans.opb;
                                                                                vif.drv_cb.cin <= drv_trans.cin;
                                                                                $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                drv_cg.sample();
                                                                                mbx_dr.put(drv_trans);
                                                                        end
                                                                        else begin
                                                                                drv_trans.mode.rand_mode(0);
                                                                                drv_trans.cmd.rand_mode(0);
                                                                                vif.drv_cb.ce <= drv_trans.ce;
                                                                                vif.drv_cb.mode <= drv_trans.mode;
                                                                                vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                vif.drv_cb.opa <= drv_trans.opa;
                                                                                vif.drv_cb.opb <= drv_trans.opb;
                                                                                vif.drv_cb.cin <= drv_trans.cin;
                                                                                $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                drv_cg.sample();
                                                                                mbx_dr.put(drv_trans);
                                                                                for(int i = 0; i < 16; i++) begin
                                                                                        @(vif.drv_cb);
                                                                                        void'(drv_trans.randomize());
                                                                                        vif.drv_cb.ce <= drv_trans.ce;
                                                                                        vif.drv_cb.mode <= drv_trans.mode;
                                                                                        vif.drv_cb.cmd <= drv_trans.cmd;
                                                                                        vif.drv_cb.inp_valid <= drv_trans.inp_valid;
                                                                                        vif.drv_cb.opa <= drv_trans.opa;
                                                                                        vif.drv_cb.opb <= drv_trans.opb;
                                                                                        vif.drv_cb.cin <= drv_trans.cin;
                                                                                        drv_cg.sample();
                                                                                        $display("Time: %0t, DATA SENT FROM DRIVER ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time, vif.drv_cb.ce, vif.drv_cb.mode, vif.drv_cb.cmd, vif.drv_cb.inp_valid, vif.drv_cb.opa, vif.drv_cb.opb, vif.drv_cb.cin);
                                                                                        mbx_dr.put(drv_trans);

                                                                                        if(drv_trans.inp_valid == 2'b11) begin
                                                                                                        break;
                                                                                        end
                                                                                end
                                                                        end
                                                                end
                                                        end
                                                end
                                        end
                                        /*if((drv_trans.cmd == 4'b1010 || drv_trans.cmd == 4'b1001)&&drv_trans.mode == 1)begin
                                                repeat(1)@(vif.drv_cb);
                                        end*/
                                        repeat(3)@(vif.drv_cb);
                                end
        endtask
endclass
