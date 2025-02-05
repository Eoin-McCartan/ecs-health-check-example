import express, {Request, Response} from "express";
import os from "os";

interface HealthCheckResponse {
  status: "OK" | "ERROR";
  timestamp: string;
  uptime: number;
  memory: {
    total: number;
    free: number;
    used: number;
  };
  cpu: {
    loadAvg: number[];
  };
}

const app = express();

app.get("/healthcheck", async (req: Request, res: Response<HealthCheckResponse>) => {
  try {
    const totalMemory = os.totalmem();
    const freeMemory = os.freemem();

    const healthcheck: HealthCheckResponse = {
      status: "OK",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: {
        total: Math.round(totalMemory / 1024 / 1024), // Convert to MB
        free: Math.round(freeMemory / 1024 / 1024), // Convert to MB
        used: Math.round((totalMemory - freeMemory) / 1024 / 1024),
      },
      cpu: {
        loadAvg: os.loadavg(),
      },
    };

    res.status(200).json(healthcheck);
  } catch (error) {
    res.status(503).json({
      status: "ERROR",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: {
        total: 0,
        free: 0,
        used: 0,
      },
      cpu: {
        loadAvg: [],
      },
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
