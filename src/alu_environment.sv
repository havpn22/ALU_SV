`include "defines.sv"
//`include "package.sv"

class alu_environment;
        virtual alu_if drv_vif;
        virtual alu_if mon_vif;
        virtual alu_if ref_vif;

        mailbox #(alu_transaction) mbx_gd;
        mailbox #(alu_transaction) mbx_dr;
        mailbox #(alu_transaction) mbx_ms;
        mailbox #(alu_transaction) mbx_rs;

        alu_generator gen;
        alu_driver drv;
        alu_monitor mon;
        alu_reference ref_sb;
        alu_scoreboard scb;

        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                this.drv_vif = drv_vif;
                this.mon_vif = mon_vif;
                this.ref_vif = ref_vif;
        endfunction

        task build();
                begin
                        mbx_gd = new();
                        mbx_dr = new();
                        mbx_rs = new();
                        mbx_ms = new();

                        gen = new(mbx_gd);
                        drv = new(mbx_gd, mbx_dr, drv_vif);
                        mon = new(mon_vif, mbx_ms);
                        ref_sb = new(mbx_dr, mbx_rs, ref_vif);
                        scb = new(mbx_rs, mbx_ms);
                end
        endtask

        task start();
                fork
                        gen.start();
                        drv.start();
                        mon.start();
                        scb.start();
                        ref_sb.start();
                join

                scb.compare_report();
        endtask
endclass
