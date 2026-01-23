import mysql from "mysql2/promise";

// We keep this interface for your frontend compatibility,
// but MySQL doesn't need 'type', only 'value'.
interface QueryParam {
  name: string;
  type?: any;
  value: any;
}

const mysqlConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};

let pool: mysql.Pool | null = null;

export async function getPool(): Promise<mysql.Pool> {
  if (!pool) {
    console.log("Connecting to Database:", mysqlConfig.database); // Add this!
    try {
      pool = mysql.createPool(mysqlConfig);
      console.log("MySQL Pool Created");
    } catch (err) {
      console.error("Database Connection Failed:", err);
      throw err;
    }
  }
  return pool;
}

/**
 * INTERNAL HELPER: Sets the MySQL Session Variables
 * This emulates the RLS context you had in MSSQL.
 */
async function setSessionContext(
  connection: mysql.PoolConnection,
  sessionToken: string,
  userAgent: string,
) {
  // In MySQL, we use @variables to hold session context for Views/Procedures
  await connection.execute("SET @SessionToken = ?, @UserAgent = ?", [
    sessionToken,
    userAgent,
  ]);
}

/**
 * EXECUTE SECURE QUERY
 * Used for SELECT statements targeting your new Secure Views.
 */
export async function executeSecureQuery(
  query: string,
  sessionToken: string,
  userAgent: string,
  params: any[] = [], // MySQL uses simple arrays for params
) {
  const connection = await (await getPool()).getConnection();
  try {
    // 1. Set the context so the View can filter data
    await setSessionContext(connection, sessionToken, userAgent);

    // 2. Execute the query
    const [rows] = await connection.execute(query, params);
    return rows;
  } catch (err: any) {
    console.error("Secure Query Error:", err.message);
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * EXECUTE PROCEDURE
 * Optimized for MySQL CALL syntax.
 */
export async function executeProcedure(
  procedureName: string,
  params: any[] = [],
  sessionToken?: string,
  userAgent?: string,
) {
  const connection = await (await getPool()).getConnection();
  try {
    if (sessionToken && userAgent) {
      await setSessionContext(connection, sessionToken, userAgent);
    }

    // MySQL uses "CALL ProcedureName(?, ?, ?)"
    const placeholders = params.map(() => "?").join(", ");
    const sql = `CALL ${procedureName}(${placeholders})`;
    console.log("SQL:", sql);

    const [result] = await connection.execute(sql, params);
    return result;
  } catch (err: any) {
    console.error(`Procedure Error (${procedureName}):`, err.message);
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * STANDARD QUERY (No Context)
 */
export async function executeQuery(query: string, params: any[] = []) {
  const p = await getPool();
  try {
    const [rows] = await p.execute(query, params);
    return rows;
  } catch (err: any) {
    console.error("SQL error", err.message);
    throw err;
  }
}
