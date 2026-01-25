import { NextRequest, NextResponse } from "next/server";
import { executeProcedure } from "@/lib/db";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "your-secure-secret";

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json();
    const userAgent = request.headers.get("user-agent") || "unknown";

    // Call the Login procedure
    const result: any = await executeProcedure("Membership_LoginSeller", [
      email,
      password,
      userAgent,
    ]);

    const rows = result[0];
    const loginData = rows && rows[0]; // This is the first row { Status: 'SUCCESS', ... }

    console.log("Login Data Received:", loginData);

    // MySQL Result handling
    // const loginData = result[0] && result[0][0];

    if (loginData && loginData.Status === "SUCCESS") {
      // Create a JWT that holds the sessionToken from the DB
      // This is what the frontend will send in the 'Authorization' header
      const webToken = jwt.sign(
        {
          sessionToken: loginData.SessionToken,
          sellerId: loginData.SellerID, // <--- ADD THIS HERE
        },
        JWT_SECRET,
        { expiresIn: "8h" },
      );

      return NextResponse.json({
        success: true,
        token: webToken,
        sellerId: loginData.SellerID,
      });
    } else {
      return NextResponse.json(
        { success: false, message: "Invalid email or password" },
        { status: 401 },
      );
    }
  } catch (error: any) {
    console.error("Login API Error:", error.message);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 },
    );
  }
}
