import type { NextApiRequest, NextApiResponse } from "next";
import sql from "mssql";
import jwt from "jsonwebtoken";
import { executeProcedure } from "@/lib/db"; // Your provided utility

const JWT_SECRET = process.env.JWT_SECRET || "your-secure-secret";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  // 1. Only allow POST requests
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  try {
    // 2. Extract and Verify the JWT
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
      return res.status(401).json({ error: "Unauthorized: No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, JWT_SECRET) as { sessionToken: string };

    // 3. Extract Form Data
    const { name, price, stock } = req.body;
    const userAgent = req.headers["user-agent"] || "unknown";

    // 4. Prepare Parameters for the Secure Stored Procedure
    // We use the sessionToken from the DECODED JWT, not the request body!
    const params = [
      { name: "ProductName", type: sql.NVarChar(200), value: name },
      { name: "Price", type: sql.Decimal(18, 2), value: parseFloat(price) },
      { name: "Stock", type: sql.Int, value: parseInt(stock) },
      {
        name: "SessionToken",
        type: sql.UniqueIdentifier,
        value: decoded.sessionToken,
      },
      { name: "UserAgent", type: sql.NVarChar(500), value: userAgent },
    ];

    // 5. Execute the Procedure
    // This triggers sp_set_session_context inside SQL Server for RLS
    await executeProcedure("Catalog.usp_AddProductSecurely", params);

    return res.status(200).json({ message: "Product listed securely." });
  } catch (error: any) {
    console.error("Add Product Error:", error);

    if (error.name === "JsonWebTokenError") {
      return res.status(403).json({ error: "Invalid security session." });
    }

    return res.status(500).json({ error: "Database transaction failed." });
  }
}
