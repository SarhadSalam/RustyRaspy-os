global_asm!(include_str!("cpu.S"));

// Function is a diverging function, never returns. Therefore it waits forever.

#[inline(always)]
pub fn wait_forever() -> ! {
    unsafe {
        loop {
            llvm_asm!("wfe"
            :   //output
            :   //input
            :   //clobbers
            :   "volatile") // options
        }
    }
}
