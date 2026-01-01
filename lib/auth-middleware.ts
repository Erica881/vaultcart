import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "your-ultra-secure-secret";

export function verifySellerSession(req: any) {
  const authHeader =
    typeof req.headers.get === "function"
      ? req.headers.get("authorization")
      : req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.error("Auth Header Debug:", authHeader); // This helps you see what's actually arriving
    throw new Error("Missing or invalid Authorization header");
  }

  const token = authHeader.split(" ")[1];

  try {
    // This checks the signature and expiration
    const decoded = jwt.verify(token, JWT_SECRET) as {
      sellerId: string;
      sessionToken: string; // The GUID needed for SQL RLS
      email: string;
    };
    return decoded;
  } catch (err) {
    throw new Error("Session expired or invalid");
  }
}
