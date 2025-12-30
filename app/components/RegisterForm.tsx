"use client";
import { useState } from "react";

export default function RegisterForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    phone: "",
    address: "",
    role: "customer", // Default role
  });

  const [status, setStatus] = useState("");

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus("Processing...");

    try {
      const res = await fetch("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (data.success) {
        setStatus(`Success! ${formData.role} account created.`);
      } else {
        setStatus("Error: " + data.error);
      }
    } catch (err) {
      setStatus("Network Error.");
    }
  };

  return (
    <div
      style={{
        maxWidth: "400px",
        margin: "auto",
        padding: "20px",
        border: "1px solid #ccc",
      }}
    >
      <h2>VaultCart Registration</h2>
      <form
        onSubmit={handleRegister}
        style={{ display: "flex", flexDirection: "column", gap: "10px" }}
      >
        {/* ROLE SELECTION: Crucial for calling correct procedure */}
        <label>I am a:</label>
        <select
          value={formData.role}
          onChange={(e) => setFormData({ ...formData, role: e.target.value })}
          style={{ padding: "8px" }}
        >
          <option value="customer">Customer (Buyer)</option>
          <option value="seller">Seller (Vendor)</option>
        </select>

        <input
          type="text"
          placeholder="Full Name"
          required
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        />

        <input
          type="email"
          placeholder="Email"
          required
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        />

        <input
          type="password"
          placeholder="Password"
          required
          onChange={(e) =>
            setFormData({ ...formData, password: e.target.value })
          }
        />

        <input
          type="text"
          placeholder="Phone"
          onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
        />

        <textarea
          placeholder="Address"
          onChange={(e) =>
            setFormData({ ...formData, address: e.target.value })
          }
        />

        <button
          type="submit"
          style={{ background: "#0070f3", color: "white", padding: "10px" }}
        >
          Register Account
        </button>
      </form>
      {status && <p>{status}</p>}
    </div>
  );
}
