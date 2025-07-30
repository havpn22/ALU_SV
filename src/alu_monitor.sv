`include "defines.sv"
//`include "transaction.sv"

class alu_monitor;
        alu_transaction mon_trans;

        mailbox #(alu_transaction) mbx_ms;

        virtual alu_if.MON vif;

        covergroup mon_cg;
                RES: coverpoint mon_trans.res {bins b1[] = {[0:255]};}
                COUT: coverpoint mon_trans.cout;
                OFLOW: coverpoint mon_trans.oflow;
                G: coverpoint mon_trans.g;
                L: coverpoint mon_trans.l;
                E: coverpoint mon_trans.e;
                ERR: coverpoint mon_trans.err;
        endgroup

        function new(virtual alu_if.MON vif, mailbox #(alu_transaction)mbx_ms);
                        this.mbx_ms = mbx_ms;
                        this.vif = vif;
                        mon_cg = new();
        endfunction

        task start();
                repeat(5) @(vif.mon_cb);
                for(int i=0; i<`no_of_trans;i++) begin
                        int wait_count = 0;
                        mon_trans = new();
                        //repeat(1) @(vif.mon_cb)
                        //begin
                                mon_trans.res = vif.mon_cb.res;
                                mon_trans.cout = vif.mon_cb.cout;
                                mon_trans.oflow = vif.mon_cb.oflow;
                                mon_trans.err = vif.mon_cb.err;
                                mon_trans.e = vif.mon_cb.e;
                                mon_trans.l = vif.mon_cb.l;
                                mon_trans.g = vif.mon_cb.g;

                                mon_trans.ce = vif.mon_cb.ce;
                                mon_trans.mode = vif.mon_cb.mode;
                                mon_trans.cmd = vif.mon_cb.cmd;
                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                mon_trans.opa = vif.mon_cb.opa;
                                mon_trans.opb = vif.mon_cb.opb;
                                mon_trans.cin = vif.mon_cb.cin;
                        //end
                       if((mon_trans.inp_valid == 2'b11) || mon_trans.inp_valid == 2'b00) begin
                                mon_trans.res = vif.mon_cb.res;
                                mon_trans.cout = vif.mon_cb.cout;
                                mon_trans.oflow = vif.mon_cb.oflow;
                                mon_trans.err = vif.mon_cb.err;
                                mon_trans.e = vif.mon_cb.e;
                                mon_trans.l = vif.mon_cb.l;
                                mon_trans.g = vif.mon_cb.g;

                                mon_trans.ce = vif.mon_cb.ce;
                                mon_trans.mode = vif.mon_cb.mode;
                                mon_trans.cmd = vif.mon_cb.cmd;
                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                mon_trans.opa = vif.mon_cb.opa;
                                mon_trans.opb = vif.mon_cb.opb;
                                mon_trans.cin = vif.mon_cb.cin;
                                mon_cg.sample();
                                if((mon_trans.mode == 1)&& ((mon_trans.cmd == 4'b1010) || (mon_trans.cmd == 4'b1001))) begin
                                        repeat(2)@(vif.mon_cb);
                                        mon_trans.res = vif.mon_cb.res;
                                        mon_trans.cout = vif.mon_cb.cout;
                                        mon_trans.oflow = vif.mon_cb.oflow;
                                        mon_trans.err = vif.mon_cb.err;
                                        mon_trans.e = vif.mon_cb.e;
                                        mon_trans.l = vif.mon_cb.l;
                                        mon_trans.g = vif.mon_cb.g;

                                        mon_trans.ce = vif.mon_cb.ce;
                                        mon_trans.mode = vif.mon_cb.mode;
                                        mon_trans.cmd = vif.mon_cb.cmd;
                                        mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                        mon_trans.opa = vif.mon_cb.opa;
                                        mon_trans.opb = vif.mon_cb.opb;
                                        mon_trans.cin = vif.mon_cb.cin;
                                        mon_cg.sample();
                                        $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                end
                                else begin
                                        repeat(1)@(vif.mon_cb);
                                        mon_trans.res = vif.mon_cb.res;
                                        mon_trans.cout = vif.mon_cb.cout;
                                        mon_trans.oflow = vif.mon_cb.oflow;
                                        mon_trans.err = vif.mon_cb.err;
                                        mon_trans.e = vif.mon_cb.e;
                                        mon_trans.l = vif.mon_cb.l;
                                        mon_trans.g = vif.mon_cb.g;

                                        mon_trans.ce = vif.mon_cb.ce;
                                        mon_trans.mode = vif.mon_cb.mode;
                                        mon_trans.cmd = vif.mon_cb.cmd;
                                        mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                        mon_trans.opa = vif.mon_cb.opa;
                                        mon_trans.opb = vif.mon_cb.opb;
                                        mon_trans.cin = vif.mon_cb.cin;
                                        mon_cg.sample();
                                        $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                end
                        end

                        else begin
                                if((mon_trans.mode == 0) && (mon_trans.cmd == 4'b0110 || mon_trans.cmd == 4'b0111 || mon_trans.cmd == 4'b1000 || mon_trans.cmd == 4'b1001 || mon_trans.cmd == 4'b1010 || mon_trans.cmd == 4'b1011)) begin
                                        repeat(1)@(vif.mon_cb);
                                        mon_trans.res = vif.mon_cb.res;
                                        mon_trans.cout = vif.mon_cb.cout;
                                        mon_trans.oflow = vif.mon_cb.oflow;
                                        mon_trans.err = vif.mon_cb.err;
                                        mon_trans.e = vif.mon_cb.e;
                                        mon_trans.l = vif.mon_cb.l;
                                        mon_trans.g = vif.mon_cb.g;

                                        mon_trans.ce = vif.mon_cb.ce;
                                        mon_trans.mode = vif.mon_cb.mode;
                                        mon_trans.cmd = vif.mon_cb.cmd;
                                        mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                        mon_trans.opa = vif.mon_cb.opa;
                                        mon_trans.opb = vif.mon_cb.opb;
                                        mon_trans.cin = vif.mon_cb.cin;
                                        mon_cg.sample();
                                        $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                        end
                                else if ((mon_trans.mode == 1) && (mon_trans.cmd == 4'b0100 || mon_trans.cmd == 4'b0101 || mon_trans.cmd == 4'b0110 || mon_trans.cmd == 4'b0111)) begin
                                        repeat(1)@(vif.mon_cb);
                                        mon_trans.res = vif.mon_cb.res;
                                        mon_trans.cout = vif.mon_cb.cout;
                                        mon_trans.oflow = vif.mon_cb.oflow;
                                        mon_trans.err = vif.mon_cb.err;
                                        mon_trans.e = vif.mon_cb.e;
                                        mon_trans.l = vif.mon_cb.l;
                                        mon_trans.g = vif.mon_cb.g;

                                        mon_trans.ce = vif.mon_cb.ce;
                                        mon_trans.mode = vif.mon_cb.mode;
                                        mon_trans.cmd = vif.mon_cb.cmd;
                                        mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                        mon_trans.opa = vif.mon_cb.opa;
                                        mon_trans.opb = vif.mon_cb.opb;
                                        mon_trans.cin = vif.mon_cb.cin;
                                        mon_cg.sample();
                                        $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                end
                                else begin

                                        for(wait_count = 0; wait_count < 16; wait_count ++) begin
                                                repeat(1) @(vif.mon_cb);
                                                mon_trans.res = vif.mon_cb.res;
                                                mon_trans.cout = vif.mon_cb.cout;
                                                mon_trans.oflow = vif.mon_cb.oflow;
                                                mon_trans.err = vif.mon_cb.err;
                                                mon_trans.e = vif.mon_cb.e;
                                                mon_trans.l = vif.mon_cb.l;
                                                mon_trans.g = vif.mon_cb.g;

                                                mon_trans.ce = vif.mon_cb.ce;
                                                mon_trans.mode = vif.mon_cb.mode;
                                                mon_trans.cmd = vif.mon_cb.cmd;
                                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                                mon_trans.opa = vif.mon_cb.opa;
                                                mon_trans.opb = vif.mon_cb.opb;
                                                mon_trans.cin = vif.mon_cb.cin;
                                                mon_cg.sample();

                                                $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                                if(mon_trans.inp_valid == 2'b11) begin
                                                        if((mon_trans.mode == 1)&& ((mon_trans.cmd == 9) || (mon_trans.cmd == 10))) begin
                                                                mon_trans.res = vif.mon_cb.res;
                                                                mon_trans.cout = vif.mon_cb.cout;
                                                                mon_trans.oflow = vif.mon_cb.oflow;
                                                                mon_trans.err = vif.mon_cb.err;
                                                                mon_trans.e = vif.mon_cb.e;
                                                                mon_trans.l = vif.mon_cb.l;
                                                                mon_trans.g = vif.mon_cb.g;

                                                                mon_trans.ce = vif.mon_cb.ce;
                                                                mon_trans.mode = vif.mon_cb.mode;
                                                                mon_trans.cmd = vif.mon_cb.cmd;
                                                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                                                mon_trans.opa = vif.mon_cb.opa;
                                                                mon_trans.opb = vif.mon_cb.opb;
                                                                mon_trans.cin = vif.mon_cb.cin;
                                                                mon_cg.sample();
                                                                $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                                        end
                                                        else begin
                                                                mon_trans.res = vif.mon_cb.res;
                                                                mon_trans.cout = vif.mon_cb.cout;
                                                                mon_trans.oflow = vif.mon_cb.oflow;
                                                                mon_trans.err = vif.mon_cb.err;
                                                                mon_trans.e = vif.mon_cb.e;
                                                                mon_trans.l = vif.mon_cb.l;
                                                                mon_trans.g = vif.mon_cb.g;

                                                                mon_trans.ce = vif.mon_cb.ce;
                                                                mon_trans.mode = vif.mon_cb.mode;
                                                                mon_trans.cmd = vif.mon_cb.cmd;
                                                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                                                mon_trans.opa = vif.mon_cb.opa;
                                                                mon_trans.opb = vif.mon_cb.opb;
                                                                mon_trans.cin = vif.mon_cb.cin;
                                                                mon_cg.sample();
                                                                $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                                        end
                                                        break;
                                                end
                                        end
                                        if(wait_count == 16) begin
                                                mon_trans.res = vif.mon_cb.res;
                                                mon_trans.cout = vif.mon_cb.cout;
                                                mon_trans.oflow = vif.mon_cb.oflow;
                                                mon_trans.err = vif.mon_cb.err;
                                                mon_trans.e = vif.mon_cb.e;
                                                mon_trans.l = vif.mon_cb.l;
                                                mon_trans.g = vif.mon_cb.g;

                                                mon_trans.ce = vif.mon_cb.ce;
                                                mon_trans.mode = vif.mon_cb.mode;
                                                mon_trans.cmd = vif.mon_cb.cmd;
                                                mon_trans.inp_valid = vif.mon_cb.inp_valid;
                                                mon_trans.opa = vif.mon_cb.opa;
                                                mon_trans.opb = vif.mon_cb.opb;
                                                mon_trans.cin = vif.mon_cb.cin;
                                                mon_cg.sample();
                                                $display("Time: %0t, MONITOR DATA: res = %0d, cout = %0d, oflow = %0d, err = %0b, e = %0b, g = %0b, l = %0b", $time, mon_trans.res, mon_trans.cout, mon_trans.oflow, mon_trans.err, mon_trans.e, mon_trans.g, mon_trans.l);
                                        end
                                end
                        end
                        if((mon_trans.mode == 1) && ((mon_trans.cmd == 4'b1001) || (mon_trans.cmd == 4'b1010))) begin
                                repeat(1)@(vif.mon_cb);
                        end
                        repeat(1) @(vif.mon_cb);
                        mon_trans.res = vif.mon_cb.res;
                        mon_trans.cout = vif.mon_cb.cout;
                        mon_trans.oflow = vif.mon_cb.oflow;
                        mon_trans.err = vif.mon_cb.err;
                        mon_trans.e = vif.mon_cb.e;
                        mon_trans.l = vif.mon_cb.l;
                        mon_trans.g = vif.mon_cb.g;

                        mon_trans.ce = vif.mon_cb.ce;
                        mon_trans.mode = vif.mon_cb.mode;
                        mon_trans.cmd = vif.mon_cb.cmd;
                        mon_trans.inp_valid = vif.mon_cb.inp_valid;
                        mon_trans.opa = vif.mon_cb.opa;
                        mon_trans.opb = vif.mon_cb.opb;
                        mon_trans.cin = vif.mon_cb.cin;
                        mbx_ms.put(mon_trans);

                        mon_cg.sample();
                end
        endtask
endclass
