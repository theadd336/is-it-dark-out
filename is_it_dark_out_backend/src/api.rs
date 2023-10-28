use crate::impls;
pub use crate::impls::Coordinates;

static mut COUNTER: u32 = 0;

pub fn is_it_dark_out(position: Coordinates) -> bool {
    impls::is_it_dark_out(position)
}
