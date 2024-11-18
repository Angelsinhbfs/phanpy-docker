FROM node:18-alpine AS build

# Install Git
RUN apk add --no-cache git

# Set the working directory inside the container
WORKDIR /app

# Define build-time arguments
ARG PHANPY_CLIENT_NAME
ARG PHANPY_DEFAULT_INSTANCE
ARG PHANPY_DEFAULT_INSTANCE_REGISTRATION_URL
ARG PHANPY_WEBSITE

# Set environment variables using the build-time arguments
ENV PHANPY_DEFAULT_INSTANCE=$PHANPY_DEFAULT_INSTANCE
# ENV PHANPY_DEFAULT_INSTANCE_REGISTRATION_URL=$PHANPY_DEFAULT_INSTANCE_REGISTRATION_URL
ENV PHANPY_WEBSITE=$PHANPY_WEBSITE
ENV PHANPY_CLIENT_NAME=$PHANPY_CLIENT_NAME

# Clone the 'production' branch of the repository
RUN git clone --branch production https://github.com/cheeaun/phanpy.git .

# Install the application dependencies
RUN npm install

# Build the application
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:alpine

# Copy the built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the port the app runs on (if known, otherwise adjust accordingly)
EXPOSE 80

# Command to run the application
CMD ["nginx", "-g", "daemon off;"]
