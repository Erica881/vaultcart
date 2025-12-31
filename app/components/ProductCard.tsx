"use client";

import { useCart } from "@/context/CartContext";
import { ShoppingCart, ShieldCheck, CheckCircle } from "lucide-react"; // Added CheckCircle
import { useState } from "react"; // Added useState
import Image from "next/image";
import { Product } from "@/types/product"; // Import here

export default function ProductCard({ product }: { product: Product }) {
  const { addToCart } = useCart();
  const [showSuccess, setShowSuccess] = useState(false); // Code Space: New State

  const handleAddToCart = () => {
    // 1. Run the existing logic
    addToCart({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
    });

    // 2. Show the message
    setShowSuccess(true);

    // 3. Set timer to hide it after 5 seconds
    setTimeout(() => {
      setShowSuccess(false);
    }, 1000);
  };

  return (
    <div className="relative group bg-slate-800 rounded-2xl overflow-hidden border border-slate-700 hover:border-blue-500/50 transition-all duration-300 shadow-xl">
      {/* --- SUCCESS MESSAGE OVERLAY --- */}
      {showSuccess && (
        <div className="absolute inset-0 z-20 flex items-center justify-center bg-slate-900/90 backdrop-blur-sm animate-in fade-in zoom-in duration-300">
          <div className="text-center p-4">
            <CheckCircle className="text-green-500 mx-auto mb-2" size={40} />
            <p className="text-white font-bold text-sm">Added to Vault!</p>
            <p className="text-gray-400 text-[10px]">Checking out soon?</p>
          </div>
        </div>
      )}

      {/* Product Image Area */}
      <div className="relative h-64 bg-slate-700 overflow-hidden">
        <Image
          className="object-cover transition-transform duration-300 group-hover:scale-110"
          src={product.image_url}
          alt={product.name}
          fill
          // className="object-cover"
          sizes="(max-width: 768px) 100vw, 33vw"
        />
        <div className="absolute top-3 left-3 bg-slate-900/80 backdrop-blur-md px-2 py-1 rounded-md flex items-center gap-1 text-[10px] font-bold text-blue-400 border border-blue-500/30">
          <ShieldCheck size={12} /> VERIFIED SELLER
        </div>
      </div>

      {/* Content */}
      <div className="p-5">
        <p className="text-xs text-blue-400 font-mono mb-1 uppercase tracking-widest">
          {product.seller}
        </p>
        <h3 className="text-lg font-bold text-white mb-2 line-clamp-1">
          {product.name}
        </h3>

        <div className="flex justify-between items-center mt-4">
          <span className="text-2xl font-black text-white">
            ${product.price ? Number(product.price).toFixed(2) : "0.00"}
          </span>
          {/* ONLY show the button if a buyer is logged in */}

          <button
            onClick={handleAddToCart}
            className="bg-blue-600 p-3 rounded-xl hover:bg-blue-500 text-white transition-colors shadow-lg"
          >
            <ShoppingCart size={20} />
          </button>

          {/* </div> */}
        </div>
      </div>
    </div>
  );
}
