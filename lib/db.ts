import sql, { ConnectionPool, Request } from "mssql";

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
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    port: 1433,
    encrypt: true,
    trustServerCertificate: true,
    columnEncryptionSetting: true, // Required for Always Encrypted
    // Add this to fix the IP address TLS warning
    cryptoCredentialsDetails: {
      checkServerIdentity: () => undefined,
    },
  },
};

let globalPool: ConnectionPool | null = null;

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
 * INTERNAL HELPER: Sets the RLS / Security Context
 * This ensures that the SessionToken is correctly typed as a UniqueIdentifier
 * to prevent "Conversion failed" errors.
 */
async function setRlsContext(
  request: Request,
  sessionToken: string,
  userAgent: string
) {
  // Use explicit types to ensure the GUID string is converted correctly by the driver
  request.input("ContextToken", sql.UniqueIdentifier, sessionToken);
  request.input("ContextAgent", sql.NVarChar(500), userAgent);

  await request.batch(`
    EXEC sp_set_session_context @key=N'SessionToken', @value=@ContextToken;
    EXEC sp_set_session_context @key=N'UserAgent', @value=@ContextAgent;
  `);
}

/**
 * EXECUTE SECURE PROCEDURE
 * Used for Add-Product, Registration, etc.
 */
export async function executeProcedure(
  procedureName: string,
  params: QueryParam[] = [],
  sessionToken?: string,
  userAgent?: string
) {
  try {
    const pool = await getPool();
    const request = pool.request();

    // 1. Set Security Context if provided
    if (sessionToken && userAgent) {
      await setRlsContext(request, sessionToken, userAgent);
    }

    // 2. Inject Procedure Parameters
    params.forEach((param) => {
      request.input(param.name, param.type, param.value);
    });

    // 3. Execute as RPC (Requirement for Always Encrypted)
    return await request.execute(procedureName);
  } catch (err: any) {
    console.error(`Procedure Error (${procedureName}):`, err.message);
    throw err;
  }
}

export async function executeProcedure2(
  procedureName: string,
  params: QueryParam[] = [],
  sessionToken?: string,
  userAgent?: string
) {
  try {
    const pool = await getPool();
    const request = pool.request();

    // 1. SET SECURITY CONTEXT (Background info)
    // We do NOT use request.input here because these aren't procedure arguments
    if (sessionToken && userAgent) {
      await request.batch(`
        EXEC sp_set_session_context @key=N'SessionToken', @value='${sessionToken}';
        EXEC sp_set_session_context @key=N'UserAgent', @value=N'${userAgent}';
      `);
    }

    // 2. INJECT PROCEDURE ARGUMENTS (The actual 3 fields)
    params.forEach((p) => {
      request.input(p.name, p.type, p.value);
    });

    // 3. EXECUTE
    // SQL now sees exactly 3 arguments, matching your procedure definition
    return await request.execute(procedureName);
  } catch (err: any) {
    console.error(`Procedure Error (${procedureName}):`, err.message);
    throw err;
  }
}

/**
 * EXECUTE SECURE QUERY
 * Used for SELECT statements protected by Row-Level Security.
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

    await setRlsContext(request, sessionToken, userAgent);

    params.forEach((p) => request.input(p.name, p.type, p.value));

    return await request.query(query);
  } catch (err: any) {
    console.error("Secure Query Error:", err.message);
    throw err;
  }
}

/**
 * STANDARD QUERY (No RLS Context)
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
