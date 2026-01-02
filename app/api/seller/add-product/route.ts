import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2, executeSecureQuery } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware"; // Adjust path to where your helper is
import sql, { query } from "mssql";

export async function POST(req: NextRequest) {
  try {
    // 1. Decode the JWT and get the REAL sessionToken (GUID)
    // This helper validates the signature and expiration first.
    const decoded = verifySellerSession(req);
    const { sessionToken } = decoded;

    // 2. Get the User Agent for the Audit Log
    const userAgent = req.headers.get("x-user-agent") || "unknown";

    // 3. Parse and Validate Request Body
    const { name, price, stock } = await req.json();

    if (!name || isNaN(Number(price))) {
      return NextResponse.json(
        { error: "Invalid product data" },
        { status: 400 }
      );
    }
    const procedureName = "Catalog.usp_AddProductSecurely";

    // 4. Execute Procedure using the extracted GUID
    await executeProcedure2(
      procedureName,
      [
        { name: "ProductName", type: sql.NVarChar(200), value: name },
        { name: "Price", type: sql.Decimal(18, 2), value: Number(price) },
        { name: "Stock", type: sql.Int, value: Number(stock) },
      ],
      sessionToken,
      userAgent
    );

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
