import { z } from "zod";

const httpUrl = z
  .string()
  .url()
  .refine(
    (value) => {
      const protocol = new URL(value).protocol;

      return protocol === "http:" || protocol === "https:";
    },
    {
      message: "Must be an HTTP or HTTPS URL.",
    },
  );

const postgresUrl = z
  .string()
  .url()
  .refine(
    (value) => {
      const protocol = new URL(value).protocol;

      return protocol === "postgres:" || protocol === "postgresql:";
    },
    {
      message: "Must be a PostgreSQL connection URL.",
    },
  );

const serverEnvSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),

  DATABASE_URL: postgresUrl,

  NEXT_PUBLIC_APP_URL: httpUrl,
  BETTER_AUTH_URL: httpUrl,
  BETTER_AUTH_SECRET: z.string().min(32),
});

export type ServerEnv = z.infer<typeof serverEnvSchema>;

export function parseServerEnv(
  input: Record<string, string | undefined>,
): ServerEnv {
  const result = serverEnvSchema.safeParse(input);

  if (!result.success) {
    const fields = [
      ...new Set(
        result.error.issues.map((issue) => issue.path.join(".")),
      ),
    ];

    // Report field names without exposing passwords or secrets.
    throw new Error(
      `Invalid or missing environment variables: ${fields.join(", ")}. ` +
        "Check your environment configuration.",
    );
  }

  return result.data;
}