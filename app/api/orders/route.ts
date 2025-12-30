// app/api/orders/route.ts
import { NextRequest, NextResponse } from "next/server";
import { executeWithRLS } from "@/lib/db";

export async function GET(request: NextRequest) {
  const sessionToken = request.headers.get("x-session-token");
  const userAgent = request.headers.get("user-agent") || "unknown";

  if (!sessionToken) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const query = "SELECT * FROM Sales.Orders";
  const result = await executeWithRLS(sessionToken, userAgent, query);

  return NextResponse.json(result.recordset);
}
