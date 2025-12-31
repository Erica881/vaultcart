"use client"; // Add this at the top
import { useState } from "react";
import LoginForm from "@/app/components/LoginForm";
import RegisterForm from "@/app/components/RegisterForm";

export default function PublicLandingPage() {
  const [isLogin, setIsLogin] = useState(true); // State to track which form to show

  return (
    <main className="min-h-screen bg-slate-900 text-gray-100">
      <div className="max-w-7xl mx-auto px-6 py-20 grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
        {/* LEFT CONTENT (Introduction) - Keep as is */}
        <div>
          <h1 className="text-6xl font-extrabold tracking-tight mb-6">
            Secure Your <span className="text-blue-500">Digital Assets</span>{" "}
            inside the Vault.
          </h1>
          {/* ... existing description ... */}
        </div>

        {/* AUTHENTICATION BOX */}
        <div className="bg-slate-800 border border-slate-700 p-8 rounded-3xl shadow-2xl transition-all duration-500">
          <div className="mb-8 border-b border-slate-700 pb-4">
            <h2 className="text-2xl font-bold">
              {isLogin ? "Access Portal" : "Create Identity"}
            </h2>
            <p className="text-sm text-slate-500">
              {isLogin
                ? "Select your role to enter the secure zone"
                : "Initialize your secure vault credentials"}
            </p>
          </div>

          {/* Conditional Rendering of Forms */}
          {isLogin ? <LoginForm /> : <RegisterForm />}

          <div className="mt-8 pt-6 border-t border-slate-700 text-center">
            <p className="text-sm text-slate-400">
              {isLogin ? "Don't have an account?" : "Already have an identity?"}{" "}
              <button
                onClick={() => setIsLogin(!isLogin)}
                className="text-blue-500 hover:text-blue-400 font-bold underline transition-colors ml-1"
              >
                {isLogin ? "Register Here" : "Login Here"}
              </button>
            </p>
          </div>
        </div>
      </div>
    </main>
  );
}
