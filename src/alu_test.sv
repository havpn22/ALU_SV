class alu_test;
        virtual alu_if drv_vif;
        virtual alu_if mon_vif;
        virtual alu_if ref_vif;

        alu_environment env;

        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                this.drv_vif = drv_vif;
                this.mon_vif = mon_vif;
                this.ref_vif = ref_vif;
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;
                env.start;
        endtask
endclass

class alu_test_1 extends alu_test;
        alu_transaction_1 trans1;
        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;
                begin
                        trans1 = new();
                        env.gen.gen_trans = trans1;
                end
                env.start;
        endtask
endclass

class alu_test_2 extends alu_test;
        alu_transaction_2 trans2;
        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;
                begin
                        trans2 = new();
                        env.gen.gen_trans = trans2;
                end
                env.start;
        endtask
endclass

class alu_test_3 extends alu_test;
        alu_transaction_3 trans3;
        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;
                begin
                        trans3 = new();
                        env.gen.gen_trans = trans3;
                end
                env.start;
        endtask
endclass

class alu_test_4 extends alu_test;
        alu_transaction_4 trans4;
        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;
                begin
                        trans4 = new();
                        env.gen.gen_trans = trans4;
                end
                env.start;
        endtask
endclass

class alu_regression extends alu_test;
        alu_transaction trans_0;
        alu_transaction_1 trans_1;
        alu_transaction_2 trans_2;
        alu_transaction_3 trans_3;
        alu_transaction_4 trans_4;

        function new(virtual alu_if drv_vif, virtual alu_if mon_vif, virtual alu_if ref_vif);
                super.new(drv_vif, mon_vif, ref_vif);
        endfunction

        task run();
                env = new(drv_vif, mon_vif, ref_vif);
                env.build;

                begin
                        trans_0 = new();
                        env.gen.gen_trans = trans_0;
                end
                env.start;

                begin
                        trans_1 = new();
                        env.gen.gen_trans = trans_1;
                end
                env.start;

                begin
                        trans_2 = new();
                        env.gen.gen_trans = trans_2;
                end
                env.start;

                begin
                        trans_3 = new();
                        env.gen.gen_trans = trans_3;
                end
                env.start;

                begin
                        trans_4 = new();
                        env.gen.gen_trans = trans_4;
                end
                env.start;
        endtask
endclass
