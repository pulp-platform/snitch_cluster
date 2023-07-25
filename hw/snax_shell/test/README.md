# Workbench tests

These files are meant for prototyping and testing the snax shell. They were built by the authors for testing out the SNAX shell prototypes. For questions, please ask the original authors through email.

## Directory descriptions
- `/do` contains the do files for waveform display using modelsim. Currently available for model sim only for now.
- `/mem` contains the memory generated binaries. As of now we have:
    - `/mem/inst` for instruction binaries in hex (text file)
    - `/mem/data` for data binaries in hex (text file)
    - `/mem/asm` contains the sample assembly instructions
    - `/mem/basic_assembler.py` is a naive assembler that converts an assembly file under `/mem/asm` into its `/mem/inst` instruction equivalent in hex. Usage is simply 
``` bash
python basic_assembler.py <name_of_file without the .s>
```
- `/tb` contains the test bench used
    - The testbench is naive but should be able to serve as a sufficient guide on how to understand the snitch cluster or snax shell
    - Take note that you can change the respective memories inside the test bench.
- `snax_shell.f` - is the reduced filelist of the necessary files that are needed to run the snax shell. It's reduced because the original bender extract imports also all other modules that are not necessary.
## How to use sample tests?
 - The test benches were made using modelsim, please edit accordingly if you are using other simulators. Ideally, the testbench was built to be simulator agnostic.

 1. Create your own assembly code and store it in `/asm` directory. See examples in the same directory.
 2. Generate instruction binary in hex (text file) using the python command above.
 3. Inside the `tb_snax_shell_wb.sv` testbench, modify the instruction memory and data memory.
 4. Compile and run in model sim.
 5. Use the `/do/snax_base.do` file to display pre-existing waves. Or you could just modify it yourself.