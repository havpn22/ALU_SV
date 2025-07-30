`include "defines.sv"

interface alu_if(input bit clk, reset);
        logic ce, mode;
        logic [`CMD_WIDTH-1:0]cmd;
        logic [`DATA_WIDTH-1:0]opa, opb;
        logic cin;
        logic [1:0] inp_valid;
        logic [`DATA_WIDTH + 1:0]res;
        logic cout, oflow, g, l, e, err;

        clocking drv_cb @(posedge clk);
                default input #0 output #0;
                output ce, mode, cmd, inp_valid, opa, opb, cin;
                input reset;
        endclocking

        clocking mon_cb @(posedge clk);
                default input #0 output #0;
                input ce, mode, cmd, inp_valid, opa, opb, cin, reset, res, cout, oflow, g, l, e, err;
        endclocking

        clocking ref_cb @(posedge clk);
                default input #0 output #0;
                input  ce, mode, cmd, opa, opb, inp_valid, cin;
                output res, cout, oflow, g, l, e, err;
        endclocking

        modport DRV(clocking drv_cb, input reset);
        modport MON(clocking mon_cb);
        modport REF_SB(clocking ref_cb, input reset);

        assert property (@(posedge clk) !$isunknown({ce, mode, cmd, inp_valid, opa, opb, cin}))
                else $error("One or more input signals are X at time %0t", $timee);

        assert property (@(posedge clk) reset |-> (res == 0 && cout == 0 && oflow == 0 && g == 0 && l == 0 && e == 0 && err == 0))
                else $error(" Outputs not cleared during reset at time %0t", $time);

        assert property (@(posedge clk) (!reset && ce) |-> !$isunknown({opa, opb, cmd, mode, cin, inp_valid}))
                else $error(" Invalid inputs after reset at time %0t", $time);

        property ce_stable;
                @(posedge clk) disable iff (reset)
                ce |=> ce;
        endproperty
         assert property (ce_stable)
                else $error(" ce unstable during operation at time %0t", $time);

        logic [3:0] prev_cmd;
        logic prev_mode;
        always_ff @(posedge clk) begin
                if (inp_valid == 2'b10 || inp_valid == 2'b01) begin
                        prev_cmd <= cmd;
                        prev_mode <= mode;
                end
        end

        assert property (@(posedge clk)
                (inp_valid == 2'b11) |-> (cmd == prev_cmd && mode == prev_mode))
                else $error(" cmd/mode changed after inp_valid trigger at %0t", $time);

        property latch_on_disable;
                @(posedge clk) disable iff (reset)
                (!ce) |=> $stable({res, cout, oflow, g, l, e, err});
        endproperty
        assert property (latch_on_disable)
                else $error(" Outputs not latched when ce=0 at time %0t", $time);

        int wait_counter;
        always_ff @(posedge clk or posedge reset) begin
                if (reset) wait_counter <= 0;
                else if (inp_valid == 2'b10 || inp_valid == 2'b01)
                        wait_counter <= 16;
                else if (wait_counter > 0)
                        wait_counter <= wait_counter - 1;
        end

/*      assert property (@(posedge clk)
                (wait_counter != 0) |-> ((inp_valid == 2'b11) or (wait_counter > 1)))
                else $error(" inp_valid != 2'b11 within 16 cycles, error at %0t", $time);

        assert property (@(posedge clk)
                (cmd == 4'd12 || cmd == 4'd13) |=> ##2 !$isunknown({res, cout, oflow, g, l, e, err}))
                else $error("Multiplication outputs not ready after 2 cycles at %0t", $time);

        assert property (@(posedge clk)
                (cmd != 4'd12 && cmd != 4'd13) |=> ##1 !$isunknown({res, cout, oflow, g, l, e, err}))
                else $error(" Outputs not ready after 1 cycle at %0t", $time);
*/
        assert property (@(posedge clk) reset |-> (res == 0 && cout == 0 && oflow == 0 && g == 0 && l == 0 && e == 0 && err == 0))
                else $error(" ALU not idle during reset at time %0t", $time);
endinterface
