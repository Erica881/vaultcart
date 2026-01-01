import sql, { ConnectionPool, config, Request } from "mssql";

interface QueryParam {
  name: string;
  type: any;
  value: any;
}

const sqlConfig: any = {
  user: "Vault_App_Connect",
  password: "StrongPassword_App1!",
  database: "VaultCartDB",
  server: "192.168.245.100",
  // Move it FROM here...
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    port: 1433,
    encrypt: true,
    trustServerCertificate: true,
    // ...TO HERE:
    columnEncryptionSetting: true,
  },
};

// const connectionString = `Server=192.168.245.100,1433;Database=VaultCartDB;User Id=Vault_App_Connect;Password=StrongPassword_App1!;Encrypt=true;TrustServerCertificate=true;Column Encryption Setting=Enabled;`;

let globalPool: ConnectionPool | null = null;

// async function getPool(): Promise<ConnectionPool> {
//   try {
//     if (globalPool) return globalPool;
//     // Connect using the string instead of the config object
//     globalPool = await sql.connect(sqlConfig);
//     return globalPool;
//   } catch (err) {
//     console.error("Database Connection Failed:", err);
//     throw err;
//   }
// }

// Add 'export' right here:
export async function getPool(): Promise<ConnectionPool> {
  try {
    if (globalPool) return globalPool;
    globalPool = await sql.connect(sqlConfig);
    return globalPool;
  } catch (err) {
    console.error("Database Connection Failed:", err);
    throw err;
  }
}

/**
 * FIX: RLS Context Helper
 * Sets the SESSION_CONTEXT required by your RLS predicates[cite: 126, 129].
 */
async function setRlsContext(
  request: Request,
  sessionToken: string,
  userAgent: string
) {
  request.input("SessionToken", sql.UniqueIdentifier, sessionToken);
  request.input("UserAgent", sql.NVarChar(500), userAgent);

  // These keys MUST match the keys used in your SQL fn_OrderSecurityPredicate
  await request.batch(`
    EXEC sp_set_session_context @key=N'SessionToken', @value=@SessionToken;
    EXEC sp_set_session_context @key=N'UserAgent', @value=@UserAgent;
  `);
}

/**
 * FIX: Secure Procedure Execution
 * Essential for Always Encrypted columns (e.g., Registering a Seller with a CardNumber)[cite: 10, 393].
 */
export async function executeProcedure(
  procedureName: string,
  params: QueryParam[] = []
) {
  try {
    const pool = await getPool();
    const request: Request = pool.request();
    params.forEach((p) => request.input(p.name, p.type, p.value));

    // AE requires RPC calls (request.execute) rather than raw query strings
    return await request.execute(procedureName);
  } catch (err: any) {
    console.error(`Procedure Error (${procedureName}):`, err);
    throw err;
  }
}

/**
 * FIX: Secure Query with RLS
 * Use this for all SELECT statements on Orders, Products, or Items[cite: 116, 117, 118].
 */
export async function executeSecureQuery(
  query: string,
  sessionToken: string,
  userAgent: string,
  params: QueryParam[] = []
) {
  try {
    const pool = await getPool();
    const request: Request = pool.request();

    // 1. Set the RLS context first [cite: 151]
    await setRlsContext(request, sessionToken, userAgent);

    // 2. Add parameters for the actual query
    params.forEach((p) => request.input(p.name, p.type, p.value));

    // 3. Execute the query (Ensures user only sees their own data) [cite: 152]
    return await request.query(query);
  } catch (err: any) {
    console.error("Secure Query Error:", err);
    throw err;
  }
}

export async function executeBatch(
  procedureName: string,
  params: QueryParam[] = []
) {
  try {
    const pool = await getPool();
    const request = pool.request();

    params.forEach((p) => {
      request.input(p.name, p.type, p.value);
    });

    // CHANGE: Pass ONLY the procedure name, NOT a string with "EXEC..."
    return await request.execute(procedureName);
  } catch (err: any) {
    // console.error("Execution Error:", err.message);
    console.error("FULL DB ERROR:", JSON.stringify(err, null, 2));
    throw err;
  }
}

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
