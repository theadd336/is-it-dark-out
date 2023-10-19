mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
use chrono::{Datelike, Local};
use sunrise::sunrise_sunset;
mod api;

struct Coordinates {
    latitude: f64,
    longitude: f64,
}

#[cfg(target_os = "android")]
fn get_coordinates_impl() -> Coordinates {
    Coordinates {
        latitude: 0.0,
        longitude: 0.0,
    }
}

#[cfg(target_os = "ios")]
fn get_coordinates_impl() -> Coordinates {}

#[cfg(not(any(target_os = "ios", target_os = "android")))]
/// Stub for testing
fn get_coordinates_impl() -> Coordinates {
    Coordinates {
        latitude: 0.0,
        longitude: 0.0,
    }
}

fn get_latitude_and_longitude() -> Coordinates {
    get_coordinates_impl()
}

pub fn is_it_dark_out() -> bool {
    let now = Local::now();
    let coordinates = get_latitude_and_longitude();
    let (sunrise, sunset) = sunrise_sunset(
        coordinates.longitude,
        coordinates.latitude,
        now.year(),
        now.month(),
        now.day(),
    );
    let now_timestamp = now.timestamp();
    if sunrise <= now_timestamp && now_timestamp < sunset {
        true
    } else {
        false
    }
}
