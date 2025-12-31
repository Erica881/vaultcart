"use client";
import { useState } from "react";

export default function RegisterForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    phone: "",
    address: "",
    cardNumber: "", // New field for Sellers
    role: "customer",
  });

  const [status, setStatus] = useState("");

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus("Processing Identity...");

    try {
      const res = await fetch("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (data.success) {
        setStatus(
          `✅ ${formData.role.toUpperCase()} initialized successfully.`
        );
      } else {
        setStatus("❌ Error: " + data.error);
      }
    } catch (err) {
      setStatus("❌ Network Error.");
    }
  };

  return (
    <div className="w-full max-w-md bg-slate-800/50 p-1 border border-slate-700 rounded-xl">
      <form onSubmit={handleRegister} className="flex flex-col gap-4 p-4">
        {/* ROLE SELECTION */}
        <div className="flex flex-col gap-1">
          <label className="text-xs text-slate-500 uppercase font-bold">
            Identity Type
          </label>
          <select
            value={formData.role}
            onChange={(e) => setFormData({ ...formData, role: e.target.value })}
            className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white focus:ring-2 focus:ring-blue-500 outline-none"
          >
            <option value="customer">Customer (Buyer)</option>
            <option value="seller">Seller (Vendor)</option>
          </select>
        </div>

        {/* COMMON FIELDS */}
        <input
          type="text"
          placeholder="Full Name"
          required
          className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white outline-none focus:border-blue-500"
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        />

        <input
          type="email"
          placeholder="Email Address"
          required
          className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white outline-none focus:border-blue-500"
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        />

        <input
          type="password"
          placeholder="Security Password"
          required
          className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white outline-none focus:border-blue-500"
          onChange={(e) =>
            setFormData({ ...formData, password: e.target.value })
          }
        />

        {/* CONDITIONAL FIELDS FOR SELLER */}
        {formData.role === "seller" && (
          <div className="animate-in fade-in slide-in-from-top-2 duration-300">
            <input
              type="text"
              placeholder="Merchant Card Number (Encrypted)"
              required={formData.role === "seller"}
              className="w-full bg-slate-900 border border-emerald-900/50 rounded-lg p-3 text-emerald-400 outline-none focus:border-emerald-500"
              onChange={(e) =>
                setFormData({ ...formData, cardNumber: e.target.value })
              }
            />
            <p className="text-[10px] text-emerald-600 mt-1 ml-1">
              🔒 Protected by Always Encrypted
            </p>
          </div>
        )}

        {/* CONDITIONAL FIELDS FOR CUSTOMER */}
        {formData.role === "customer" && (
          <div className="flex flex-col gap-4 animate-in fade-in slide-in-from-top-2 duration-300">
            <input
              type="text"
              placeholder="Phone Number"
              className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white outline-none focus:border-blue-500"
              onChange={(e) =>
                setFormData({ ...formData, phone: e.target.value })
              }
            />
            <textarea
              placeholder="Delivery Address"
              className="bg-slate-900 border border-slate-700 rounded-lg p-3 text-white outline-none focus:border-blue-500 h-20"
              onChange={(e) =>
                setFormData({ ...formData, address: e.target.value })
              }
            />
          </div>
        )}

        <button
          type="submit"
          className="bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-lg transition-all active:scale-95 shadow-lg shadow-blue-900/20"
        >
          Initialize Account
        </button>
      </form>

      {status && (
        <div className="px-4 pb-4 text-center">
          <p className="text-sm font-mono text-blue-400 bg-blue-900/20 py-2 rounded-lg border border-blue-800/30">
            {status}
          </p>
        </div>
      )}
    </div>
  );
}
