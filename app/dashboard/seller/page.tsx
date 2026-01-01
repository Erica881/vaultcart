"use client";
import { useEffect, useState } from "react";

export default function SellerDashboard() {
  const [product, setProduct] = useState({ name: "", price: "", stock: "" });
  const [inventory, setInventory] = useState([]);
  const [securityInfo, setSecurityInfo] = useState({ token: "", agent: "" });
  const [status, setStatus] = useState("LOADING...");

  async function fetchInventory(token: string, agent: string) {
    if (!token) return;

    try {
      const res = await fetch("/api/seller/inventory", {
        method: "GET", // Explicitly set GET
        headers: {
          Authorization: `Bearer ${token}`,
          "X-User-Agent": agent,
        },
      });

      // Check if response is empty or invalid
      if (res.status === 204 || res.headers.get("content-length") === "0") {
        setInventory([]);
        return;
      }

      const data = await res.json();
      if (res.ok) {
        setInventory(data);
      } else {
        console.error("Server Error:", data.error);
      }
    } catch (err) {
      console.error("Failed to load inventory:", err);
    }
  }

  // 3. Now the useEffect can safely call them
  useEffect(() => {
    const initDashboard = async () => {
      const token = localStorage.getItem("vault_token");
      const agent = localStorage.getItem("vault_user_agent") || "unknown";

      if (!token) {
        console.error("No token found!");
        return;
      }

      setSecurityInfo({ token, agent });

      // Both functions are now defined above this line, so no more error!
      // await Promise.all([fetchInventory(token, agent)]);
      fetchInventory(token || "", agent);
    };

    initDashboard();
  }, []);

  const handleAddProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    const res = await fetch("/api/seller/add-product", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${securityInfo.token}`,
        "X-User-Agent": securityInfo.agent,
      },
      // body: JSON.stringify(product),
      body: JSON.stringify({
        name: product.name,
        price: parseFloat(product.price), // Ensure numbers are passed correctly
        stock: parseInt(product.stock),
      }),
    });

    if (res.ok) {
      alert("Product added securely to Catalog schema!");
      setProduct({ name: "", price: "", stock: "" });
      fetchInventory(securityInfo.token, securityInfo.agent);
    }
  };

  // Styles defined for Black Background
  const cardStyle: React.CSSProperties = {
    backgroundColor: "#1a1a1a", // Deep grey card
    border: "1px solid #333",
    padding: "20px",
    borderRadius: "12px",
    color: "#ffffff",
  };

  const inputStyle: React.CSSProperties = {
    padding: "12px",
    backgroundColor: "#2a2a2a",
    border: "1px solid #444",
    borderRadius: "6px",
    color: "#fff",
    marginBottom: "10px",
  };

  return (
    <div
      style={{
        backgroundColor: "#000",
        minHeight: "100vh",
        padding: "40px",
        color: "#fff",
        fontFamily: "'Inter', sans-serif",
      }}
    >
      <h1 style={{ color: "#fff", marginBottom: "30px", fontSize: "2.5rem" }}>
        🏪 Seller Management Portal
      </h1>

      {/* SECURITY PANEL - MATCHES YOUR DOC (Audit & Isolation) */}
      <div
        style={{
          ...cardStyle,
          borderLeft: "4px solid #0070f3",
          marginBottom: "30px",
          background: "linear-gradient(90deg, #0a0a0a 0%, #1a1a1a 100%)",
        }}
      >
        <h4
          style={{
            margin: "0 0 10px 0",
            color: "#0070f3",
            display: "flex",
            alignItems: "center",
            gap: "10px",
          }}
        >
          🛡️ Active Security Context (RLS Enabled)
        </h4>
        <div style={{ fontSize: "13px", opacity: 0.8 }}>
          <p>
            <strong>Database Login:</strong>{" "}
            <span style={{ color: "#00ff88" }}>Vault_App_Connect</span>
          </p>
          <p>
            <strong>Session Token:</strong>{" "}
            {securityInfo.token || "No Active Session"}
          </p>
          <p>
            <strong>Device Fingerprint:</strong> {securityInfo.agent}
          </p>
        </div>
      </div>

      <div
        style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "30px" }}
      >
        {/* ADD PRODUCT SECTION */}
        <div style={cardStyle}>
          <h3 style={{ color: "#fff", marginBottom: "20px" }}>
            List New Product
          </h3>
          <form
            onSubmit={handleAddProduct}
            style={{ display: "flex", flexDirection: "column" }}
          >
            <label
              style={{ fontSize: "12px", color: "#888", marginBottom: "5px" }}
            >
              PRODUCT NAME
            </label>
            <input
              style={inputStyle}
              type="text"
              placeholder="e.g. Premium Tech Widget"
              value={product.name}
              onChange={(e) => setProduct({ ...product, name: e.target.value })}
              required
            />

            <label
              style={{ fontSize: "12px", color: "#888", marginBottom: "5px" }}
            >
              UNIT PRICE ($)
            </label>
            <input
              style={inputStyle}
              type="number"
              placeholder="0.00"
              value={product.price}
              onChange={(e) =>
                setProduct({ ...product, price: e.target.value })
              }
              required
            />

            <label
              style={{ fontSize: "12px", color: "#888", marginBottom: "5px" }}
            >
              INITIAL STOCK
            </label>
            <input
              style={inputStyle}
              type="number"
              placeholder="100"
              value={product.stock}
              onChange={(e) =>
                setProduct({ ...product, stock: e.target.value })
              }
              required
            />

            <button
              type="submit"
              style={{
                backgroundColor: "#0070f3",
                color: "white",
                padding: "14px",
                border: "none",
                borderRadius: "6px",
                cursor: "pointer",
                fontWeight: "bold",
                marginTop: "10px",
                transition: "0.3s",
              }}
            >
              Secure Post to Catalog
            </button>
          </form>
        </div>

        {/* INVENTORY TABLE - Proves Row Level Security */}
        <div style={cardStyle}>
          <h3 style={{ color: "#fff", marginBottom: "10px" }}>
            My Secure Inventory
          </h3>
          <p style={{ color: "#888", fontSize: "14px", marginBottom: "20px" }}>
            Data isolated via{" "}
            <strong>Security.fn_ProductSecurityPredicate</strong>. You cannot
            see other sellers&apos; products.
          </p>
          <table
            style={{ width: "100%", borderCollapse: "collapse", color: "#fff" }}
          >
            <thead>
              <tr
                style={{
                  textAlign: "left",
                  borderBottom: "1px solid #333",
                  color: "#888",
                  fontSize: "12px",
                }}
              >
                <th style={{ padding: "12px" }}>PRODUCT</th>
                <th style={{ padding: "12px" }}>PRICE</th>
                <th style={{ padding: "12px" }}>STOCK</th>
                <th style={{ padding: "12px" }}>ENCRYPTION</th>
              </tr>
            </thead>
            <tbody>
              {inventory.length > 0 ? (
                inventory.map((item: any) => (
                  <tr key={item.id} style={{ borderBottom: "1px solid #222" }}>
                    <td style={{ padding: "12px" }}>{item.name}</td>
                    <td style={{ padding: "12px" }}>${item.price}</td>
                    <td style={{ padding: "12px" }}>{item.stock_qty}</td>
                    <td style={{ padding: "12px" }}>
                      <span
                        style={{
                          color: "#00ff88",
                          fontSize: "12px",
                          fontWeight: "bold",
                        }}
                      >
                        ● TDE active
                      </span>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td
                    colSpan={4}
                    style={{
                      padding: "20px",
                      textAlign: "center",
                      color: "#555",
                    }}
                  >
                    No products found in your secure partition.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
