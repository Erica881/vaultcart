"use client";
import { useState } from "react";

export default function LoginForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("customer");

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    const res = await fetch("/api/login", {
      method: "POST",
      body: JSON.stringify({ email, password, role }),
    });

    const data = await res.json();
    if (data.success) {
      if (data.success) {
        // 1. Clear old data first to avoid seeing "previous" records
        localStorage.removeItem("vault_token");
        localStorage.removeItem("user_role");

        // 2. Set the NEW data
        localStorage.setItem("vault_token", data.token);
        localStorage.setItem("user_role", role);

        // 3. Optional: Brief delay (100ms) to ensure storage is written
        setTimeout(() => {
          window.location.href =
            role === "seller" ? "/dashboard/seller" : "/dashboard/customer";
        }, 100);
      }
      // Save the token for Row-Level Security (RLS) checks
      // localStorage.setItem("vault_token", data.token);
      // localStorage.setItem("user_role", role); // Store the role to help with UI logic
      alert("Login Successful!");
      // window.location.href = "/dashboard";
      window.location.href =
        role === "seller" ? "/dashboard/seller" : "/dashboard/customer";
    } else {
      alert("Login Failed: " + data.message);
    }
  };

  return (
    <form
      onSubmit={handleLogin}
      style={{
        display: "flex",
        flexDirection: "column",
        gap: "10px",
        maxWidth: "300px",
      }}
    >
      <select value={role} onChange={(e) => setRole(e.target.value)}>
        <option value="customer">Customer Login</option>
        <option value="seller">Seller Login</option>
      </select>
      <input
        type="email"
        placeholder="Email"
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Password"
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <button
        type="submit"
        style={{ backgroundColor: "#0070f3", color: "white", padding: "10px" }}
      >
        Login
      </button>
    </form>
  );
}
