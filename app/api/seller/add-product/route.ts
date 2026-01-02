import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2, executeSecureQuery } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware"; // Adjust path to where your helper is
import sql, { query } from "mssql";

export async function POST(req: NextRequest) {
  try {
    const decoded = verifySellerSession(req);
    const { sessionToken } = decoded; // This must be the GUID string

    const userAgent = req.headers.get("user-agent") || "unknown"; // Use standard header name

    const { name, price, stock } = await req.json();

    if (!name || isNaN(Number(price))) {
      return NextResponse.json(
        { error: "Invalid product data" },
        { status: 400 }
      );
    }

    const procedureName = "Catalog.usp_AddProductSecurely";

    // FIX: Match the SQL Procedure parameter names exactly
    await executeProcedure2(procedureName, [
      { name: "ProductName", type: sql.NVarChar(200), value: name },
      { name: "Price", type: sql.Decimal(18, 2), value: Number(price) },
      { name: "Stock", type: sql.Int, value: Number(stock) },
      { name: "SessionToken", type: sql.UniqueIdentifier, value: sessionToken }, // ADDED
      { name: "UserAgent", type: sql.NVarChar(500), value: userAgent }, // ADDED
    ]);

    return NextResponse.json({
      success: true,
      message: "Product listed securely",
    });
  } catch (error: any) {
    console.error("Vault Execution Failure:", error.message);

    // Handle JWT expiration specifically
    if (error.message.includes("expired")) {
      return NextResponse.json({ error: "Session expired" }, { status: 401 });
    }

    return NextResponse.json(
      { error: error.message || "Vault rejection" },
      { status: 403 }
    );
  }
}
