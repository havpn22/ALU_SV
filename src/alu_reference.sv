`include "defines.sv"
//`include "transaction.sv"

class alu_reference;
        alu_transaction ref_trans;

        mailbox #(alu_transaction) mbx_dr;
        mailbox #(alu_transaction) mbx_rs;

        virtual alu_if.REF_SB vif;

        function new(mailbox #(alu_transaction) mbx_dr, mailbox #(alu_transaction) mbx_rs, virtual alu_if.REF_SB vif);
                this.mbx_dr = mbx_dr;
                this.mbx_rs = mbx_rs;
                this.vif = vif;
        endfunction

        localparam int SHIFT_AMOUNT = $clog2(`DATA_WIDTH);

        task start();
                repeat(4) @(vif.ref_cb);
                for(int i = 0; i < `no_of_trans;i++)
                begin
                        ref_trans = new();
                        mbx_dr.get(ref_trans);
                        repeat(1) @(vif.ref_cb);
                        //begin
                                if(vif.reset) begin
                                        @(vif.ref_cb);
                                        ref_trans.res = 1'bz;
                                        ref_trans.cout = 1'bz;
                                        ref_trans.oflow = 1'bz;
                                        ref_trans.g = 1'bz;
                                        ref_trans.l = 1'bz;
                                        ref_trans.e = 1'bz;
                                        ref_trans.err = 1'bz;
                                        //$display("Time: %0t, Reference op res=%0d, err=%0d, oflow=%0d, cout=%0d, g=%0d, l=%0d, e=%0d at time %t",$time, ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e);
                                end
                                else if(ref_trans.ce) begin
                                        if(ref_trans.mode == 1) begin
                                                if(ref_trans.inp_valid == 2'b00) begin
                                                        //@(vif.ref_cb);
                                                        ref_trans.err = 1;
                                                end
                                                else if(ref_trans.inp_valid == 2'b01 &&(ref_trans.cmd == 4'b0100 || ref_trans.cmd == 4'b0101)) begin
                                                        //@(vif.ref_cb);
                                                        ref_trans.err = 1'bz;
                                                        case(ref_trans.cmd)
                                                                4'b0100: begin
                                                                        ref_trans.res = ref_trans.opa + 1;
                                                                end
                                                                4'b0101: begin
                                                                        ref_trans.res = ref_trans.opa - 1;
                                                                end
                                                                default: ref_trans.err = 1;
                                                        endcase
                                                end
                                                else if(ref_trans.inp_valid == 2'b10 && (ref_trans.cmd == 4'b0110 || ref_trans.cmd == 4'b0111)) begin
                                                        //@(vif.ref_cb);
                                                        ref_trans.err = 1'bz;
                                                        case(ref_trans.cmd)
                                                                4'b0110: begin
                                                                        ref_trans.res = ref_trans.opb + 1;
                                                                end
                                                                4'b0111: begin
                                                                        ref_trans.res = ref_trans.opb - 1;
                                                                end
                                                                default: ref_trans.err = 1;
                                                        endcase
                                                end
                                                else begin
                                                        int wait_counter = 0;
                                                        if(ref_trans.inp_valid != 2'b11 && wait_counter < 16) begin
                                                                while(wait_counter < 16) begin
                                                                        @(vif.ref_cb);
                                                                        mbx_dr.get(ref_trans);
                                                                        //if(vif.drv_cb.inp_valid == 2'b11) begin
                                                                        if(ref_trans.inp_valid == 2'b11) begin
                                                                                //ref_trans.inp_valid = vif.drv_cb.inp_valid;
                                                                                ref_trans.err = 0;
                                                                                break;
                                                                        end
                                                                        wait_counter += 1;
                                                                end
                                                                if(wait_counter == 16)
                                                                        ref_trans.err = 1;
                                                        end
                                                        else begin
                                                                //@(vif.ref_cb);
                                                                ref_trans.err = 1'bz;
                                                                ref_trans.e = 1'bz;
                                                                ref_trans.g = 1'bz;
                                                                ref_trans.l = 1'bz;
                                                                case(ref_trans.cmd)
                                                                        4'b0000: begin
                                                                                ref_trans.res = ref_trans.opa + ref_trans.opb;
                                                                                ref_trans.cout = ref_trans.res[`DATA_WIDTH];
                                                                        end
                                                                        4'b0001: begin
                                                                                ref_trans.res = ref_trans.opa - ref_trans.opb;
                                                                                ref_trans.oflow = (ref_trans.opa < ref_trans.opb) ? 1 : 0;
                                                                        end
                                                                        4'b0010: begin
                                                                                ref_trans.res = ref_trans.opa + ref_trans.opb + ref_trans.cin;
                                                                                ref_trans.cout = ref_trans.res[`DATA_WIDTH];
                                                                        end
                                                                        4'b0011: begin
                                                                                ref_trans.res = ref_trans.opa - ref_trans.opb - ref_trans.cin;
                                                                                ref_trans.oflow = (ref_trans.opa < ref_trans.opb) ? 1 : 0;
                                                                        end
                                                                        4'b0100: begin
                                                                                ref_trans.res = ref_trans.opa + 1;
                                                                        end
                                                                        4'b0101: begin
                                                                                ref_trans.res = ref_trans.opa - 1;
                                                                        end
                                                                        4'b0110: begin
                                                                                ref_trans.res = ref_trans.opb + 1;
                                                                        end
                                                                        4'b0111: begin
                                                                                ref_trans.res = ref_trans.opb - 1;
                                                                        end
                                                                        4'b1000: begin
                                                                                if(ref_trans.opa > ref_trans.opb) ref_trans.g = 1;
                                                                                else if(ref_trans.opa < ref_trans.opb) ref_trans.l = 1;
                                                                                else ref_trans.e = 1;
                                                                        end
                                                                        4'b1001: begin
                                                                                repeat(2) @(vif.ref_cb);
                                                                                ref_trans.res = (ref_trans.opa + 1) * (ref_trans.opb + 1);
                                                                        end
                                                                        4'b1010: begin
                                                                                repeat(2) @(vif.ref_cb);
                                                                                ref_trans.res = (ref_trans.opa << 1) * (ref_trans.opb);
                                                                        end
                                                                        default: ref_trans.err = 1;
                                                                endcase
                                                        end
                                                end
                                        end
                                        else begin
                                        if(ref_trans.inp_valid == 2'b00) begin
                                                //@(vif.ref_cb);
                                                ref_trans.err = 1;
                                        end
                                        else if(ref_trans.inp_valid == 2'b01 && (ref_trans.cmd == 4'b0110 || ref_trans.cmd == 4'b1000 || ref_trans.cmd == 4'b1001)) begin
                                                //@(vif.ref_cb);
                                                ref_trans.err = 1'bz;
                                                case(ref_trans.cmd)
                                                        4'b0110: ref_trans.res = {1'b0, ~ref_trans.opa};
                                                        4'b1000: ref_trans.res = {1'b0, ref_trans.opa >> 1};
                                                        4'b1001: ref_trans.res = {1'b0, ref_trans.opa << 1};
                                                        default: ref_trans.err = 1;
                                                endcase
                                        end
                                        else if(ref_trans.inp_valid == 2'b10 && (ref_trans.cmd == 4'b0111 || ref_trans.cmd == 4'b1010 || ref_trans.cmd == 4'b1011)) begin
                                                ref_trans.err = 1'bz;
                                                case(ref_trans.cmd)
                                                        4'b0111: ref_trans.res = {1'b0, ~ref_trans.opb};
                                                        4'b1010: ref_trans.res = {1'b0, ref_trans.opb >> 1};
                                                        4'b1011: ref_trans.res = {1'b0, ref_trans.opb << 1};
                                                        default: ref_trans.err = 1;
                                                endcase
                                        end
                                        else begin
                                                int wait_counter = 0;
                                                if(ref_trans.inp_valid != 2'b11 && wait_counter < 16) begin
                                                        while(wait_counter < 16) begin
                                                                @(vif.ref_cb);
                                                                mbx_dr.get(ref_trans);
                                                                //ref_trans.inp_valid = vif.inp_valid;
                                                                if(ref_trans.inp_valid == 2'b11) begin
                                                                        ref_trans.err = 0;
                                                                        break;
                                                                end
                                                                wait_counter += 1;
                                                        end
                                                        if(wait_counter == 16)
                                                                ref_trans.err = 1;
                                                end
                                                else begin
                                                        //@(vif.ref_cb);
                                                        ref_trans.err = 1'bz;
                                                        case(ref_trans.cmd)
                                                                4'b0000: ref_trans.res = ref_trans.opa & ref_trans.opb;
                                                                4'b0001: ref_trans.res = {1'b0, ~(ref_trans.opa & ref_trans.opb)};
                                                                4'b0010: ref_trans.res = ref_trans.opa | ref_trans.opb;
                                                                4'b0011: ref_trans.res = {1'b0, ~(ref_trans.opa | ref_trans.opb)};
                                                                4'b0100: ref_trans.res = ref_trans.opa ^ ref_trans.opb;
                                                                4'b0101: ref_trans.res = {1'b0, ~(ref_trans.opa ^ ref_trans.opb)};
                                                                4'b0110: ref_trans.res = {1'b0, ~ref_trans.opa};
                                                                4'b0111: ref_trans.res = {1'b0, ~(ref_trans.opb)};
                                                                4'b1000: ref_trans.res = {1'b0, ref_trans.opa >> 1};
                                                                4'b1001: ref_trans.res = {1'b0, ref_trans.opa << 1};
                                                                4'b1010: ref_trans.res = {1'b0, ref_trans.opb >> 1};
                                                                4'b1011: ref_trans.res = {1'b0, ref_trans.opb << 1};
                                                                4'b1100: begin
                                                                        if(|ref_trans.opb[(`DATA_WIDTH - 1) : (SHIFT_AMOUNT + 1)])
                                                                                ref_trans.err = 1;
                                                                        else begin
                                                                                ref_trans.res = (ref_trans.opa << ref_trans.opb[SHIFT_AMOUNT - 1 : 0]) | (ref_trans.opa >> (`DATA_WIDTH -ref_trans.opb[SHIFT_AMOUNT - 1 : 0]));
                                                                        end
                                                                end
                                                                4'b1101: begin
                                                                        if(|ref_trans.opb[`DATA_WIDTH - 1 : SHIFT_AMOUNT + 1])
                                                                                ref_trans.err = 1;
                                                                        else begin
                                                                                ref_trans.res = (ref_trans.opa >> ref_trans.opb[SHIFT_AMOUNT - 1 : 0]) | (ref_trans.opa << (`DATA_WIDTH - ref_trans.opb[SHIFT_AMOUNT - 1 : 0]));
                                                                        end
                                                                end
                                                                default: ref_trans.err = 1;
                                                        endcase
                                                end
                                        end
                                end
                        //end
                end
                mbx_rs.put(ref_trans);
                $display("Time: %0t, Reference op res=%0d, err=%0d, oflow=%0d, cout=%0d, g=%0d, l=%0d, e=%0d",$time, ref_trans.res, ref_trans.err, ref_trans.oflow,ref_trans.cout, ref_trans.g, ref_trans.l, ref_trans.e);
                repeat(1) @(vif.ref_cb);
                end
        endtask
endclass
