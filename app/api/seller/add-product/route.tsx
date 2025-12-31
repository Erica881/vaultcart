// import { NextRequest, NextResponse } from "next/server";
// import sql from "mssql";
// import { executeSecureQuery } from "@/lib/db";

// export async function POST(request: NextRequest) {
//   try {
//     const { name, price, stock } = await request.json();

//     // Extract Security Context from Headers
//     const authHeader = request.headers.get("authorization");
//     const sessionToken = authHeader?.replace("Bearer ", "");
//     const userAgent = request.headers.get("x-user-agent") || "unknown";

//     if (!sessionToken) {
//       return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
//     }

//     // According to your doc, we must use Catalog schema.
//     // The RLS policy will ensure this product is tied to the current seller session.
//     const query = `
//       INSERT INTO Catalog.Products (name, price, stock_qty, status)
//       VALUES (@Name, @Price, @Stock, 'available');
//       SELECT SCOPE_IDENTITY() as ProductID;
//     `;

//     const params = [
//       { name: "Name", type: sql.NVarChar(255), value: name },
//       { name: "Price", type: sql.Decimal(10, 2), value: parseFloat(price) },
//       { name: "Stock", type: sql.Int, value: parseInt(stock) },
//     ];

//     const result = await executeSecureQuery(
//       query,
//       sessionToken,
//       userAgent,
//       params
//     );

//     return NextResponse.json({
//       success: true,
//       productId: result.recordset[0].ProductID,
//     });
//   } catch (error: any) {
//     console.error("Add Product Error:", error.message);
//     return NextResponse.json({ error: error.message }, { status: 500 });
//   }
// }

import { NextRequest, NextResponse } from "next/server";
import sql from "mssql";
import { executeSecureQuery } from "@/lib/db";

export async function POST(request: NextRequest) {
  try {
    const { name, price, stock } = await request.json();

    const authHeader = request.headers.get("authorization");
    const sessionToken = authHeader?.replace("Bearer ", "");
    const userAgent = request.headers.get("x-user-agent") || "unknown";

    if (!sessionToken)
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

    // FIX: Using the exact Parameter Names from your Store Procedure
    // Note: We don't pass SellerID because the DB gets it from SESSION_CONTEXT
    const query = `EXEC Catalog.UpdateStock 
                   @ProductName = @name, 
                   @Price = @price, 
                   @StockQuantity = @stock`;

    const params = [
      { name: "name", type: sql.NVarChar(255), value: name },
      { name: "price", type: sql.Decimal(10, 2), value: parseFloat(price) },
      { name: "stock", type: sql.Int, value: parseInt(stock) },
    ];

    const result = await executeSecureQuery(
      query,
      sessionToken,
      userAgent,
      params
    );

    return NextResponse.json({
      success: true,
      message: "Product added via Signed Procedure",
      productId: result.recordset[0]?.ProductID,
    });
  } catch (error: any) {
    console.error("Add Product Error:", error.message);
    // If it still fails, it's likely a permission issue with the AppUser role
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
