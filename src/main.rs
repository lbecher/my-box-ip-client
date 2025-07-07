use reqwest::Client;
use serde::{Deserialize, Serialize};
use std::net::UdpSocket;
use std::time::Duration;

#[derive(Serialize, Deserialize)]
pub struct Data {
    pub hostname: String,
    pub ip: String,
}

fn get_ip() -> String {
    let socket = UdpSocket::bind("0.0.0.0:0").unwrap();
    socket.connect("8.8.8.8:80").unwrap();
    socket.local_addr().unwrap().ip().to_string()
}

fn get_hostname() -> String {
    hostname::get()
        .ok()
        .and_then(|h| h.into_string().ok())
        .unwrap_or_else(|| "Unknown hostname...".to_string())
}

#[tokio::main]
async fn main() {
    let server =
        std::env::var("SERVER_ADDR").expect("failed to get SERVER_ADDR environment variable");

    let hostname = get_hostname();
    let ip = get_ip();

    let data = Data { hostname, ip };

    let client = Client::builder()
        .timeout(Duration::from_secs(10))
        .build()
        .unwrap();

    let endpoint = format!("http://{}/report-ip", server);
    if let Err(err) = client.post(&endpoint).json(&data).send().await {
        eprintln!("Error sending data to server: {}", err);
    }
}
