import { NextRequest, NextResponse } from "next/server";
import sql from "mssql";
import { executeQuery } from "@/lib/db";
import jwt from "jsonwebtoken";

export async function POST(request: NextRequest) {
  try {
    const { email, password, role } = await request.json(); // role: 'customer' or 'seller'
    const userAgent = request.headers.get("user-agent") || "unknown";
    // Choose the correct stored procedure based on the login type
    const procedure =
      role === "seller" ? "Membership.LoginSeller" : "Membership.LoginCustomer";

    const params = [
      { name: "Email", type: sql.NVarChar(255), value: email },
      { name: "InputPassword", type: sql.NVarChar(255), value: password },
      { name: "UserAgent", type: sql.NVarChar(500), value: userAgent }, // Required for your session table
    ];

    // Execute the stored procedure defined in your SQL script
    const result = await executeQuery(
      `EXEC ${procedure} @Email, @InputPassword, @UserAgent;`,
      params
    );
    const loginData = result.recordset[0];

    const webToken = jwt.sign(
      { sessionToken: loginData.SessionToken },
      process.env.JWT_SECRET!
    );

    if (loginData && loginData.Status === "SUCCESS") {
      return NextResponse.json(
        {
          success: true,
          // token: loginData.SessionToken, // This GUID is used for RLS
          token: webToken,
          userId: loginData.CustomerID || loginData.SellerID,
          userAgent: userAgent, // Send back to client to store for future requests
        },
        {
          headers: {
            "Cache-Control": "no-store, max-age=0",
            // "Content-Type": "application/json",
          },
        }
      );
    } else {
      return NextResponse.json(
        { success: false, message: "Invalid credentials" },
        { status: 401 }
      );
    }
  } catch (error: any) {
    console.error("Login Error:", error.message);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
