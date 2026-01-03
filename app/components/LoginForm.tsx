"use client";
import { useState } from "react";

export default function LoginForm() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState("customer");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      const res = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password, role }),
      });

      const data = await res.json();

      if (res.ok && data.success) {
        localStorage.setItem("vault_token", data.token || data.sessionToken);
        localStorage.setItem("user_role", role);
        localStorage.setItem("vault_user_agent", navigator.userAgent);

        const paths: Record<string, string> = {
          admin: "/dashboard/admin",
          seller: "/dashboard/seller",
          customer: "/dashboard/customer",
        };
        window.location.href = paths[role] || "/dashboard/customer";
      } else {
        const errorMsg = data.message || data.error || "Unknown Server Error";
        alert("Authentication Failed: " + errorMsg);
      }
    } catch (err) {
      console.error("Login Fetch Error:", err);
      alert("Network Error: Could not connect to the server.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleLogin} className="flex flex-col gap-4 w-full">
      {/* Role Selection */}
      <div className="flex flex-col gap-1">
        <label className="text-[10px] uppercase tracking-widest text-slate-500 ml-1">
          Access Level
        </label>
        <select
          className="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl text-white focus:ring-2 focus:ring-blue-500 outline-none transition-all"
          value={role}
          onChange={(e) => setRole(e.target.value)}
        >
          <option value="customer">Customer Portal</option>
          <option value="seller">Seller Portal</option>
          <option value="admin">System Admin / Security</option>
        </select>
      </div>

      {/* Email Input */}
      <input
        type="email"
        placeholder="Email Address"
        className="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl text-white placeholder:text-slate-600 focus:ring-2 focus:ring-blue-500 outline-none transition-all"
        onChange={(e) => setEmail(e.target.value)}
        required
      />

      {/* Password Input */}
      <input
        type="password"
        placeholder="Secret Key / Password"
        className="w-full bg-slate-900 border border-slate-700 p-3 rounded-xl text-white placeholder:text-slate-600 focus:ring-2 focus:ring-blue-500 outline-none transition-all"
        onChange={(e) => setPassword(e.target.value)}
        required
      />

      {/* Submit Button */}
      <button
        type="submit"
        disabled={loading}
        className="w-full bg-blue-600 hover:bg-blue-500 disabled:bg-blue-800 text-white font-bold py-3 rounded-xl shadow-lg shadow-blue-900/20 transition-all active:scale-[0.98]"
      >
        {loading ? "Authenticating..." : "Authorize Access"}
      </button>

      {/* Security Hint for PDPA */}
      <p className="text-[10px] text-center text-slate-500 mt-2">
        Session encrypted via AES-256 TLS
      </p>
    </form>
  );
}
