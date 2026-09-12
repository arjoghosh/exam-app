import { config } from "dotenv";
import { defineConfig } from "drizzle-kit";

config({ path: ".env.local" });
config({ path: ".env" });

const databaseUrl = process.env.DATABASE_URL;

export default defineConfig({
  dialect: "postgresql",
  schema: "./src/db/schema/**/*.ts",
  out: "./drizzle",
  ...(databaseUrl
    ? {
        dbCredentials: {
          url: databaseUrl,
        },
      }
    : {}),
  strict: true,
  verbose: true,
});
