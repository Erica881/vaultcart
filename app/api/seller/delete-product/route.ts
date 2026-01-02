import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2 } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware";
import sql from "mssql";

export async function DELETE(req: NextRequest) {
  try {
    const { sessionToken } = verifySellerSession(req);
    const { productId } = await req.json();

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    await executeProcedure2("Catalog.usp_DeleteProductSecurely", [
      { name: "ProductID", type: sql.Int, value: Number(productId) },
      { name: "SessionToken", type: sql.UniqueIdentifier, value: sessionToken },
    ]);

    return NextResponse.json({
      success: true,
      message: "Product deleted safely",
    });
  } catch (error: any) {
    console.error("Delete Error:", error.message);
    return NextResponse.json({ error: error.message }, { status: 403 });
  }
}
