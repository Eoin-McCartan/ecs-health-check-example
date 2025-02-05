# ECS Health Check Example

A minimal Node.js server for testing AWS ECS deployments (Fargate/EC2) on Windows environments. Provides a basic health
check endpoint to validate container functionality.

## Installation

- Install Node.js v18+ for Windows
- Clone repository:

```bash
git clone https://github.com/eoin-mccartan/ecs-health-check-example.git
```

- Install dependencies:

```bash
npm install
```

## Usage

```bash
npm start
```

Server runs on port 3000 with health check endpoint:

```bash
curl http://localhost:3000/health
# Returns: {"status":"ok","timestamp":"2025-02-05T09:00:00.000Z"}
```

## Deployment

Configure for AWS ECS with:

- Windows Server 2019 Core container
- Task definition exposing port 3000
- Health check route configured in target group
- Fargate/EC2 launch type based on testing needs
