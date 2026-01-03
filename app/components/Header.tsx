"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ShoppingCart, Shield, Package, LogOut, Menu, X } from "lucide-react";

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const router = useRouter();

  return (
    <header className="w-full bg-slate-900 border-b border-slate-800">
      {/* --- NAVIGATION --- */}
      <nav className="max-w-7xl mx-auto flex justify-between items-center px-4 md:px-6 py-4 relative">
        <Link href="/" className="flex items-center gap-2 group z-50">
          <div className="bg-blue-600 p-1.5 rounded-lg group-hover:rotate-12 transition-transform">
            <Shield
              className="text-white w-5 h-5 md:w-6 md:h-6" // w-5 = 20px, w-6 = 24px
              fill="currentColor"
            />
          </div>
          <h1 className="text-xl md:text-2xl font-black tracking-tighter text-white">
            VAULT<span className="text-blue-500">KART</span>
          </h1>
        </Link>

        <button className="flex items-center gap-2 px-6 md:px-4 py-3 md:py-2 rounded-lg text-base md:text-sm font-bold text-red-400 bg-red-500/10 border border-red-500/20 hover:bg-red-500 hover:text-white transition-all group">
          <LogOut
            size={18}
            className="group-hover:-translate-x-1 transition-transform"
          />
          Logout
        </button>
      </nav>

      {/* --- HERO SECTION --- */}
      <section className="px-4 md:px-6 py-12 md:py-20 text-center bg-[radial-gradient(circle_at_top,_var(--tw-gradient-stops))] from-blue-900/20 via-slate-900 to-slate-900">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-4xl sm:text-5xl md:text-7xl font-extrabold mb-6 leading-[1.1] bg-gradient-to-r from-blue-400 to-purple-500 bg-clip-text text-transparent">
            Secure Your Finds.
          </h2>
          <p className="text-gray-400 text-base md:text-xl max-w-2xl mx-auto mb-10 px-2">
            The ultimate marketplace where security meets convenience. Every
            transaction is protected by high-level encryption.
          </p>

          <div className="flex flex-col sm:flex-row justify-center gap-4 px-4">
            <Link
              href="/cart"
              className="flex items-center justify-center gap-2 px-8 py-4 bg-blue-600 rounded-full font-bold hover:bg-blue-500 transition shadow-lg shadow-blue-900/20 text-white w-full sm:w-auto"
            >
              <ShoppingCart size={20} />
              View Your Cart
            </Link>

            <Link
              href="/orders"
              className="flex items-center justify-center gap-2 px-8 py-4 bg-slate-800 rounded-full font-bold border border-slate-700 hover:bg-slate-700 transition text-white w-full sm:w-auto"
            >
              <Package size={20} />
              Your Order(s)
            </Link>
          </div>
        </div>
      </section>
    </header>
  );
}
