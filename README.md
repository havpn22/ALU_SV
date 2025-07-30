# ALU Verification

**PROJECT OVERVIEW :**
The ALU Verification project aims to test and validate a parameterized Arithmetic Logic Unit (ALU) using a SystemVerilog based testbench. The ALU supports various arithmetic and logical operations along with various flags. A constrained randomisation, coverage group is used along with components like generator, driver, monitor and scoreboard to stimulate and check the DUT. Functional and code coverage are used for testing.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

**VERIFICATION OBJECTIVES**
1.	To ensure that the ALU performs all arithmetic, logical and shift operations correctly.
2.	To verify that the output of the ALU matches the expected result for each operation.
3.	To check that status flags such as carry, overflow, zero, equal, greater and less are generated correctly.
4.	To test the ALU with a wide range of input values, including both normal and boundary cases.
5.	To use assertions and checks to catch unexpected or incorrect behaviour during simulation.
6.	To achieve sufficient functional and code coverage to ensure complete verification.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

**ALU TESTBENCH ARCHITECTURE**
<img width="785" height="632" alt="image" src="https://github.com/user-attachments/assets/d97e93df-7e34-4697-b09d-86d096aa7e56" />
