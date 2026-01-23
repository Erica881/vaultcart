import { NextRequest, NextResponse } from "next/server";
import { executeProcedure } from "@/lib/db"; // Use the executeProcedure we built earlier
import { verifySellerSession } from "@/lib/auth-middleware";

export async function POST(req: NextRequest) {
  try {
    // 1. Verify JWT and extract session data
    // Ensure verifySellerSession returns { sellerId, sessionToken }
    const decoded = verifySellerSession(req);
    const { sellerId, sessionToken } = decoded;
    // DEBUG: Log these to your terminal to see which one is undefined
    console.log("DEBUG - sellerId:", sellerId);
    console.log("DEBUG - sessionToken:", sessionToken);

    const { name, price, stock } = await req.json();

    // 2. Validation
    if (!name || isNaN(Number(price))) {
      return NextResponse.json(
        { error: "Invalid product data" },
        { status: 400 },
      );
    }

    // 3. Define MySQL Procedure Name
    // Note: Match the casing exactly as it appears in MySQL Workbench
    // const procedureName = "Catalog_usp_AddProductSecurely";

    /**
     * 4. Prepare Parameters for MySQL
     * Order must match: p_SellerID, p_Name, p_Price, p_Stock, p_SessionToken
     */
    const params = [
      sellerId, // p_SellerID (INT)
      name, // p_Name (VARCHAR)
      Number(price), // p_Price (DECIMAL)
      Number(stock) || 0, // p_Stock (INT)
      sessionToken, // p_SessionToken (VARCHAR)
    ];

    // 5. Execute using your MySQL helper
    const result: any = await executeProcedure(
      "Catalog_usp_AddProductSecurely",
      params,
    );
    return NextResponse.json({
      success: true,
      message: "Product listed securely",
      data: result[0], // Returns any SELECT result from the procedure
    });
  } catch (error: any) {
    console.error("MySQL Execution Failure:", error.message);

    if (error.message.includes("expired") || error.message.includes("JWT")) {
      return NextResponse.json({ error: "Session expired" }, { status: 401 });
    }

    // Handle MySQL SIGNAL errors (like if the session is invalid)
    return NextResponse.json(
      { error: error.message || "Vault rejection" },
      { status: 403 },
    );
  }
}
