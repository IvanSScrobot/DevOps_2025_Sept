# --- Stage 1: Build the application ---
FROM golang:1.23 AS builder

# Set the working directory within the container
WORKDIR /app

# Copy the application source code into the container
COPY . .

# Compile the Go application to a static binary named 'main'
RUN go build -o main .

# --- Stage 2: Create the minimal runtime image ---
FROM alpine:latest AS final

# Install any necessary runtime dependencies (like CA certificates for HTTPS)
RUN apk --no-cache add ca-certificates

# Set the working directory for the final image
WORKDIR /root/

# Copy the *compiled binary only* from the 'builder' stage to the 'final' stage
COPY --from=builder /app/main.go .

# Expose the application port and define the command to run the binary
EXPOSE 8080
CMD ["./main"]