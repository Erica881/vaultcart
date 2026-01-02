import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2 } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware";
import sql from "mssql";

export async function DELETE(req: NextRequest) {
  try {
    const { sessionToken } = verifySellerSession(req);
    const { productId } = await req.json();

    await executeProcedure2("Catalog.usp_DeleteProductSecurely", [
      { name: "ProductID", type: sql.Int, value: productId },
      { name: "SessionToken", type: sql.UniqueIdentifier, value: sessionToken },
    ]);

    return NextResponse.json({ success: true });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 403 });
  }
}
