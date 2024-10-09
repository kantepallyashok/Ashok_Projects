#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update the package index
echo "Updating package index..."
sudo yum update -y

# Install any required packages (adjust these to match your application's needs)
echo "Installing required packages..."
sudo yum install -y unzip nodejs npm

# Navigate to the application directory (adjust this path as necessary)
cd /path/to/deployment/directory

# If the artifact is a directory containing a Node.js application
if [ -d "client" ]; then
    echo "Installing frontend dependencies..."
    cd client
    npm install
    npm run build # Assuming you want to build the frontend

    echo "Moving built files to the correct directory..."
    cd ..
    mv client/build /var/www/html/client  # Adjust this path as necessary
fi

if [ -d "server" ]; then
    echo "Installing backend dependencies..."
    cd server
    npm install # Install server dependencies (if applicable)
    
    echo "Starting backend application..."
    nohup node server.js & # Adjust this command to match how you start your backend app
fi

# Post-deployment cleanup if necessary
echo "Cleaning up temporary files..."
rm -rf /path/to/deployment/directory/* # Clean up the deployment directory

echo "Installation completed successfully."
