import { NextRequest, NextResponse } from "next/server";
import jwt from "jsonwebtoken";
import { executeSecureQuery } from "@/lib/db";

const JWT_SECRET = process.env.JWT_SECRET || "your-secure-secret";

export async function GET(req: NextRequest) {
  try {
    const authHeader = req.headers.get("authorization");
    const token = authHeader?.split(" ")[1];

    // Check if token is physically present and looks like a JWT (3 parts separated by dots)
    if (!token || token.split(".").length !== 3) {
      console.error("Malformed or Missing Token String:", token);
      return NextResponse.json(
        { error: "Invalid token format" },
        { status: 401 }
      );
    }

    const decoded = jwt.verify(token, JWT_SECRET) as { sessionToken: string };
    const agent = req.headers.get("x-user-agent") || "unknown";

    // This calls your utility which sets the RLS context first
    const result = await executeSecureQuery(
      "SELECT id, name, price, stock_qty FROM Catalog.Products",
      decoded.sessionToken,
      agent,
      []
    );

    return NextResponse.json(result.recordset);
  } catch (error: any) {
    console.error("Inventory Fetch Error:", error);
    // Always return a JSON array on error to prevent frontend crash
    return NextResponse.json([], { status: 500 });
  }
}
