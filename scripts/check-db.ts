import { config } from "dotenv";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import { sql } from "drizzle-orm";

import { parseServerEnv } from "../src/lib/env-schema";
import { exams, questions } from "../src/db/schema/exams";

config({ path: ".env.local" });
config({ path: ".env" });

async function main() {
  const env = parseServerEnv(process.env);

  const pool = new Pool({
    connectionString: env.DATABASE_URL,
    max: 1,
    connectionTimeoutMillis: 10_000,
  });

  try {
    const db = drizzle({ client: pool });

    await db.execute(sql`select 1`);

    // These fail if the migration has not created the expected tables.
    await db.select({ id: exams.id }).from(exams).limit(1);
    await db.select({ id: questions.id }).from(questions).limit(1);

    console.log("Environment validation passed.");
    console.log("PostgreSQL connection successful.");
    console.log("Exam and question tables are accessible.");
  } finally {
    await pool.end();
  }
}

main().catch(() => {
  console.error(
    "Database verification failed. Check .env.local, PostgreSQL status, " +
      "and whether migrations were applied.",
  );

  process.exitCode = 1;
});