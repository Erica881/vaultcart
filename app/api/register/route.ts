import { NextRequest, NextResponse } from "next/server";
import sql from "mssql";
import { executeQuery } from "@/lib/db";

export async function POST(request: NextRequest) {
  try {
    const { name, email, password, phone, role, address } =
      await request.json();

    // Differentiate the Procedure based on the role
    const procedureName =
      role === "seller"
        ? "Membership.RegisterSeller"
        : "Membership.RegisterCustomer";

    // IMPORTANT: Parameter names MUST match the @Variables in your SQL Procedure
    const params = [
      { name: "Name", type: sql.NVarChar(100), value: name },
      { name: "Email", type: sql.NVarChar(255), value: email },
      { name: "Phone", type: sql.NVarChar(20), value: phone || null },
      {
        name: "Address",
        type: sql.NVarChar(sql.MAX),
        value: address || "No Address Provided",
      },
      { name: "PlainPassword", type: sql.NVarChar(100), value: password },
    ];

    // Call the procedure.
    // The Database handles hashing/salting internally as per your T-SQL logic.
    await executeQuery(
      `EXEC ${procedureName} @Name, @Email, @Phone, @Address, @PlainPassword`,
      params
    );

    return NextResponse.json({
      success: true,
      message: `${role} registered successfully`,
    });
  } catch (error: any) {
    console.error("Registration Error:", error.message);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
