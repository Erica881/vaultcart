import { NextRequest, NextResponse } from "next/server";
import { executeProcedure2 } from "@/lib/db";
import { verifySellerSession } from "@/lib/auth-middleware";
import sql from "mssql";

export async function POST(req: NextRequest) {
  try {
    const { sessionToken } = verifySellerSession(req);

    await executeProcedure2("Membership.usp_LogoutSeller", [
      { name: "SessionToken", type: sql.UniqueIdentifier, value: sessionToken },
    ]);

    return NextResponse.json({
      success: true,
      message: "Logged out from Vault",
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
