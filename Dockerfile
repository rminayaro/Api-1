# Builder stage
FROM rust:latest as builder

WORKDIR /usr/src/app

# Copiar el código fuente al contenedor
COPY . .

# Actualizar las dependencias y compilar
RUN cargo update && cargo build --release

# Verificar que el archivo binario se ha compilado correctamente
RUN ls -la /usr/src/app/target/release/

# Runtime stage
FROM debian:bookworm-slim

# Instalar las dependencias en tiempo de ejecución
RUN apt-get update && apt-get install -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

# Crear el directorio de destino si no existe
RUN mkdir -p /usr/local/bin

WORKDIR /usr/local/bin

# Verificar el contenido del directorio de destino antes de copiar
RUN ls -la /usr/local/bin

# Copiar el archivo binario compilado desde la etapa de construcción
COPY --from=builder /usr/src/app/target/release/dblite_app .

# Verificar el contenido del directorio de destino después de copiar
RUN ls -la /usr/local/bin

# Exponer el puerto en el que tu aplicación escucha
EXPOSE 8081

# Ejecutar el binario
CMD ["./dblite_app"]
