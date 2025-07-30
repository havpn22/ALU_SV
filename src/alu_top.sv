`include "alu_pkg.sv"
`include "alu_interface.sv"
`include "alu_design.v"

module top();
        import alu_pkg ::*;

        bit clk;
        bit reset;

        initial begin
                clk = 0;
                forever #5 clk = ~clk;
        end

        initial begin
                @(posedge clk);
                reset = 1;
                repeat(1) @(posedge clk);
                reset = 0;
        end

        alu_if intrf(clk, reset);

        ALU_DESIGN DUV(.CE(intrf.ce),
                .MODE(intrf.mode),
                .CMD(intrf.cmd),
                .OPA(intrf.opa),
                .OPB(intrf.opb),
                .CIN(intrf.cin),
                .INP_VALID(intrf.inp_valid),
                .RES(intrf.res),
                .COUT(intrf.cout),
                .OFLOW(intrf.oflow),
                .G(intrf.g),
                .L(intrf.l),
                .E(intrf.e),
                .ERR(intrf.err),
                .CLK(clk),
                .RST(reset)
                );


        //alu_test tb = new(intrf.DRV, intrf.MON, intrf.REF_SB);
        alu_test tb;
        alu_test_1 tb1;
        alu_test_2 tb2;
        alu_test_3 tb3;
        alu_test_4 tb4;
        alu_regression tb5;
        initial begin
                tb = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                tb1 = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                tb2 = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                tb3 = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                tb4 = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                tb5 = new(intrf.DRV, intrf.MON, intrf.REF_SB);
                //tb.run();
                //tb1.run();
                //tb2.run();
                //tb3.run();
                //tb4.run();
                tb5.run();
                $finish;
        end
endmodule
