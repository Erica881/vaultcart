"use client";
import { useState } from "react";

export default function LoginForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("customer");

  // const handleLogin = async (e: React.FormEvent) => {
  //   e.preventDefault();
  //   const res = await fetch("/api/login", {
  //     method: "POST",
  //     body: JSON.stringify({ email, password, role }),
  //   });

  //   const data = await res.json();
  //   if (data.success) {
  //     if (data.success) {
  //       // 1. Clear old data first to avoid seeing "previous" records
  //       localStorage.removeItem("vault_token");
  //       localStorage.removeItem("user_role");

  //       // 2. Set the NEW data
  //       localStorage.setItem("vault_token", data.token);
  //       localStorage.setItem("user_role", role);

  //       // 3. Optional: Brief delay (100ms) to ensure storage is written
  //       setTimeout(() => {
  //         window.location.href =
  //           role === "seller" ? "/dashboard/seller" : "/dashboard/customer";
  //       }, 100);
  //     }
  //     // Save the token for Row-Level Security (RLS) checks
  //     // localStorage.setItem("vault_token", data.token);
  //     // localStorage.setItem("user_role", role); // Store the role to help with UI logic
  //     alert("Login Successful!");
  //     // window.location.href = "/dashboard";
  //     window.location.href =
  //       role === "seller" ? "/dashboard/seller" : "/dashboard/customer";
  //   } else {
  //     alert("Login Failed: " + data.message);
  //   }
  // };

  // const handleLogin = async (e: React.FormEvent) => {
  //   e.preventDefault();
  //   const res = await fetch("/api/login", {
  //     method: "POST",
  //     body: JSON.stringify({ email, password, role }),
  //   });

  //   const data = await res.json();
  //   if (data.success) {
  //     // 1. Store the Security Token for RLS
  //     localStorage.setItem("vault_token", data.token);
  //     localStorage.setItem("user_role", role);

  //     // 2. Redirect based on Role
  //     if (role === "admin") {
  //       window.location.href = "/dashboard/admin";
  //     } else if (role === "seller") {
  //       window.location.href = "/dashboard/seller";
  //     } else {
  //       window.location.href = "/dashboard/customer";
  //     }
  //   } else {
  //     alert("Authentication Failed: " + data.message);
  //   }
  // };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" }, // Ensure headers are set
        body: JSON.stringify({ email, password, role }),
      });

      const data = await res.json();

      if (res.ok && data.success) {
        localStorage.setItem("vault_token", data.token || data.sessionToken); // Handle both naming styles
        localStorage.setItem("user_role", role);
        // Store the UserAgent (this must match what was sent to the DB)
        localStorage.setItem("vault_user_agent", navigator.userAgent);

        // Redirect
        const paths = {
          admin: "/dashboard/admin",
          seller: "/dashboard/seller",
        };
        window.location.href = paths[role] || "/dashboard/customer";
      } else {
        // Logic to find the error message regardless of key name
        const errorMsg = data.message || data.error || "Unknown Server Error";
        alert("Authentication Failed: " + errorMsg);
      }
    } catch (err) {
      console.error("Login Fetch Error:", err);
      alert("Network Error: Could not connect to the server.");
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
      <select
        className="w-full bg-slate-900 p-3 rounded-lg mb-4 text-white"
        value={role}
        onChange={(e) => setRole(e.target.value)}
      >
        <option value="customer">Customer Portal</option>
        <option value="seller">Seller Portal</option>
        <option value="admin">System Admin / Security</option>
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
