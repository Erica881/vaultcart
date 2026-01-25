import { NextRequest, NextResponse } from "next/server";
import { executeProcedure } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware";

export async function DELETE(req: NextRequest) {
  try {
    const { sessionToken } = verifySellerSession(req);
    const { productId } = await req.json();

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 },
      );
    }
    const params = [productId, sessionToken];

    await executeProcedure("usp_DeleteProductSecurely", params);

    return NextResponse.json({
      success: true,
      message: "Product deleted safely",
    });
  } catch (error: any) {
    console.error("Delete Error:", error.message);
    return NextResponse.json({ error: error.message }, { status: 403 });
  }
}
