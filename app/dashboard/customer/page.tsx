import ProductCard from "../../components/ProductCard";
import Header from "../../components/Header";
import { ShieldCheck } from "lucide-react";
import { CartProvider } from "@/context/CartContext";

export default function CustomerDashboard() {
  const products = [
    {
      id: 1,
      name: "Encryption Key",
      price: 49.0,
      image_url: "/images/encKey.jpg",
      seller: "CyberArmor Ltd",
    },
    {
      id: 2,
      name: "iPhone 17 Pro Max Secure",
      price: 12999.0,
      image_url: "/images/i17.jpg",
      seller: "DataSafe Inc",
    },
  ];

  return (
    <CartProvider>
      <main className="min-h-screen bg-slate-900 text-gray-100 pb-12 md:pb-20">
        <Header />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-6 md:pt-10">
          {/* RESPONSIVE HEADER: Stacked on mobile, side-by-side on tablet+ */}
          <div className="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 md:mb-12 gap-6">
            <div className="space-y-1">
              <h2 className="text-2xl md:text-3xl font-bold tracking-tight">
                Marketplace
              </h2>
              <p className="text-slate-500 text-xs md:text-sm">
                Secure hardware handpicked for your digital vault.
              </p>
            </div>

            {/* PDPA Trust Badge: Self-adjusting width */}
            <div className="flex items-center gap-2 bg-emerald-500/10 border border-emerald-500/20 px-3 py-1.5 md:px-4 md:py-2 rounded-full shadow-sm shadow-emerald-900/20">
              <ShieldCheck className="text-emerald-500 shrink-0" size={14} />
              <span className="text-[9px] md:text-[10px] font-bold text-emerald-500 uppercase tracking-widest whitespace-nowrap">
                PDPA Protected Session
              </span>
            </div>
          </div>

          {/* DYNAMIC GRID: 
              1 col on tiny mobile
              2 cols on standard mobile/small tablet
              3 cols on desktop
              4 cols on large monitors 
          */}
          <div className="grid grid-cols-1 xs:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-6 md:gap-8">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>

          {/* EMPTY STATE (Conditional) */}
          {products.length === 0 && (
            <div className="flex flex-col items-center justify-center py-20 text-center border-2 border-dashed border-slate-800 rounded-3xl">
              <div className="bg-slate-800 p-4 rounded-full mb-4">
                <ShieldCheck className="text-slate-600" size={32} />
              </div>
              <p className="text-slate-400 font-medium">
                No assets found in this region.
              </p>
            </div>
          )}
        </div>

        {/* RESPONSIVE FOOTER */}
        <footer className="mt-12 md:mt-20 px-6 text-center">
          <div className="h-px w-full max-w-xs mx-auto bg-gradient-to-r from-transparent via-slate-700 to-transparent mb-6" />
          <p className="text-[9px] md:text-[10px] text-slate-600 uppercase tracking-[0.2em] font-medium leading-loose">
            End-to-End Encryption Enabled <br className="md:hidden" />
            <span className="hidden md:inline mx-2">•</span>
            ISO 27001 Certified Environment
          </p>
        </footer>
      </main>
    </CartProvider>
  );
}
