`include "defines.sv"
//`include "transaction.sv"

class alu_scoreboard;
        alu_transaction ref2sb_trans, mon2sb_trans;

        mailbox #(alu_transaction) mbx_rs;
        mailbox #(alu_transaction)mbx_ms;

        function new(mailbox #(alu_transaction) mbx_rs, mailbox #(alu_transaction) mbx_ms);
                this.mbx_rs = mbx_rs;
                this.mbx_ms = mbx_ms;
        endfunction

        task start();
                int fail = 0;
                int match = 0;
                $display("Monitor packets: %0d", mbx_ms.num());
                $display("---------------------------------------------------------------------------------------------------------------");
                for(int i = 0; i < `no_of_trans; i++)
                begin
                        ref2sb_trans = new();
                        mon2sb_trans = new();
                        fork
                                mbx_rs.get(ref2sb_trans);
                                mbx_ms.get(mon2sb_trans);
                        join
                        $display("------------------------------!!!SCOREBOARD!!!--------------------------------------------------");
                        $display("Time: %0t, Reference model data: res = %0d, cout = %0d, oflow = %0d, e = %0d, g = %0d, l = %d, err = %0d", $time, ref2sb_trans.res, ref2sb_trans.cout, ref2sb_trans.oflow, ref2sb_trans.e, ref2sb_trans.g, ref2sb_trans.l, ref2sb_trans.e);
                        $display("Time: %0t, Monitor data: res = %0d, cout = %0d, oflow = %0d, e = %0d, g = %0d, l = %0d, err = %0d", $time, mon2sb_trans.res, mon2sb_trans.cout, mon2sb_trans.oflow, mon2sb_trans.e, mon2sb_trans.g, mon2sb_trans.l, mon2sb_trans.err);
                        if(compare_report())begin
                                $display("Pass");
                                $display("--------------------------------------------------------------------------------------------------");
                                $display("\n");
                                match++;
                        end
                        else begin
                                $display("Fail");
                                $display("---------------------------------------------------------------------------------------------------");
                                $display("\n");
                                fail++;
                        end
                end
                $display("--------------------------------------------------------------------------------------------------------------");
                $display("Total number of matches: %0d", match);
                $display("Total number of failures: %0d", fail);
                $display("--------------------------------------------------------------------------------------------------------------");
        endtask

        function compare_report();
                if(ref2sb_trans.res === mon2sb_trans.res &&
                        ref2sb_trans.cout === mon2sb_trans.cout &&
                                ref2sb_trans.oflow === mon2sb_trans.oflow &&
                                        ref2sb_trans.g === mon2sb_trans.g &&
                                                ref2sb_trans.l  === mon2sb_trans.l &&
                                                        ref2sb_trans.e === mon2sb_trans.e &&
                                                                ref2sb_trans.err === mon2sb_trans.err) begin
                        return 1;
                end
                else
                        return 0;
        endfunction
endclass
