use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_is_it_dark_out(port_: i64, position: *mut wire_Coordinates) {
    wire_is_it_dark_out_impl(port_, position)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_coordinates_0() -> *mut wire_Coordinates {
    support::new_leak_box_ptr(wire_Coordinates::new_with_null_ptr())
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<Coordinates> for *mut wire_Coordinates {
    fn wire2api(self) -> Coordinates {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Coordinates>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Coordinates> for wire_Coordinates {
    fn wire2api(self) -> Coordinates {
        Coordinates {
            latitude: self.latitude.wire2api(),
            longitude: self.longitude.wire2api(),
        }
    }
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_Coordinates {
    latitude: f64,
    longitude: f64,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_Coordinates {
    fn new_with_null_ptr() -> Self {
        Self {
            latitude: Default::default(),
            longitude: Default::default(),
        }
    }
}

impl Default for wire_Coordinates {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
