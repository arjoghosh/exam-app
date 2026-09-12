export const runtime = "nodejs";
export const dynamic = "force-dynamic";

export function GET() {
  return Response.json(
    {
      error: {
        code: "REPORTS_NOT_CONFIGURED",
        message: "PDF report generation has not been configured.",
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
