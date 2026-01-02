import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2 } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware";
import sql from "mssql";

export async function PUT(req: NextRequest) {
  try {
    const { sessionToken } = verifySellerSession(req);
    const { productId, name, price, stock } = await req.json();

    // Verify inputs
    if (!productId || !name || isNaN(price)) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    await executeProcedure2("Catalog.usp_UpdateProductSecurely", [
      { name: "ProductID", type: sql.Int, value: productId },
      { name: "ProductName", type: sql.NVarChar(200), value: name },
      { name: "Price", type: sql.Decimal(18, 2), value: price },
      { name: "Stock", type: sql.Int, value: stock },
      { name: "SessionToken", type: sql.UniqueIdentifier, value: sessionToken },
    ]);

    return NextResponse.json({
      success: true,
      message: "Product updated securely",
    });
  } catch (error: any) {
    console.error("Update Error:", error.message);
    return NextResponse.json({ error: error.message }, { status: 403 });
  }
}
