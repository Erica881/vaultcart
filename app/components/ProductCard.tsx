"use client";

import { useCart } from "@/context/CartContext";
import { ShoppingCart, ShieldCheck, CheckCircle } from "lucide-react";
import { useState } from "react";
import Image from "next/image";

// types/product.ts
export interface Product {
  id: number;
  name: string;
  price: number;
  seller: string;
  image_url: string;
}

export default function ProductCard({ product }: { product: Product }) {
  const { addToCart } = useCart();
  const [showSuccess, setShowSuccess] = useState(false);

  const handleAddToCart = () => {
    // Add to cart without checking for auth/buyer status
    addToCart({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
    });

    // Show visual feedback
    setShowSuccess(true);

    // Hide feedback after 1 second
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
            <p className="text-gray-400 text-[10px]">
              Ready for secure checkout
            </p>
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

          {/* Always show the button for the demo */}
          <button
            onClick={handleAddToCart}
            className="bg-blue-600 p-3 rounded-xl hover:bg-blue-500 text-white transition-all active:scale-90 shadow-lg"
            aria-label="Add to cart"
          >
            <ShoppingCart size={20} />
          </button>
        </div>
      </div>
    </div>
  );
}
