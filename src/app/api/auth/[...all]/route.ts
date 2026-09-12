export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function unavailable() {
  return Response.json(
    {
      error: {
        code: "AUTH_NOT_CONFIGURED",
        message: "Authentication has not been configured.",
      },
    },
    {
      status: 501,
      headers: {
        "Cache-Control": "no-store",
      },
    },
  );
}

export function GET() {
  return unavailable();
}

export function POST() {
  return unavailable();
}
