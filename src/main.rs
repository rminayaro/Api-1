extern crate rusqlite;
extern crate warp;

use warp::Filter;

mod routes;
mod models;
mod db;

#[tokio::main]
async fn main() {
    let db_path = "C:/Users/rmina/OneDrive/Documents/sqlite/InventarioRopa.db";

    // Combina todas las rutas
    let usuarios_routes = routes::usuarios::routes(db_path);
    let categorias_routes = routes::categorias::routes(db_path);

    let routes = usuarios_routes.or(categorias_routes); // Combina las rutas

    warp::serve(routes).run(([127, 0, 0, 1], 3030)).await;
}