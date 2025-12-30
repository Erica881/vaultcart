import sql, { ConnectionPool, config, Request } from "mssql";

// 1. Define the interface for your query parameters
interface QueryParam {
  name: string;
  type: any; // e.g., sql.Int, sql.NVarChar
  value: any;
}

const sqlConfig: config = {
  user: "Vault_App_Connect",
  password: "StrongPassword_App1!",
  database: "VaultCartDB",
  server: "192.168.245.100",
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
};

// Global pool variable to prevent creating too many connections in Next.js dev mode
let globalPool: ConnectionPool | null = null;

async function getPool(): Promise<ConnectionPool> {
  if (globalPool) return globalPool;
  globalPool = await sql.connect(sqlConfig);
  return globalPool;
}

/**
 * Standard query execution
 */
export async function executeQuery(query: string, params: QueryParam[] = []) {
  try {
    const pool = await getPool();
    const request: Request = pool.request();

    params.forEach((p) => {
      request.input(p.name, p.type, p.value);
    });

    return await request.query(query);
  } catch (err) {
    console.error("SQL error", err);
    throw err;
  }
}

/**
 * Executes a query within a transaction to set Session Context for Row-Level Security (RLS)
 * @param sessionToken - The GUID/UniqueIdentifier for the session
 * @param userAgent - The browser user agent string
 * @param query - The SQL query to run (e.g., SELECT * FROM Sales.Orders)
 */
export async function executeWithRLS(
  sessionToken: string,
  userAgent: string,
  query: string
) {
  let pool: ConnectionPool | null = null;
  try {
    pool = await getPool();
    const transaction = new sql.Transaction(pool);

    await transaction.begin();
    const request = new sql.Request(transaction);

    // 1. Set the Session Context (Critical for RLS Policy in your VaultCartDB)
    // Note: sessionToken must be a valid GUID string for sql.UniqueIdentifier
    request.input("Token", sql.UniqueIdentifier, sessionToken);
    request.input("Agent", sql.NVarChar, userAgent);

    await request.query(`
      EXEC sp_set_session_context @key=N'SessionToken', @value=@Token;
      EXEC sp_set_session_context @key=N'UserAgent', @value=@Agent;
    `);

    // 2. Run the actual query (The RLS policy filters this automatically)
    const result = await request.query(query);

    await transaction.commit();
    return result;
  } catch (err) {
    console.error("RLS Query Error:", err);
    throw err;
  }
}
