static mut COUNTER: u32 = 0;

pub fn is_it_dark_out() -> Result<bool, String> {
    unsafe {
        COUNTER += 1;
        if COUNTER % 2 == 0 {
            Ok(false)
        } else {
            Ok(true)
        }
    }
}
