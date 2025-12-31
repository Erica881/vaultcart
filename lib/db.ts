// import sql, { ConnectionPool, config, Request } from "mssql";
// import Msnodesqlv8 from "msnodesqlv8";

// interface QueryParam {
//   name: string;
//   type: any;
//   value: any;
// }

// const sqlConfig: config = {
//   user: "Vault_App_Connect",
//   password: "StrongPassword_App1!",
//   database: "VaultCartDB",
//   server: "192.168.245.100",
//   driver: "msnodesqlv8",
//   pool: {
//     max: 10,
//     min: 0,
//     idleTimeoutMillis: 30000,
//   },
//   // options: {
//   //   encrypt: true,
//   //   trustServerCertificate: true,
//   //   // FIX 1: Uncomment and ensure this is TRUE
//   //   columnEncryptionSetting: true,
//   //   "Column Encryption Setting": "Enabled",
//   //   cryptoCredentialsDetails: {
//   //     minVersion: "TLSv1.2",
//   //   },
//   // },
//   options: {
//     encrypt: true,
//     trustServerCertificate: true,
//     columnEncryptionSetting: true, // Crucial for AE
//     cryptoCredentialsDetails: {
//       minVersion: "TLSv1.2",
//     },
//   },
// };

// let globalPool: ConnectionPool | null = null;

// async function getPool(): Promise<ConnectionPool> {
//   if (globalPool) return globalPool;
//   globalPool = await sql.connect(sqlConfig);
//   return globalPool;
// }

// export async function executeProcedure(
//   procedureName: string,
//   params: QueryParam[] = []
// ) {
//   try {
//     const pool = await getPool();
//     const request: Request = pool.request();
//     params.forEach((p) => request.input(p.name, p.type, p.value));
//     return await request.execute(procedureName);
//   } catch (err: any) {
//     console.error(`Procedure Error (${procedureName}):`, err);
//     throw err;
//   }
// }
// /**
//  * Executes a raw T-SQL Batch (Good for DECLARE / EXEC patterns)
//  */
// export async function executeBatch(query: string, params: QueryParam[] = []) {
//   try {
//     const pool = await getPool();
//     const request: Request = pool.request();

//     // Map parameters to the request
//     params.forEach((p) => {
//       request.input(p.name, p.type, p.value);
//     });

//     // We use .query() here for raw T-SQL strings
//     return await request.query(query);
//   } catch (err: any) {
//     if (err.originalError && err.originalError.errors) {
//       console.error("DETAILED ENCRYPTION ERRORS:", err.originalError.errors);
//     }
//     throw err;
//   }
// }

// export async function executeQuery(query: string, params: QueryParam[] = []) {
//   try {
//     const pool = await getPool();
//     const request: Request = pool.request();
//     params.forEach((p) => {
//       request.input(p.name, p.type, p.value);
//     });
//     return await request.query(query);
//   } catch (err) {
//     console.error("SQL error", err);
//     throw err;
//   }
// }

// // ... keep your executeWithRLS as is ...

import sql, { ConnectionPool, config, Request } from "mssql";
import Msnodesqlv8 from "msnodesqlv8";

interface QueryParam {
  name: string;
  type: any;
  value: any;
}

const sqlConfig: config = {
  user: "Vault_App_Connect", // Login used by web application [cite: 45]
  password: "StrongPassword_App1!",
  database: "VaultCartDB",
  server: "192.168.245.100",
  // driver: "msnodesqlv8",
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: true,
    trustServerCertificate: true,
    // FIX: Always Encrypted requires these specific settings
    columnEncryptionSetting: true,
    // "Column Encryption Setting": "Enabled",
    ...({ columnEncryptionSetting: true } as any),
    // cryptoCredentialsDetails: {
    //   minVersion: "TLSv1.2",
    // },
  },
};

let globalPool: ConnectionPool | null = null;

async function getPool(): Promise<ConnectionPool> {
  if (globalPool) return globalPool;
  globalPool = await sql.connect(sqlConfig);
  return globalPool;
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

export async function executeBatch(query: string, params: QueryParam[] = []) {
  try {
    const pool = await getPool();
    const request: Request = pool.request();

    // Map parameters to the request
    params.forEach((p) => {
      request.input(p.name, p.type, p.value);
    });

    // We use .query() here for raw T-SQL strings
    return await request.query(query);
  } catch (err: any) {
    if (err.originalError && err.originalError.errors) {
      console.error("DETAILED ENCRYPTION ERRORS:", err.originalError.errors);
    }
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
