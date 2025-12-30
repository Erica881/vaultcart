import { NextResponse } from "next/server";
import sql from "mssql";

const opsConfig = {
  user: "Vault_Ops_Manager",
  password: "StrongPassword_Ops1!",
  database: "VaultCartDB",
  server: "192.168.245.100",
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  // Adding a short timeout so it doesn't hang
  connectionTimeout: 5000,
};

export async function GET() {
  let pool;
  try {
    // DO NOT use sql.connect(opsConfig) here.
    // Create a NEW pool instance specifically for this request.
    pool = new sql.ConnectionPool(opsConfig);
    await pool.connect();

    const result = await pool
      .request()
      .query("SELECT id, name, email, phone FROM Membership.Customers");

    // Close the connection immediately after use
    await pool.close();

    return NextResponse.json(result.recordset);
  } catch (error: any) {
    console.error("Support API SQL Error:", error.message);
    if (pool) await pool.close();

    // Return an empty array on error so the frontend map() doesn't crash
    return NextResponse.json([], {
      status: 500,
      statusText: error.message,
    });
  }
}
