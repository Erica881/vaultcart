import { NextRequest, NextResponse } from "next/server";
import { executeProcedure } from "@/lib/db";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "your-secure-secret";

export async function POST(request: NextRequest) {
  try {
    // 1. Get the JWT from the Authorization header
    const authHeader = request.headers.get("authorization");
    const token = authHeader?.split(" ")[1];

    if (!token) {
      return NextResponse.json({ error: "No token provided" }, { status: 401 });
    }

    // 2. Decode the JWT to get the DB sessionToken
    const decoded: any = jwt.verify(token, JWT_SECRET);
    const sessionToken = decoded.sessionToken;

    // 3. Call the logout procedure
    const result: any = await executeProcedure("usp_LogoutSeller", [sessionToken]);
    
    const logoutStatus = result[0] && result[0][0];

    if (logoutStatus?.Status === "SUCCESS") {
      return NextResponse.json({ success: true, message: "Logged out successfully" });
    } else {
      return NextResponse.json({ success: false, message: "Logout failed" }, { status: 400 });
    }
  } catch (error: any) {
    console.error("Logout Error:", error.message);
    return NextResponse.json({ error: "Session expired or invalid" }, { status: 401 });
  }
}