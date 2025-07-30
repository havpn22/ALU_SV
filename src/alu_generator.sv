`include "defines.sv"
//`include "transaction.sv"

class alu_generator;
        alu_transaction gen_trans;
        mailbox #(alu_transaction) mbx_gd;

        function new(mailbox #(alu_transaction)mbx_gd);
                this.mbx_gd = mbx_gd;
                gen_trans = new();
        endfunction

        task start();
                for(int i = 0; i < `no_of_trans; i++)
                        begin
                                void'(gen_trans.randomize());
                                mbx_gd.put(gen_trans.copy());
                                $display("Time: %0t, GENERATOR RANDOMISED TRANSACTION: ce = %0d, mode = %0d, cmd = %0d, inp_valid = %0d, opa = %0d, opb = %0d, cin = %0d", $time,gen_trans.ce, gen_trans.mode, gen_trans.cmd, gen_trans.inp_valid, gen_trans.opa, gen_trans.opb, gen_trans.cin);
                        end
        endtask
endclass
