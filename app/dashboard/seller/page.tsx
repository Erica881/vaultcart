"use client";
import { useEffect, useState } from "react";

export default function SellerDashboard() {
  const [product, setProduct] = useState({ name: "", price: "", stock: "" });
  const [inventory, setInventory] = useState([]);
  const [securityInfo, setSecurityInfo] = useState({ token: "", agent: "" });
  const [editingId, setEditingId] = useState<number | null>(null);
  async function fetchInventory(token: string, agent: string) {
    if (!token) return;

    try {
      const res = await fetch("/api/seller/inventory", {
        method: "GET", // Explicitly set GET
        headers: {
          Authorization: `Bearer ${token}`,
          "user-agent": agent,
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

      fetchInventory(token || "", agent);
    };

    initDashboard();
  }, []);

  const handleAddProduct = async (e: React.FormEvent) => {
    e.preventDefault();

    console.log("Current Token in State:", securityInfo.token); // <--- DEBUG THIS
    if (!securityInfo.token) {
      alert("Security Error: No session token found. Please re-login.");
      return;
    }
    const res = await fetch("/api/seller/add-product", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${securityInfo.token}`,
        "user-agent": securityInfo.agent,
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

  const handleDelete = async (productId: number) => {
    if (!confirm("Are you sure you want to delete this product?")) return;

    const res = await fetch(`/api/seller/delete-product`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${securityInfo.token}`,
        "user-agent": securityInfo.agent,
      },
      body: JSON.stringify({ productId }),
    });

    if (res.ok) {
      fetchInventory(securityInfo.token, securityInfo.agent);
    } else {
      const err = await res.json();
      alert(err.error);
    }
  };

  // 2. Create the toggle function
  const handleEditInitiate = (item: any) => {
    setEditingId(item.id); // Store the ID we are editing
    setProduct({
      name: item.name,
      price: item.price.toString(),
      stock: item.stock_qty.toString(),
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
  };
  // 3. Update your handleSubmit (replaces handleAddProduct)
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // Decide which API to call
    const url = editingId
      ? "/api/seller/update-product"
      : "/api/seller/add-product";
    const method = editingId ? "PUT" : "POST";

    const res = await fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${securityInfo.token}`,
        "user-agent": securityInfo.agent,
      },
      body: JSON.stringify({
        productId: editingId, // Will be null for new products
        name: product.name,
        price: parseFloat(product.price),
        stock: parseInt(product.stock),
      }),
    });

    if (res.ok) {
      alert(editingId ? "Product updated!" : "Product added!");
      setEditingId(null);
      setProduct({ name: "", price: "", stock: "" });
      fetchInventory(securityInfo.token, securityInfo.agent);
    } else {
      const err = await res.json();
      alert("Error: " + err.error);
    }
  };

  const handleLogout = async () => {
    try {
      // 1. Tell the server to invalidate the session
      await fetch("/api/logout", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${securityInfo.token}`,
        },
      });
    } catch (err) {
      console.error("Logout failed on server, clearing local storage anyway.");
    } finally {
      // 2. Clear local credentials regardless of server success
      localStorage.removeItem("vault_token");
      localStorage.removeItem("vault_user_agent");

      // 3. Redirect to login page
      window.location.href = "/";
    }
  };
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
      {/* HEADER SECTION: Title and Logout Button side-by-side */}
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          marginBottom: "30px",
        }}
      >
        <h1 style={{ color: "#fff", margin: 0, fontSize: "2.5rem" }}>
          🏪 Seller Management Portal
        </h1>

        <button
          onClick={handleLogout}
          style={{
            backgroundColor: "#ff4d4d",
            color: "white",
            padding: "12px 24px",
            border: "none",
            borderRadius: "8px",
            cursor: "pointer",
            fontWeight: "bold",
            fontSize: "14px",
            transition: "background 0.2s",
            display: "flex",
            alignItems: "center",
            gap: "8px",
          }}
          onMouseOver={(e) =>
            (e.currentTarget.style.backgroundColor = "#cc0000")
          }
          onMouseOut={(e) =>
            (e.currentTarget.style.backgroundColor = "#ff4d4d")
          }
        >
          <span>🚪</span> Logout Securely
        </button>
      </div>

      {/* SECURITY PANEL */}
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
          <p style={{ marginBottom: "8px" }}>
            <strong>Database Login:</strong>{" "}
            <span style={{ color: "#00ff88" }}>Vault_App_Connect</span>
          </p>
          <p
            style={{
              marginBottom: "8px",
              display: "flex",
              flexDirection: "column",
            }}
          >
            <strong>Session Token:</strong>{" "}
            <span
              style={{
                color: "#fff",
                fontFamily: "monospace",
                backgroundColor: "#000",
                padding: "4px 8px",
                borderRadius: "4px",
                marginTop: "4px",
                border: "1px solid #333",
                /* THE FIX IS HERE */
                wordBreak: "break-all",
                lineHeight: "1.4",
              }}
            >
              {securityInfo.token || "No Active Session"}
            </span>
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
            // onSubmit={handleAddProduct}
            onSubmit={handleSubmit}
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

            {/* <button
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
            </button> */}

            <div
              style={{ display: "flex", flexDirection: "column", gap: "10px" }}
            >
              <button
                type="submit"
                style={{
                  backgroundColor: editingId ? "#00ff88" : "#0070f3", // Change color for Edit mode
                  color: editingId ? "#000" : "#fff",
                  padding: "14px",
                  borderRadius: "6px",
                  fontWeight: "bold",
                  cursor: "pointer",
                  border: "none",
                }}
              >
                {editingId
                  ? "💾 Update Secure Product"
                  : "🚀 Secure Post to Catalog"}
              </button>

              {/* NEW: Cancel Button only shows during editing */}
              {editingId && (
                <button
                  onClick={() => {
                    setEditingId(null);
                    setProduct({ name: "", price: "", stock: "" });
                  }}
                  style={{
                    backgroundColor: "transparent",
                    color: "#888",
                    padding: "8px",
                    border: "1px solid #444",
                    borderRadius: "6px",
                    cursor: "pointer",
                  }}
                >
                  Cancel Edit (Switch to Add New)
                </button>
              )}
            </div>
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
                <th style={{ padding: "12px" }}>Action</th>
              </tr>
            </thead>
            <tbody>
              {inventory.length > 0 ? (
                inventory.map((item: any) => (
                  <tr key={item.id} style={{ borderBottom: "1px solid #222" }}>
                    <td style={{ padding: "12px" }}>{item.name}</td>
                    <td style={{ padding: "12px" }}>${item.price}</td>
                    <td style={{ padding: "12px" }}>{item.stock_qty}</td>
                    <td
                      style={{ padding: "12px", display: "flex", gap: "10px" }}
                    >
                      <button
                        onClick={() => handleEditInitiate(item)}
                        style={{
                          color: "#0070f3",
                          background: "none",
                          border: "none",
                          cursor: "pointer",
                        }}
                      >
                        ✏️ Edit
                      </button>
                      <button
                        onClick={() => handleDelete(item.id)}
                        style={{
                          color: "#ff4d4d",
                          background: "none",
                          border: "none",
                          cursor: "pointer",
                        }}
                      >
                        🗑️ Delete
                      </button>
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
