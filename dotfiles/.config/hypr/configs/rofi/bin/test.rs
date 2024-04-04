#!/usr/bin/env cached-nix-shell
//! ```cargo
//! [dependencies]
//! clap = { version = "4.5.4", features = ["derive"] }
//! image = "0.25.1"
//! glob = "0.3.1"
//! ```

/*
#!nix-shell -i rust-script -p rustc -p rust-script -p cargo
*/

use clap::Parser;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[clap(short, long, help = "Path to config")]
    config: Option<std::path::PathBuf>,
}

fn main() {
    let args = Args::parse();
    println!("{:?}", args);
}
