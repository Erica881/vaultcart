import { NextRequest, NextResponse } from "next/server";
import { executeProcedure } from "@/lib/db"; // Use your MySQL helper
import { verifySellerSession } from "@/lib/auth-middleware";

export async function PUT(req: NextRequest) {
  try {
    // 1. Verify session and extract sessionToken
    const { sessionToken } = verifySellerSession(req);

    // 2. Parse body
    const { productId, name, price, stock } = await req.json();

    // 3. Validation
    if (!productId || !name || isNaN(Number(price))) {
      return NextResponse.json(
        { error: "Missing or invalid required fields" },
        { status: 400 },
      );
    }

    // 4. MySQL Procedure Name
    const procedureName = "usp_UpdateProductSecurely";

    /**
     * 5. Prepare Parameters (Order Matters!)
     * Match: p_ProductID, p_ProductName, p_Price, p_Stock, p_SessionToken
     */
    const params = [
      productId, // p_ProductID (INT)
      name, // p_ProductName (VARCHAR)
      Number(price), // p_Price (DECIMAL)
      Number(stock) || 0, // p_Stock (INT)
      sessionToken, // p_SessionToken (CHAR 36)
    ];

    // 6. Execute
    await executeProcedure(procedureName, params);

    return NextResponse.json({
      success: true,
      message: "Product updated securely",
    });
  } catch (error: any) {
    console.error("Update Error:", error.message);

    // If MySQL SIGNAL throws 'Unauthorized...', it will be caught here
    return NextResponse.json(
      { error: error.message || "Update failed" },
      { status: 403 },
    );
  }
}
