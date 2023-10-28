use chrono::{Datelike, Local};
use sunrise::sunrise_sunset;

pub struct Coordinates {
    pub latitude: f64,
    pub longitude: f64,
}

pub fn is_it_dark_out(position: Coordinates) -> bool {
    let now = Local::now();
    let (sunrise, sunset) = sunrise_sunset(
        position.longitude,
        position.latitude,
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
