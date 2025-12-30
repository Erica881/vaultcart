"use client";
import { useState } from "react";
import LoginForm from "@/app/components/LoginForm";
import RegisterForm from "@/app/components/RegisterForm";
// Interfaces for TypeScript safety
interface Order {
  OrderID: number;
  OrderDate: string;
  TotalAmount: number;
  status: string;
}

interface MaskedCustomer {
  CustomerID: number;
  name: string;
  email: string;
  phone: string;
}

export default function SecurityDashboard() {
  const [token, setToken] = useState(""); // GUID for RLS
  const [orders, setOrders] = useState<Order[]>([]);
  const [customers, setCustomers] = useState<MaskedCustomer[]>([]);
  const [loading, setLoading] = useState(false);
  const [statusMsg, setStatusMsg] = useState("");

  // TASK 2: View Orders (Demonstrates RLS)
  const fetchOrders = async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/orders", {
        headers: { "x-session-token": token },
      });
      const data = await res.json();
      setOrders(Array.isArray(data) ? data : []);
      setStatusMsg(
        res.ok
          ? "RLS Applied: Only your data is visible."
          : "Error fetching orders."
      );
    } catch (err) {
      setStatusMsg("Connection failed.");
    } finally {
      setLoading(false);
    }
  };

  // TASK 2: Insert New Order (Testing Requirement)
  const addTestOrder = async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/orders", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-session-token": token,
        },
        body: JSON.stringify({ amount: 99.99 }),
      });
      if (res.ok) {
        setStatusMsg("Entry Inserted Successfully!");
        fetchOrders(); // Refresh list
      }
    } catch (err) {
      setStatusMsg("Insert failed.");
    } finally {
      setLoading(false);
    }
  };

  // TASK 5: View Support Portal (Demonstrates Data Masking)
  const fetchSupportData = async () => {
    setLoading(true);
    try {
      const res = await fetch("/api/support");
      const data = await res.json();
      setCustomers(data);
      setStatusMsg("DDM Applied: PII is masked for OpsManager.");
    } catch (err) {
      setStatusMsg("Support access denied.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      style={{
        padding: "30px",
        fontFamily: "sans-serif",
        maxWidth: "1000px",
        margin: "auto",
        color: loading ? "gray" : "black",
      }}
    >
      <h1>VaultCart Security Implementation</h1>

      <div
        style={{
          background: "#f0f4f8",
          padding: "20px",
          borderRadius: "8px",
          marginBottom: "20px",
        }}
      >
        <h3>Step 1: Authenticate (RLS Token)</h3>
        <input
          type="text"
          placeholder="Enter Session GUID from SSMS"
          value={token}
          onChange={(e) => setToken(e.target.value)}
          style={{ width: "70%", padding: "10px" }}
        />
        <button onClick={fetchOrders} style={btnStyle("#0070f3")}>
          View My Orders
        </button>
        <button onClick={addTestOrder} style={btnStyle("#28a745")}>
          + Add Test Entry
        </button>
      </div>

      <div style={{ marginBottom: "20px" }}>
        <button onClick={fetchSupportData} style={btnStyle("#6200ee")}>
          Test Data Masking (Support View)
        </button>
      </div>

      {statusMsg && (
        <p style={{ color: "blue", fontWeight: "bold" }}>{statusMsg}</p>
      )}

      {/* Orders Table (RLS Result) */}
      {orders.length > 0 && (
        <section>
          <h2>My Protected Orders (RLS)</h2>
          <table
            border={1}
            cellPadding={10}
            style={{ width: "100%", borderCollapse: "collapse" }}
          >
            <thead style={{ background: "#eee" }}>
              <tr>
                <th>ID</th>
                <th>Date</th>
                <th>Amount</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((o) => (
                <tr key={o.OrderID}>
                  <td>{o.OrderID}</td>
                  <td>{new Date(o.OrderDate).toLocaleDateString()}</td>
                  <td>${o.TotalAmount}</td>
                  <td>{o.status}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}

      {/* Customers Table (Masking Result) */}
      {customers.length > 0 && (
        <section>
          <h2>Global Customer List (Masked)</h2>
          <table
            border={1}
            cellPadding={10}
            style={{ width: "100%", borderCollapse: "collapse" }}
          >
            <thead style={{ background: "#eee" }}>
              <tr>
                <th>Name</th>
                <th>Email (Masked)</th>
                <th>Phone (Masked)</th>
              </tr>
            </thead>
            <tbody>
              {customers.map((c, i) => (
                <tr key={i}>
                  <td>{c.name}</td>
                  <td>
                    <code>{c.email}</code>
                  </td>
                  <td>{c.phone}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}
      <div
        style={{
          padding: "30px",
          fontFamily: "sans-serif",
          maxWidth: "1000px",
          margin: "auto",
          color: "white",
        }}
      >
        <LoginForm />
        <RegisterForm />
      </div>
    </div>
  );
}

const btnStyle = (bg: string) => ({
  backgroundColor: bg,
  color: "white",
  padding: "10px 15px",
  border: "none",
  borderRadius: "5px",
  marginLeft: "10px",
  cursor: "pointer",
});
