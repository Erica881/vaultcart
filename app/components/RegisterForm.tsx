"use client";
import { useState } from "react";

export default function RegisterForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    phone: "",
    address: "",
    cardNumber: "",
    role: "customer",
  });

  const [hasConsent, setHasConsent] = useState(false);
  const [showConsentError, setShowConsentError] = useState(false); // New validation state
  const [status, setStatus] = useState("");
  const [loading, setLoading] = useState(false);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();

    // PDPA Validation: If no consent, show error and stop
    if (!hasConsent) {
      setShowConsentError(true);
      setStatus(
        "❌ Action Required: Please accept the data processing consent."
      );
      return;
    }

    setShowConsentError(false);
    setLoading(true);
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
        setTimeout(() => {
          window.location.href = "/";
        }, 1500);
      } else {
        setStatus("❌ Error: " + data.error);
      }
    } catch (err) {
      setStatus("❌ Network Error.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full">
      <form onSubmit={handleRegister} className="flex flex-col gap-4">
        {/* ... (Role Selection, Name, Email, Password fields remain the same) ... */}

        {/* ROLE SELECTION */}
        <div className="flex flex-col gap-1">
          <label className="text-[10px] uppercase tracking-widest text-slate-500 ml-1 font-bold">
            Identity Type
          </label>
          <select
            value={formData.role}
            onChange={(e) => setFormData({ ...formData, role: e.target.value })}
            className="w-full bg-slate-900 border border-slate-700 rounded-xl p-3 text-white focus:ring-2 focus:ring-blue-500 outline-none transition-all"
          >
            <option value="customer">Customer (Buyer)</option>
            <option value="seller">Seller (Vendor)</option>
          </select>
        </div>

        <input
          type="text"
          placeholder="Full Name"
          required
          className="w-full bg-slate-900 border border-slate-700 rounded-xl p-3 text-white outline-none focus:ring-2 focus:ring-blue-500"
          onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        />

        <input
          type="email"
          placeholder="Email Address"
          required
          className="w-full bg-slate-900 border border-slate-700 rounded-xl p-3 text-white outline-none focus:ring-2 focus:ring-blue-500"
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        />

        <input
          type="password"
          placeholder="Security Password"
          required
          className="w-full bg-slate-900 border border-slate-700 rounded-xl p-3 text-white outline-none focus:ring-2 focus:ring-blue-500"
          onChange={(e) =>
            setFormData({ ...formData, password: e.target.value })
          }
        />

        {/* ... (Conditional Fields for Seller/Customer) ... */}
        {formData.role === "seller" ? (
          <div className="space-y-2">
            <input
              type="text"
              placeholder="Merchant Card Number"
              className="w-full bg-slate-900 border border-emerald-900/50 rounded-xl p-3 text-emerald-400 outline-none"
              onChange={(e) =>
                setFormData({ ...formData, cardNumber: e.target.value })
              }
            />
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            <input
              type="text"
              placeholder="Phone Number"
              className="w-full bg-slate-900 border border-slate-700 rounded-xl p-3 text-white"
              onChange={(e) =>
                setFormData({ ...formData, phone: e.target.value })
              }
            />
          </div>
        )}

        {/* STRUCTURED PDPA CONSENT SECTION */}
        <div
          className={`mt-2 p-4 rounded-xl border transition-colors ${
            showConsentError
              ? "bg-red-900/10 border-red-500/50"
              : "bg-slate-900/50 border-slate-700/50"
          }`}
        >
          <div className="flex items-start gap-4">
            <div className="flex items-center h-5">
              <input
                type="checkbox"
                id="consent"
                checked={hasConsent}
                onChange={(e) => {
                  setHasConsent(e.target.checked);
                  if (e.target.checked) setShowConsentError(false);
                }}
                className="h-5 w-5 rounded border-slate-600 bg-slate-800 text-blue-500 focus:ring-blue-500 cursor-pointer"
              />
            </div>
            <div className="flex flex-col gap-1">
              <label
                htmlFor="consent"
                className="text-xs font-semibold text-slate-200 cursor-pointer"
              >
                Data Processing Agreement
              </label>
              <p className="text-[11px] text-slate-400 leading-normal">
                I agree to the collection of my personal information for
                authentication and security purposes under the
                <a
                  href="/privacy"
                  className="text-blue-500 hover:underline ml-1"
                >
                  Privacy Policy
                </a>
                .
              </p>
            </div>
          </div>
        </div>

        {/* SUBMIT BUTTON */}
        <button
          type="submit"
          disabled={loading}
          className={`w-full font-bold py-3 rounded-xl transition-all active:scale-95 shadow-lg 
            ${
              hasConsent
                ? "bg-blue-600 hover:bg-blue-500 text-white shadow-blue-900/20"
                : "bg-slate-700 text-slate-400 cursor-not-allowed"
            }`}
        >
          {loading ? "Initializing..." : "Initialize Account"}
        </button>
      </form>

      {/* FEEDBACK MESSAGE AREA */}
      {status && (
        <div className="mt-4 text-center">
          <p
            className={`text-xs font-mono py-2 px-4 rounded-lg border animate-in fade-in zoom-in duration-300
            ${
              status.includes("✅")
                ? "text-emerald-400 bg-emerald-900/20 border-emerald-800/30"
                : "text-red-400 bg-red-900/20 border-red-800/30"
            }`}
          >
            {status}
          </p>
        </div>
      )}
    </div>
  );
}
